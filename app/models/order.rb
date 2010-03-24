require 'aasm'

class Order < ActiveRecord::Base

  validates_presence_of :user_id, :author, :title, :state, :voice, :language, :music
  validates_inclusion_of :voice, :in => ['male','female','different'], :message => 'Голос имеет неверное значение'
  validates_inclusion_of :language, :in => ['ru','en','other'], :message => 'Язык исполнения имеет неверное значение'
  validates_inclusion_of :music, :in => ['regular','film','cartoon','advertising'], :message => 'Музыка имеет неверное значение'

  belongs_to :user
  #has_one :tender
  has_many :tenders, :order => "id desc", :dependent => :destroy

  include AASM
      aasm_column :state
      aasm_initial_state :notfound
      aasm_state :notfound
      aasm_state :found
      aasm_event :to_found do
        transitions :to => :found, :from => [:notfound, :found]
      end
      aasm_event :to_notfound do
        transitions :to => :notfound, :from => [:notfound, :found]
      end
end

