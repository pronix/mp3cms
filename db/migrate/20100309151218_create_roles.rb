class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string  :name,   :limit => 40
      t.text    :description     # описание группы
      t.boolean :system, :defailt => false # системная группа удалять нельзя
    end

    create_table :roles_users, :id => false, :force => true do |t|
      t.references  :user
      t.references  :role
    end

  end

  def self.down
    drop_table :roles
    drop_table :roles_users
  end
end
