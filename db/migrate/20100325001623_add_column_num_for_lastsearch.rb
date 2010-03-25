class AddColumnNumForLastsearch < ActiveRecord::Migration
  def self.up
    add_column(:lastsearches, :num, :integer )
  end

  def self.down
    remove_column(:lastsearches, :num)
  end
end

