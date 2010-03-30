class AddCheckSumToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :check_sum, :string
  end

  def self.down
    remove_column :tracks, :check_sum
  end
end

