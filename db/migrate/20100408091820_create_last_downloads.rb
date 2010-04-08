class CreateLastDownloads < ActiveRecord::Migration
  def self.up
    create_table :last_downloads do |t|
      t.column :track_id, :integer
      t.column :num, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :last_downloads
  end
end
