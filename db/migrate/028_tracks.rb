class Tracks < ActiveRecord::Migration
  def self.up
  create_table "tracks" do |t|
    t.string   "title"
    t.string   "author"
    t.integer  "bitrate"
    t.boolean  "tracks",            :default => true,  :null => false
    t.boolean  "delta",             :default => true,  :null => false
    t.integer  "user_id"
    t.string   "statev"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.string   "data_remote_url"
    t.integer  "count_downloads",   :default => 0
    t.string   "check_sum"
    t.integer  "rating",            :default => 0
    t.integer  "satellite_id"
    t.boolean  "was_paid",          :default => false
  end

  add_index "tracks", ["title"], :name => "index_tracks_on_title"
  end
 def self.down
   drop_table :tracks
 end
end
