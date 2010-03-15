class CreateNews < ActiveRecord::Migration

  def self.up
    create_table :news do |t|
      t.string :header
      t.text :text
      t.string :meta
      t.integer :news_category_id
      t.boolean   :news, :default => true, :null => false
      t.boolean   :delta, :default => true, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end

