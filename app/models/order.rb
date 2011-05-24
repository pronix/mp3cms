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


  state_machine :state, :initial => :moderation do



    event :to_active do
      transition :moderation => :notfound
    end

    event :to_found do
      transition :notfound => :found
    end

    event :to_cancel do
      transition [ :moderation, :notfound ] => :cancel
    end

    state :moderation, :value => 0
    state :notfound,   :value => 1
    state :found,      :value => 2
    state :cancel,     :value => 3


  end

end

