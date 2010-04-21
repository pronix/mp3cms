class Transactions < ActiveRecord::Migration
  def self.up
  create_table "transactions" do |t|
    t.integer  "user_id",                                                           :null => false
    t.datetime "date_transaction",                                                  :null => false
    t.decimal  "amount",           :precision => 10, :scale => 2, :default => 0.0,  :null => false
    t.string   "comment"
    t.string   "kind_transaction"
    t.integer  "type_payment"
    t.integer  "type_transaction"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gateway"
    t.string   "status"
    t.boolean  "delta",                                           :default => true, :null => false
  end
  end
 def self.down
   drop_table :transactions
 end
end
