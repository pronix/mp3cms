class AddDeltaForModelLastsearch < ActiveRecord::Migration
  def self.up
    add_column :lastsearches, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column(:lastsearches, :delta)
  end
end

