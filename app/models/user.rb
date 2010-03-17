class User < ActiveRecord::Base

  attr_accessible :login, :email, :password, :password_confirmation, :icq, :webmobey_purse, :captcha_challenge, :current_login_ip, :last_login_ip
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
    set_property :delta => true, :threshold => Settings[:delta_index]
  end


  # Associations
  belongs_to :referrer, :class_name => "User"
  has_and_belongs_to_many :roles

  has_many :playlists
  has_many :comments
  has_many :tracks
  has_many :file_links

  # Validations
  validates_format_of :webmoney_purse, :with => /^Z[0-9]{12}/, :allow_nil => true, :allow_blank => true
  validates_format_of :icq, :with => /\d+/, :allow_nil => true, :allow_blank => true
  validates_presence_of :login


  # callback
  after_create :add_default_role

  # named_scope
  default_scope :order => "id"
  named_scope :bans, :conditions => { :ban => true }
  named_scope :active, :conditions => {:active => true}
  named_scope :inactive, :conditions => {:active => false}


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
    save
  end


  # ------- Блокировка пользователя -------
  # валидация при блокировки пользователя
  def valid_block(params)
    errors.clear
    errors.add(:term_ban, :invalid)  if params[:term_ban].blank? || params[:term_ban].to_i == 0
    errors.add_on_blank(:ban_reason) if params[:ban_reason].blank?
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
    save!
  end

  # Разблокировка пользователя
  def unblock!
    self.ban = false
    self.start_ban, self.end_ban, self.ban_reason = nil, nil, nil
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
    self.file_links(:conditions => {:track_id => track.id}).first
  end

end

