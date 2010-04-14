class Lastsearches < ActiveRecord::Migration
  def self.up
  create_table "lastsearches", :force => true do |t|
    t.string   "url_string"
    t.string   "url_attributes"
    t.string   "url_model"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num"
    t.boolean  "delta",          :default => true, :null => false
  end
  end
 def self.down
   drop_table :lastsearches
 end
end


