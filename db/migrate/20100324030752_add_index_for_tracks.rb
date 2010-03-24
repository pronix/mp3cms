class AddIndexForTracks < ActiveRecord::Migration
  def self.up
    add_index(:tracks, :title, :length => 1)
  end

  def self.down
  end
end

