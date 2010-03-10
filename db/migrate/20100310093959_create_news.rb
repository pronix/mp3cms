class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.string :header
      t.string :text
      t.text   :content
      t.string :meta
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end

