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

      #aasm_event :to_active do
      #  transitions :to => :active, :from => [:moderation, :banned]
      #end
      #aasm_event :to_banned do
      #  transitions :to => :banned, :from => [:active, :moderation]
      #end
      #aasm_event :to_moderation do
      #  transitions :to => :moderation, :from => [:active, :banned]
      #end
end

