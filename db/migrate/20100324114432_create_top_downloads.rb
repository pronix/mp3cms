class CreateTopDownloads < ActiveRecord::Migration
  def self.up
    create_table :top_downloads do |t|
      t.integer   :count_downloads, :default => '0'
      t.datetime  :last_download
      t.integer   :track_id
    end
  end

  def self.down
    drop_table :top_downloads
  end
end

