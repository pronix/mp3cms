class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.column :avatar_file_name,    :string
      t.column :avatar_content_type, :string
      t.column :avatar_file_size,    :integer
      t.column :avatar_updated_at,   :datetime

      t.column :imageable_id, :integer
      t.column :imageable_type, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end

