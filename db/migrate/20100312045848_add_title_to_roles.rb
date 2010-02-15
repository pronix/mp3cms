class AddTitleToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :title, :string
  end

  def self.down
    remove_column :roles, :title
  end
end
