class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.string :header
      t.string :text
      t.string :meta
      t.boolean   :news, :default => true, :null => false
      t.boolean   :delta, :default => true, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end

