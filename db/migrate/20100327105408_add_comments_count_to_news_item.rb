class AddCommentsCountToNewsItem < ActiveRecord::Migration
  def self.up
    add_column :news_items, :comments_count, :integer, :default => 0
    add_column :playlists,  :comments_count, :integer, :default => 0
    NewsItem.reset_column_information
    NewsItem.all.each do |nw_i|
      nw_i.update_attribute :comments_count, nw_i.comments.length
    end
    Playlist.reset_column_information
    Playlist.all.each do |nw_i|
      nw_i.update_attribute :comments_count, nw_i.comments.length
    end
  end

  def self.down
    remove_column :playlists, :comments_count
    remove_column :news_items, :comments_count
  end
end
