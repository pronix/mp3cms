class AddCountDownloadsToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :count_downloads, :integer, :default => '0'
  end

  def self.down
    remove_column :tracks, :count_downloads
  end
end

