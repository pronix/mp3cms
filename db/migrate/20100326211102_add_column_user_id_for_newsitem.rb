class AddColumnUserIdForNewsitem < ActiveRecord::Migration
  def self.up
    add_column(:news_items, :user_id, :integer)
  end

  def self.down
    remove_column(:news_items, :user_id, :integer)
  end
end

