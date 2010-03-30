class AddStateForNewsitem < ActiveRecord::Migration
  def self.up
    add_column(:news_items, :state, :string)
  end

  def self.down
    remove_column(:news_items, :state)
  end
end

