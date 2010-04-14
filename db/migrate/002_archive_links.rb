class ArchiveLink < ActiveRecord::Migration
  def self.up
  create_table "archive_links", :force => true do |t|
    t.integer  "archive_id"
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
  def self.up
    drop_table :archive_links
  end
end
