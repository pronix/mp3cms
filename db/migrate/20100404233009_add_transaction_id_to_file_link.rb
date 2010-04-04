class AddTransactionIdToFileLink < ActiveRecord::Migration
  def self.up
    add_column :file_links, :transaction_id, :integer
  end

  def self.down
    remove_column :file_links, :integer
  end
end
