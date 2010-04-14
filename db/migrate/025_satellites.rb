class Satellite < ActiveRecord::Migration
  def self.up
  create_table "satellites", :force => true do |t|
    t.string   "name"
    t.string   "ip"
    t.string   "domainname"
    t.text     "description"
    t.boolean  "master",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      :default => false
    t.string   "community"
  end
  end
 def self.down
   drop_table :satellites
 end 
end


