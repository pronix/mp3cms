=begin rdoc
Генерируеме метода для пополнения баланса пользователя внутренними платежами:
credit_find_track - пополнение баланса за выполнение задания в столе заказов
credit_add_news - пополнение баланса за дополнение путевой новости
credit_upload_track - - пополнение баланса за загрузку нормального трека

Генерируеме метода для списанияс баланса пользователя внутренними платежами:
debit_assorted_track  -  списание с баланса пользователя за нарезку трека
debit_download_track  -  списание с баланса пользователя за скачивание трека
debit_order_track     -  списание с баланса пользователя за размещение заказа в столе заказов

Все методы списания, пополнеия принимают один аргумент комментарий или массив комментариев
Подробное описание в методах lib/balance.rb

=end
class User < ActiveRecord::Base
  include Balance
  FTP_PATH = File.join(Rails.root, 'data', 'ftp')
  attr_accessible :login, :email, :password, :password_confirmation, :icq, :webmoney_purse, :captcha_challenge, :current_login_ip, :last_login_ip, :balance, :total_withdrawal
  attr_accessor :term_ban

  acts_as_authentic do |c|
    c.login_field = 'email'
  end

  define_index do
    indexes login, :sortable => true
    indexes email
    indexes balance
    indexes id
    indexes last_login_ip
    indexes current_login_ip
    indexes webmoney_purse
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

  # Associations
  belongs_to :referrer, :class_name => "User"
  has_and_belongs_to_many :roles

  has_many :orders
  has_many :tenders
  has_many :playlists
  has_many :comments
  has_many :tracks
  has_many :archives
  has_many :archive_links
  has_many :playlist_tracks, :through => :playlists
  has_many :transactions do

    # Вывод денег
    def withdraw(_amount)
      create({
                :date_transaction => Time.now.to_s(:db),
                :type_payment     => Transaction::FOREIGN,
                :type_transaction => Transaction::DEBIT,
                :kind_transaction => Transaction::WITHDRAW,
                :gateway          => Transaction::GATEWAY_WEBMONEY,
                :amount           => _amount,
                :comment          => I18n.t("withdraw_over_webmoney"),

              })
    end

    # Перечислить денег насчёт пользователя и сделать соответствующию запись в транзакциях
    # user_id - id пользователя
    # transaction_comment - комментарий к транзакции
    # amount - Сколько денег перечислить
    # kind_transaction - Пока не знаю, что такое...

    def get_cash(user_id, transaction_comment, amount, kind_transaction)
      Transaction.create!(:user_id => user_id, :comment => transaction_comment, :amount => amount, :kind_transaction => kind_transaction  )
      user = User.find(user_id)
      balance = user.balance + amount
      user.update_attribute(:balance, balance)
      user.save!
    end

    # пополнение баланса через webmoney
    def refill_balance_over_webmoney(amount)
      refill_balance({
                       :amount => amount,
                       :gateway => Transaction::GATEWAY_WEBMONEY,
                       :comment => "Пополнение через Webmoney",
                       :kind_transaction => Transaction::REFILL_BALANCE_WEBMONEY
                     })
    end
    # пополнение баланса через webmoney
    def refill_balance_over_mobilcent(amount)
      refill_balance({
                       :amount => amount,
                       :gateway => Transaction::GATEWAY_MOBILCENT,
                       :comment => "Пополнение через Mobilcent",
                       :kind_transaction => Transaction::REFILL_BALANCE_SMS
                     })
    end
    def refill_balance(options)
      create!(options.merge({ :date_transaction => Time.now.to_s(:db),
                              :type_payment     => Transaction::FOREIGN,
                              :type_transaction => Transaction::CREDIT
                            }))
    end
  end
  has_many :file_links


  # Validations
  validates_format_of :webmoney_purse, :with => /^Z[0-9]{12}/, :allow_nil => true, :allow_blank => true
  validates_format_of :icq, :with => /\d+/, :allow_nil => true, :allow_blank => true
  validates_presence_of :login
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password, :on => :create

  # callback
  after_create      :add_default_role
  after_create      :create_ftp_account
  after_destroy     :delete_ftp_account
  before_validation :set_ftp_password


  def self.add_one_download(user_id)
    user = User.find(user_id)
    user.update_attribute(:total_download, user.total_download + 1)
    user.save!
  end

  # Создаем учетную запись ftp
  def create_ftp_account
    FileUtils.mkdir_p File.join(FTP_PATH, email), :mode => 0777
  end
  # Удаляем учетную запись ftp
  def delete_ftp_account
    FileUtils.rm_rf File.join(FTP_PATH, email)
  end
  # Установка пароля для ftp доступ
  def set_ftp_password
    self.ftp_access = upload_on_ftp?
    self.ftp_password = Digest::MD5.hexdigest(password.to_s) unless password.blank?
  end

  # named_scope
  default_scope :order => "id"
  named_scope :bans, :conditions => { :ban => true }
  named_scope :active, :conditions => {:active => true}
  named_scope :inactive, :conditions => {:active => false}
  named_scope :ip_ban, :conditions => { :type_ban => Settings[:type_ban]["ip_ban"] }
  named_scope :account_ban, :conditions => { :type_ban => Settings[:type_ban]["account_ban"] }

  def self.search_user(query, per_page)
    unless query[:q].empty?
      case query[:attribute]
        when "login"
          self.search :conditions => { :login => query[:q] }, :per_page => per_page, :page => query[:page]
        when "email"
          self.search :conditions => { :email => query[:q] }, :per_page => per_page, :page => query[:page]
        when "ip"
          self.search "@(last_login_ip,current_login_ip) #{query[:q]}", :match_mode => :extended
        when "id"
          self.search :conditions => { :id => query[:q] }, :per_page => per_page, :page => query[:page]
        when "balance"
          self.search :conditions => { :webmoney_purse => query[:q] }, :per_page => per_page, :page => query[:page]
      else
        self.search query[:q], :per_page => per_page, :page => query[:page]
      end
    else
      []
    end
  end

  def add_default_role
    add_role(:user)
  end

  def signup!(params)
    self.login                 = params[:user][:login]
    self.email                 = params[:user][:email]
    self.password              = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]

    self.icq                   = params[:user][:icq]
    self.webmoney_purse        = params[:user][:webmoney_purse]
    self.captcha_solution      = params[:user][:captcha_solution]
    self.captcha_challenge     = params[:user][:captcha_challenge]
    save_without_session_maintenance
  end

  def activate!
    self.active = true
    self.playlists.create!(:title => "Без названия")
    save
  end


  # ------- Блокировка пользователя -------
  # валидация при блокировки пользователя
  def valid_block(params)
    errors.clear
    errors.add(:term_ban, :invalid)   if params[:term_ban].blank? || params[:term_ban].to_i == 0
    errors.add_on_blank(:ban_reason)  if params[:ban_reason].blank?
    errors.add_on_blank(:type_ban)    if params[:type_ban].blank?
    errors.add(:type_ban, :inclusion) unless Settings[:type_ban]["value_for_valid"].include?(params[:type_ban].to_i)
    errors.blank?
  end

  # срок бана в днях
  def term_ban_in_days
    (self.end_ban.blank? || self.start_ban.blank?) ? 0 :
      ((self.end_ban - self.start_ban)/1.days).to_i
  end

  def term_ban=(d)
    self.ban = true
    self.start_ban = Time.now.to_s(:db)
    self.end_ban  = (Time.now+d.to_i.days).end_of_day.to_s(:db)
  end
  # блокируем пользователя
  def block!(params)
    self.term_ban = params[:term_ban]
    self.ban_reason = params[:ban_reason]
    self.type_ban = params[:type_ban]
    save!
  end

  # Разблокировка пользователя
  def unblock!
    self.ban = false
    self.start_ban, self.end_ban, self.ban_reason, self.type_ban = nil, nil, nil, nil
    save!
  end
  # ------- Блокировка пользователя -------

  # deliver
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end


  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def get_roles
    self.roles.collect {|role|
      role.name
    }.join("/")
  end

  # roles
  def has_role?(role)
    self.roles.count(:conditions => ["name = ?", role.to_s]) > 0
  end

  # user.add_role("admin")
  def add_role(role)
    return if self.has_role?(role)
    self.roles << Role.find_by_name(role.to_s)
  end

  def remove_role(role)
    return false unless self.has_role?(role)
    role = Role.find_by_name(role)
    self.roles.delete(role)
  end

  def admin?
    @_roles ||= roles
    self.has_role?("admin") ||
      @_roles.any? { |x| x.permissions[:admin] == true  if x.permissions }
  end


  # permissions
  def role_symbols
    (roles || []).map do |role|
      if role.name.start_with?("custom")
        Role::BOOL_PERMISSIONS.map{ |x| "custom_#{x}".underscore.to_sym if send("#{x}?")}
      else
        [
         Role::BOOL_PERMISSIONS.map{ |x| "custom_#{x}".underscore.to_sym if send("#{x}?")},
         role.name.underscore.to_sym ]
      end
    end.flatten.compact
  end

  (Role::BOOL_PERMISSIONS-[:admin]).each do |method_name|
    define_method "#{method_name}" do
      @_roles ||= roles
      @_roles.any? { |x| x.permissions[method_name] == true  if x.permissions }
    end
    alias_method "#{method_name}?", "#{method_name}"
  end

  Role::VALUE_PERMISSIONS.each do |method_name|
    define_method "#{method_name}" do
      @_roles ||= roles
      @_roles.max { |x| x.permissions[method_name]  if x.permissions }
    end
  end

  # tracks
  def file_link_of(track)
    self.file_links.find(:first, :conditions => ["track_id = ? and state = ?", track.id, 'available'])
  end

  # Массив треков в корзине
  def cart_tracks
    tracks = []
    cart_tracks = CartTrack.find(:all, :conditions => {:user_id => self.id})
    cart_tracks.each do |cart_track|
      track = Track.find(cart_track.track_id)
      tracks << track if track
    end
    tracks
  end

  # Добавление файлов в корзину
  def add_to_cart(params_track_ids)
    params_track_ids.to_a.each do |track_id|
      track_in_cart = CartTrack.find(:first, :conditions => ["track_id = ? and user_id = ?", track_id, self.id])
      unless track_in_cart
        cart_track = CartTrack.new(:track_id => track_id, :user_id => self.id) unless self.cart_tracks.include?(track_id)
        cart_track.save if cart_track
      end
    end
  end

  # Удаление файлов из корзины
  def delete_from_cart(params_track_ids)
    params_track_ids.to_a.each do |track_id|
      track = Track.find(track_id)
      if track
        cart_track = CartTrack.find(:first, :conditions => {:track_id => track.id, :user_id => self.id})
        cart_track.destroy
      end
    end
  end

  class << self
    # Топ пользователей по балансу
    def top_balance
      all :conditions => ["balance > 0"], :order => "balance DESC", :limit => (AppSetting.top_users rescue 5 )
    end
  end

end

