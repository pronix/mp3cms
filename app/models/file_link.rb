require 'aasm'

class FileLink < ActiveRecord::Base

  validates_presence_of :track_id, :user_id, :file_name, :file_path, :file_size, :content_type, :link, :ip, :expire, :state
  belongs_to :track
  belongs_to :user

  include AASM
      aasm_column :state
      aasm_initial_state :available

      # Доступна для скачивания
      aasm_state :available

      # Файл качается
      aasm_state :swings

      # Скачивание приостановлено
      aasm_state :suspended

      # Файл скачан
      aasm_state :download

      # Срок действия ссылки истек
      aasm_state :expired

      aasm_event :to_swings do
        transitions :to => :swings, :from => [:available, :suspended]
      end
      aasm_event :to_suspend do
        transitions :to => :suspend, :from => [:swings]
      end
      aasm_event :to_download do
        transitions :to => :download, :from => [:swings]
      end
      aasm_event :to_expired do
        transitions :to => :expired, :from => [:available, :swings, :download]
      end

  def build_content_type(format)
    case format
      when "mp3"
        "audio/mp3"
      when "doc"
        "application/doc"
      when "rar"
        "application/x-rar-compressed"
      when "txt"
        "text/plain"
      else
        "audio/mp3"
    end
  end

end

