class Comment < ActiveRecord::Base
  validates_presence_of :comment

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  default_scope :order => 'created_at DESC'
  #acts_as_voteable

  belongs_to :user
  before_validation :fill_data, :on => :create

  def fill_data
    self.name  ||= self.user.try(:login)
    self.email ||= self.user.try(:email)
  end
end

