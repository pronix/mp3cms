class CheckTender < ActiveRecord::Migration
  def self.up
  create_table "check_tenders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  end
 def self.down
   drop_table :check_tenders
 end 
end
