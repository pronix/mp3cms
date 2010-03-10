class AddPlaylists < ActiveRecord::Migration
  def self.up
    Playlist.create(:title => "play list 1", :description => "Мой плейлист", :icon_file_name => "/system/1/origin/avatar.jpg")
    Playlist.create(:title => "play list 2", :description => "Мой плейлист 2", :icon_file_name => "/system/1/origin/avatar.jpg")
    Playlist.create(:title => "play list 3", :description => "Мой плейлист 3", :icon_file_name => "/system/1/origin/avatar.jpg")
  end

  def self.down
    Playlist.delete_all
  end
end

