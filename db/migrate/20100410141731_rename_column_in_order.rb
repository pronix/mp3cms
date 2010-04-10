class RenameColumnInOrder < ActiveRecord::Migration
  def self.up
    rename_column(:orders, :voice, :floor)
  end

  def self.down
    rename_column(:orders, :floor, :voice)
  end
end
