class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = 'email'
    c.validates_length_of_password_field_options = {:minimum => 6, :on => :update, :if => :has_no_credentials? }
    c.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
  end

  # Associations
  belongs_to :referrer, :class_name => "User"
  has_many :user_roles, :dependent => :destroy
  has_many :roles, :through => :user_roles

  # Validations

  # named_scope
  named_scope :bans, :conditions => { :ban => true }
  named_scope :active, :conditions => {:active => true}
  named_scope :inactive, :conditions => {:active => false}

  attr_accessible :login, :email, :password, :password_confirmation, :icq, :webmobey_purse

end
