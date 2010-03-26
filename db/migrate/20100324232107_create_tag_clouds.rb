class CreateTagClouds < ActiveRecord::Migration
  def self.up
    create_table :tag_clouds do |t|
      t.column :url_string, :string
      t.column :url_attributes, :string
      t.column :url_model, :string
      t.column :font_size, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :tag_clouds
  end
end

