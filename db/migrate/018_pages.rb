class CheckTender < ActiveRecord::Migration
  def self.up
  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  end
 def self.down
   drop_table :pages
 end 
end


