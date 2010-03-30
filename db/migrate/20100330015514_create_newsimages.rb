class CreateNewsimages < ActiveRecord::Migration
  def self.up
    create_table :newsimages do |t|
      t.column :photo_file_name,    :string
      t.column :photo_content_type, :string
      t.column :photo_file_size,    :integer
      t.column :photo_updated_at,   :datetime
      t.column :news_item_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :newsimages
  end
end

