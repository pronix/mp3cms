class AddIndexCheckSumToTrack < ActiveRecord::Migration
  def self.up
    add_index :tracks, :check_sum
  end

  def self.down
    remove_index :tracks, :check_sum
  end
end
