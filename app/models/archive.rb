require 'zip/zip'
require 'zip/zipfilesystem'

class Archive < ActiveRecord::Base

  validates_presence_of :user_id, :data
  belongs_to :user
  has_many :archive_links

  has_attached_file :data,
                    :url  => "/archives/:id/:basename.:extension",
                    :path => ":rails_root/data/archives/:id/:basename.:extension"

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 1000.megabytes
  validates_attachment_content_type :data, :content_type => ['application/zip', 'application/x-zip', 'application/x-zip-compressed']

  def create_archive_magick(params_track_ids, user)
    # если несколько одинаковых файлов в архиве - то добавляем только один
    params_track_ids.uniq!
    # Задаем секретную строку для будущего названия файла
    secret = Digest::MD5.hexdigest Time.now.to_i.to_s
    # задаем расположение временного файла
    zip_filename = "#{RAILS_ROOT}/tmp/#{secret}.zip"
    # Создаем zip файл
    Zip::ZipFile.open(zip_filename, Zip::ZipFile::CREATE) {  |zipfile|
      # Принимаем коллекцию треков
      self.tracks(params_track_ids).collect { |track|
        if File.exists? track.data.path
          # Добавляем каждый трек в архив
          zipfile.add( "Mp3Koza-#{track.id}-#{track.data_file_name}", track.data.path)
          # увеличиваем счетчик скачиваний трека на 1
          track.recount_top_download

          # Делаем отметку в транзакциях о том, что трек скачен и деньги сняты
          user.debit_download_track("Трек скачен")

          # Добавляем трек в таблицу скаченных(тужна для Топ mp3)
          LastDownload.add_download_track(track.id)

          # Прибавить к щётчику скаченых треков пользователем +1
          User.add_one_download(user.id)
        end
      }
    }
    # Устанавливаем права доступа на файл
    File.chmod(0644, zip_filename)
    # Создаем объект файла архива
    self.data = File.new(zip_filename)
    if self.save
      # Удаляем временный файл
      File.delete(zip_filename)
    end
  end

  def tracks(params_track_ids)
    tracks = []
    params_track_ids.to_a.each do |track_id|
      track = Track.find(track_id)
      tracks << track if track
    end
    tracks
  end

  def generate_archive_link(user, ip)
    return nil unless user
    archive_link = user.archive_links.build :archive_id => self.id,
                          :file_name => self.data_file_name,
                          :file_path => self.data.path,
                          :file_size => self.data_file_size,
                          :content_type => self.data_content_type,
                          :link => "".secret_link(ip),
                          :ip => ip,
                          :expire => 1.week.from_now
    archive_link.save
  end

end

