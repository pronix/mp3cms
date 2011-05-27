class Track < ActiveRecord::Base

  before_validation :set_satellite, :on => :create

  validates :user_id, :data, :satellite_id, :presence => true
  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 20.megabytes
  validates_attachment_content_type :data,
                                    :content_type => ['application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3'],
                                    :message => I18n.t("must_be_audio")
  validates_presence_of :title, :author, :bitrate


  validates_numericality_of :bitrate, :greater_than_or_equal_to => 128, :on => :create # проверяем битрайт

  # проверяем что в сервисе не записан трек с таким же хешом
  validate :check_sum_uniq, :on => :create
  def check_sum_uniq
    errors.add(:base, "Такой трек уже загружен.") if Track.count(:conditions => { :check_sum => self.check_sum}) > 0
  end

  validate :ban_track?
  # проверяем что хеш по треку не занесен в таблицу блокировок
  def ban_track?
    errors.add(:base, "Трек заблокирован") if BanTrack.count(:conditions => { :check_sum => self.check_sum}) > 0
  end

  # Удаляем лишнии сообщение о авторам трека если есть ошибки по самому треку
  #
  after_validation :clear_errors
  def clear_errors
    if errors.keys.any?{ |x| x.to_s.start_with?("data") }
      errors.delete(:user_id)
      errors.delete(:title)
      errors.delete(:author)
      errors.delete(:bitrate)
    end
  end



  private

  def set_satellite
    self.satellite ||= Satellite.master
  end

end
