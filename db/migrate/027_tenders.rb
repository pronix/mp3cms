class Tenders < ActiveRecord::Migration
  def self.up
  create_table "tenders", :force => true do |t|
    t.string   "link"
    t.boolean  "complete",   :default => false
    t.integer  "order_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  end
 def self.down
   drop_table :tenders
 end
end
