class AddSortFieldsToPlaylistsTracks < ActiveRecord::Migration
  def self.up
    add_column :playlists_tracks, :parent_id, :integer
    add_column :playlists_tracks, :lft, :integer
    add_column :playlists_tracks, :rgt, :integer
  end

  def self.down
    remove_column :playlists_tracks, :parent_id
    remove_column :playlists_tracks, :lft
    remove_column :playlists_tracks, :rgt
  end
end

