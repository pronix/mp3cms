class Order < ActiveRecord::Base

  validates_presence_of :user_id, :author, :title, :floor, :language, :music, :more
  validates_presence_of :floor, :message => 'Пол исполнения имеет неверное значение'
  validates_presence_of :language, :message => 'Язык исполнения имеет неверное значение'
  validates_presence_of :music, :message => 'Музыка имеет неверное значение'

  belongs_to :user
  has_many :tenders, :order => "id desc", :dependent => :destroy

end

