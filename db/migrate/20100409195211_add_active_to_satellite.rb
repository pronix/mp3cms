class AddActiveToSatellite < ActiveRecord::Migration
  def self.up
    add_column :satellites, :active, :boolean, :default => false
  end

  def self.down
    remove_column :satellites, :active
  end
end
