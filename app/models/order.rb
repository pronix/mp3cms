

class Order < ActiveRecord::Base

  validates_presence_of :user_id, :author, :title, :state, :floor, :language, :music
  validates_format_of :floor, :with => /[1-2]/, :message => 'Пол исполнения имеет неверное значение'
  validates_format_of :language, :with => /[0-9]/, :message => 'Язык исполнения имеет неверное значение'
  validates_format_of :music, :with => /[1-3]/, :message => 'Музыка имеет неверное значение'

  belongs_to :user
  has_many :tenders, :order => "id desc", :dependent => :destroy


end

