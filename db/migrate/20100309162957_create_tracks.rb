class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string  :title
      t.string  :author
      t.integer :bitrate
      t.integer :dimension
      t.integer :playlist_id
      t.boolean   :tracks, :default => true, :null => false
      t.boolean   :delta, :default => true, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end

