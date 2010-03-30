class DropTablePlaylistsTracks < ActiveRecord::Migration
  def self.up
    drop_table :playlists_tracks
  end

  def self.down
    create_table :playlists_tracks, :id => false do |t|
      t.integer :playlist_id
      t.integer :track_id
    end
  end
end

