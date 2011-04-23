class Order < ActiveRecord::Base
  LANGUAGE = %w( Русский Английский Немецкий Испанский Итальянский Французский Китайский Японский Неопределенный)
  FLOOR    = %w( Мужской Женский Оба Хор )
  MUSIC    = ['Из кинофильма', 'Народная песня', 'Другая']
  validates_presence_of :user_id, :author, :title, :more
  validates_inclusion_of :floor,    :in => Order::FLOOR, :message => ' исполнения имеет неверное значение'
  validates_inclusion_of :language, :in => Order::LANGUAGE, :message => ' исполнения имеет неверное значение'
  validates_inclusion_of :music,    :in => Order::MUSIC, :message => ' имеет неверное значение'

  belongs_to :user
  has_many :tenders, :order => "id desc", :dependent => :destroy
  named_scope :found, :conditions =>  ["state = ?", "found"], :order => "created_at DESC"
  named_scope :notfound, :conditions =>  ["state = ?", "notfound"], :order => "created_at DESC"

  def found?
    self.state == 'found'
  end
  def notfound?
    self.state == 'notfound'
  end

end

