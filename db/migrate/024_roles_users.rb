class CheckTender < ActiveRecord::Migration
  def self.up
  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end
  end
 def self.down
   drop_table :roles_users
 end 
end


