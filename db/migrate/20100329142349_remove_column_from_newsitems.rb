class RemoveColumnFromNewsitems < ActiveRecord::Migration
  def self.up
    remove_column(:news_items, :news_category_id)
  end

  def self.down
    add_column(:news_items, :news_category_id, :integer)
  end
end

