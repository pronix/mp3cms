class TagClouds < ActiveRecord::Migration
  def self.up
  create_table "tag_clouds", :force => true do |t|
    t.string   "url_string"
    t.string   "url_attributes"
    t.string   "url_model"
    t.integer  "font_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  end
 def self.down
   drop_table :tag_clouds
 end
end
