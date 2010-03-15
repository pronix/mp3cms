class AddDataRemoteUrlToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :data_remote_url, :string
  end

  def self.down
    remove_column :tracks, :data_remote_url
  end
end

