class AddSatelliteidToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :satellite_id, :integer
  end

  def self.down
    remove_column :tracks, :satellite_id
  end
end
