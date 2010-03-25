class AddFtpPasswordToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :ftp_password, :string
    add_column :users, :ftp_access, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :users, :ftp_password
    remove_column :users, :ftp_access
  end
end
