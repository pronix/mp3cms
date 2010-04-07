require 'aasm'

class ArchiveLink < ActiveRecord::Base

  validates_presence_of :archive_id, :user_id, :file_name, :file_path, :file_size, :content_type, :link, :ip, :expire, :state
  belongs_to :archive
  belongs_to :user

  include AASM
      aasm_column :state
      aasm_initial_state :available

      # Доступен для скачивания
      aasm_state :available

      # Архив качается
      aasm_state :swings

      # Скачивание приостановлено
      aasm_state :suspended

      # Архив скачан
      aasm_state :download

      # Срок действия ссылки истек
      aasm_state :expired

      aasm_event :to_available do
        transitions :to => :available, :from => [:swings, :suspended, :download]
      end
      aasm_event :to_swings do
        transitions :to => :swings, :from => [:available, :download]
      end
      aasm_event :to_suspend do
        transitions :to => :suspend, :from => [:swings, :suspended]
      end
      aasm_event :to_download do
        transitions :to => :download, :from => [:swings]
      end
      aasm_event :to_expired do
        transitions :to => :expired, :from => [:available, :swings, :download]
      end

  # получение модели линка через env["PATH_INFO"]
  def self.envfind(str)
    file_link_id = /(\w{32})/.match(str).to_s
    file_link = self.find_by_link(file_link_id)
  end
end

