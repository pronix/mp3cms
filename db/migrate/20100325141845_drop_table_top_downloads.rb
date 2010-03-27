class DropTableTopDownloads < ActiveRecord::Migration
  def self.up
    drop_table :top_downloads
  end

  def self.down
    create_table :top_downloads do |t|
      t.integer   :count_downloads, :default => '0'
      t.datetime  :last_download
      t.integer   :track_id
    end
  end
end

