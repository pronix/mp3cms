class Comment < ActiveRecord::Base

  validates_presence_of :comment

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  default_scope :order => 'created_at DESC'
  #acts_as_voteable

  belongs_to :user

end

