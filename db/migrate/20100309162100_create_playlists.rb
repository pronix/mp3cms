class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists do |t|
      t.string    :title
      t.text      :description
      t.string    :icon_file_name
      t.string    :icon_content_type
      t.integer   :icon_file_size
      t.datetime  :icon_updated_at
      t.integer   :user_id

      t.boolean   :playlists, :default => true, :null => false
      t.boolean   :delta, :default => true, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :playlists
  end
end

