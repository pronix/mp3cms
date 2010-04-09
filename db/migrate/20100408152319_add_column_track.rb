class AddColumnTrack < ActiveRecord::Migration
  def self.up
    add_column(:tracks, :rating, :integer, :default => "0")
  end

  def self.down
    remote_column(:tracks, :rating)
  end
end
