class AddFileseparatorToTrack < ActiveRecord::Migration
  def self.up
    add_column :tracks, :fileseparator, :string
  end

  def self.down
    remove_column :tracks, :fileseparator, :string
  end
end
