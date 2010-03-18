class RemoveDimensionFromTrack < ActiveRecord::Migration
  def self.up
    remove_column :tracks, :dimension
  end

  def self.down
    add_column :tracks, :dimension, :integer
  end
end

