class Gateways < ActiveRecord::Migration
  def self.up
  create_table "gateways" do |t|
    t.string   "type",                           :null => false
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => false
    t.text     "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sms",         :default => false
  end
  end
 def self.down
   drop_table :gateways
 end 
end


