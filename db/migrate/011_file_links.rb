class FileLinks < ActiveRecord::Migration
  def self.up
  create_table "file_links", :force => true do |t|
    t.integer  "track_id"
    t.integer  "user_id"
    t.integer  "speed"
    t.string   "file_name",    :null => false
    t.string   "file_path",    :null => false
    t.string   "file_size",    :null => false
    t.string   "content_type", :null => false
    t.string   "link",         :null => false
    t.string   "ip",           :null => false
    t.datetime "expire",       :null => false
    t.string   "state",        :null => false
  end
  end
 def self.down
   drop_table :file_links
 end
end


