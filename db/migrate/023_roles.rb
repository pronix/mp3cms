class CheckTender < ActiveRecord::Migration
  def self.up
  create_table "roles", :force => true do |t|
    t.string  "name",        :limit => 40
    t.text    "description"
    t.boolean "system"
    t.string  "title"
    t.text    "permissions"
  end
  end
 def self.down
   drop_table :roles
 end 
end


