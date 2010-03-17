class RenameNews < ActiveRecord::Migration
  def self.up
    rename_table("news", "news_items")
  end

  def self.down
    rename_table("news_items", "news")
  end
end

