class AddColumnInTrack < ActiveRecord::Migration
  def self.up
    add_column(:tracks, :was_paid, :boolean, :default => false)
  end

  def self.down
    remove_column(:tracks, :was_paid)
  end
end
