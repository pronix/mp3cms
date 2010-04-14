class Profits < ActiveRecord::Migration
  def self.up
  create_table "profits", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.decimal  "amount",           :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.boolean  "percentage",                                      :default => false, :null => false
    t.string   "type_transaction",                                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  end
 def self.down
   drop_table :profits
 end
end
