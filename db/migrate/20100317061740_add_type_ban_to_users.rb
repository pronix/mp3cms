class AddTypeBanToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :type_ban, :integer
  end

  def self.down
    remove_column :users, :type_ban
  end
end
