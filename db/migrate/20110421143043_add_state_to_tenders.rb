class AddStateToTenders < ActiveRecord::Migration
  def self.up
    add_column :tenders, :state, :string, :default => 'unread'
    add_index :tenders, :state
  end

  def self.down
    remove_column :tenders, :state
    remove_index :tenders, :state
  end
end
