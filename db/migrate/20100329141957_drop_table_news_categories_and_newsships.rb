class DropTableNewsCategoriesAndNewsships < ActiveRecord::Migration
  def self.up
    drop_table(:news_categories)
    drop_table(:newsships)
  end

  def self.down
  end
end

