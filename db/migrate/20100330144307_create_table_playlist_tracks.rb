class CreateTablePlaylistTracks < ActiveRecord::Migration
 def self.up
    create_table :playlist_tracks, :id => true do |t|
      t.integer :playlist_id
      t.integer :track_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
    end
  end

  def self.down
    drop_table :playlist_tracks
  end
end

