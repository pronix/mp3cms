class Role < ActiveRecord::Base
  SYSTEM_ROLE = [:admin, :user, :moderator]

  BOOL_PERMISSIONS = [:admin,                     # Доступ в админку - да/нет
                      :add_news_with_moderation,  # Добавление новостей с предмодерацией - да/нет
                      :upload_on_ftp,             # Аплоад на фтп сервер - да/нет
                      :add_mp3,                   # Добавление мп3 на сайт - да/нет
                      :moderation_all_mp3,        # Модерация всех mp3 - да/нет
                      :moderation_your_mp3,       # Модерация своих mp3 - да/нет
                      :free_download,             # Бесплатное скачивание мп3 - да/нет
                      :captcha_before_download,   # Капча перед скачиванием - да/нет
                      :award_points,              # Начислять баллы за действия - да/нет
                      :assorted_mp3,              # Разрешить мод нарезки файла - да/нет
                      :playlist,                  # Разрешить плейлисты - да/нет
                      :comment,                   # Разрешить комментарии - да/нет
                      :captcha_before_comment,    # Капча для камента - да/нет
                     ]

  VALUE_PERMISSIONS =[
                      :count_playlist,            # Кол-во плейлистов - (0 - неограничено)
                      :speed_free_download        # скорось скачивания
                     ]

  PERMISSIONS = [BOOL_PERMISSIONS, VALUE_PERMISSIONS ].flatten

  serialize :permissions, Hash
  has_and_belongs_to_many :users
  after_update :set_access_to_ftp

  # Если у роли меняеться доступ к ftp то нужно поменять доступ у всех пользователей этой группы
  def set_access_to_ftp
    User.update(users.map {|x| x.id if x.upload_on_ftp? }.compact,     {:ftp_access => true} )
    User.update(users.map {|x| x.id unless x.upload_on_ftp? }.compact, {:ftp_access => true} )
  end

  def self.serialized_attr_accessor(args)
    args.each do |method_name|
      method_declarations = <<STRING
        def #{method_name}
          self.permissions ||= {}
          if BOOL_PERMISSIONS.include?(:#{method_name})
            self.permissions[:#{method_name}] || false
          else
            self.permissions[:#{method_name}].to_s
          end
        end
        def #{method_name}=(value)
          self.permissions ||= {}
          if BOOL_PERMISSIONS.include?(:#{method_name})
            self.permissions[:#{method_name}] = (value.to_s == "0" || value == false) ? false : true
          else
            self.permissions[:#{method_name}] = value.to_s
          end
        end

STRING
    method_declarations <<  "alias_method :#{method_name}?, :#{method_name}" if BOOL_PERMISSIONS.include?(method_name)
      eval method_declarations
    end
  end

  serialized_attr_accessor PERMISSIONS

  # Associations
  has_and_belongs_to_many :users

  # Validations
  validates :name, :presence => true

  # callback
  before_destroy :move_users


  # before_validation :set_name, :on => :create

  def move_users
    unless users.blank?
      @user_role = Role.find_by_name("user")
      users.each { |e| e.add_role(@user_role.name); e.save }
    end
  end

  # def set_name
  #   if self.name.blank? || !SYSTEM_ROLE.include?(self.name.to_sym)
  #     self.name = [ "custom", Time.now.to_i ].join("_")
  #     self.system = false
  #   end
  # end

end
