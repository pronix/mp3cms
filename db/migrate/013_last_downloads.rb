class LastDownloads < ActiveRecord::Migration
  def self.up
  create_table "last_downloads", :force => true do |t|
    t.integer  "track_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  end
 def self.down
   drop_table :last_downloads
 end
end


