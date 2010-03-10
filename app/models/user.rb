class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = 'email'
    # c.validates_length_of_password_field_options = {:minimum => 6, :on => :update, :if => :has_no_credentials? }
    # c.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
  end

  # Associations
  belongs_to :referrer, :class_name => "User"
  has_many :user_roles, :dependent => :destroy
  has_many :roles, :through => :user_roles

  # Validations
  validates_format_of :webmoney_purse, :with => /^Z[0-9]{12}/, :allow_nil => true, :allow_blank => true
  validates_format_of :icq, :with => /\d+/, :allow_nil => true, :allow_blank => true

  # named_scope
  named_scope :bans, :conditions => { :ban => true }
  named_scope :active, :conditions => {:active => true}
  named_scope :inactive, :conditions => {:active => false}

  attr_accessible :login, :email, :password, :password_confirmation, :icq, :webmobey_purse


  def signup!(params)
    self.login                 = params[:user][:login]
    self.email                 = params[:user][:email]
    self.password              = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    self.icq                   = params[:user][:icq]
    self.webmoney_purse        = params[:user][:webmoney_purse]
    save_without_session_maintenance
  end

  def activate!
    self.active = true
    save
  end

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
end

