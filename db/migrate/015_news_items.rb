class NewsItems < ActiveRecord::Migration
  def self.up
  create_table "news_items" do |t|
    t.string   "header"
    t.text     "text"
    t.string   "meta"
    t.boolean  "news",                :default => true, :null => false
    t.boolean  "delta",               :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "comments_count",      :default => 0
    t.string   "state"
  end
  end
 def self.down
   drop_table :news_items
 end
end


