class Pictures < ActiveRecord::Migration
  def self.up
  create_table "pictures" do |t|
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  end
 def self.down
   drop_table :pictures
 end
end


