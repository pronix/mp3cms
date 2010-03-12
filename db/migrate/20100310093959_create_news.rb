class CreateNews < ActiveRecord::Migration

  validates_presence_of :header, :text, :meta

  def self.up
    create_table :news do |t|
      t.string :header
      t.text :text
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

