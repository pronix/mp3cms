class Users < ActiveRecord::Migration
  def self.up
  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.string   "perishable_token",                                 :default => "",    :null => false
    t.integer  "login_count",                                      :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.boolean  "active",                                           :default => false
    t.boolean  "admin",                                            :default => false
    t.string   "icq"
    t.string   "webmoney_purse"
    t.decimal  "balance",           :precision => 10, :scale => 4, :default => 0.0,   :null => false
    t.decimal  "total_withdrawal",  :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.boolean  "ban",                                              :default => false
    t.datetime "start_ban"
    t.datetime "end_ban"
    t.text     "ban_reason"
    t.integer  "referrer_id"
    t.boolean  "users",                                            :default => true,  :null => false
    t.boolean  "delta",                                            :default => true,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_ban"
    t.string   "ftp_password"
    t.boolean  "ftp_access",                                       :default => false, :null => false
    t.integer  "total_download",                                   :default => 0
  end

  add_index "users", ["ban"], :name => "index_users_on_ban"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  end
 def self.down
   drop_table :users
 end 
end


