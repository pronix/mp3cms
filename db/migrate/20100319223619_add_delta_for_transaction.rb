class AddDeltaForTransaction < ActiveRecord::Migration
  def self.up
    add_column :transactions, :delta, :boolean, :default => true, :null => false
  end

  def self.down
  end
end

