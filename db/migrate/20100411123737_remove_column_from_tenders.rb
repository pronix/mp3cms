class RemoveColumnFromTenders < ActiveRecord::Migration
  def self.up
    remove_column(:tenders, :complete)
  end

  def self.down
    add_column(:tenders, :complete, :boolean, :default => false)
  end
end
