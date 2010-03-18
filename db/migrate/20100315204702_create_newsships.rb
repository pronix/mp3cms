class CreateNewsships < ActiveRecord::Migration
  def self.up
    create_table :newsships do |t|
      t.integer :news_category_id
      t.integer :news_item_id
      t.timestamps
    end
  end

  def self.down
    drop_table :newsships
  end
end

