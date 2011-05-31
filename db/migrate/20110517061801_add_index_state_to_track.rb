class AddIndexStateToTrack < ActiveRecord::Migration
  def self.up
    add_index :tracks, :state
  end

  def self.down
    remove_index :tracks, :state
  end
end
