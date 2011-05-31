class AddIndexUserIdToTrack < ActiveRecord::Migration
  def self.up
    add_index :tracks, :user_id
  end

  def self.down
    remove_index :tracks, :user_id
  end
end
