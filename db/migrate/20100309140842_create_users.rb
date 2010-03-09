class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      # --------- authlogic
      t.string   :login, :email, :crypted_password, :password_salt,
                 :persistence_token, :last_login_ip, :current_login_ip

      t.string   :perishable_token, :default => '', :null => false
      t.integer  :login_count, :default => 0, :null => false
      t.datetime :last_request_at, :last_login_at, :current_login_at
      t.boolean  :active, :default => false
      # --------- end authlogic

      t.boolean  :admin, :default => false
      t.string   :icq
      t.string   :webmoney_purse


      t.decimal :balance, :precision => 10, :scale => 2, :null => false, :default => 0       # баланс пользователя (остаток)
      t.decimal :total_withdrawal, :precision => 10, :scale => 2, :null => false, :default => 0   # выплаченная сумма пользов

      t.boolean  :ban, :default => false # пользователь забаннен
      t.datetime :start_ban   # дата бана
      t.datetime :end_ban     # окончание бана
      t.text     :ban_reason  # причина бана


      t.timestamps
    end
    add_index :users, :email
    add_index :users, :persistence_token
    add_index :users, :last_request_at
    add_index :users, :perishable_token
    add_index :users, :ban
  end

  def self.down
    drop_table :users
    remove_index :users, :email
    remove_index :users, :persistence_token
    remove_index :users, :last_request_at
    remove_index :users, :perishable_token
    remove_index :users, :ban
  end
end
