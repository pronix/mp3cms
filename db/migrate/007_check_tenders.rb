class CheckTenders < ActiveRecord::Migration
  def self.up
  create_table "check_tenders" do |t|
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
