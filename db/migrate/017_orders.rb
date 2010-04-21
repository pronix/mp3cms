class Orders < ActiveRecord::Migration
  def self.up
  create_table "orders" do |t|
    t.string   "title"
    t.string   "author"
    t.string   "floor"
    t.string   "language"
    t.string   "music"
    t.string   "state"
    t.text     "more"
    t.integer  "user_id"
    t.integer  "tender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  end
 def self.down
   drop_table :orders
 end
end


