class Order < ActiveRecord::Base
  LANGUAGE = %w( Русский Английский Немецкий Испанский Итальянский Французский Китайский Японский Неопределенный)
  FLOOR    = %w( Мужской Женский Оба Хор )
  MUSIC    = ['Из кинофильма', 'Народная песня', 'Другая']

  validates_presence_of :user_id, :author, :title, :more
  validates_length_of :title, :maximum=> 50
  validates_length_of :author, :maximum=> 50
  validates_inclusion_of :floor,    :in => Order::FLOOR, :message => ' исполнения имеет неверное значение'
  validates_inclusion_of :language, :in => Order::LANGUAGE, :message => ' исполнения имеет неверное значение'
  validates_inclusion_of :music,    :in => Order::MUSIC, :message => ' имеет неверное значение'

  belongs_to :user
  has_many :tenders, :order => "id desc", :dependent => :destroy
  scope :found,    where(:state => "found").order("created_at DESC")
  scope :notfound, where(:state => "notfound").order("created_at DESC")


  include AASM
  aasm_column :state
  aasm_initial_state :moderation
  aasm_state :moderation
  aasm_state :notfound
  aasm_state :found
  aasm_state :cancel

  aasm_event :to_active do
    transitions :to => :notfound, :from => :moderation
  end

  aasm_event :to_found do
    transitions :to => :found, :from => :notfound
  end

  aasm_event :to_cancel do
    transitions :to => :cancel, :from => [:moderation, :notfound]
  end



  def found?
    self.state == 'found'
  end

  def notfound?
    self.state == 'notfound'
  end

end

