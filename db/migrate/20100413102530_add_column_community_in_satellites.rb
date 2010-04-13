class AddColumnCommunityInSatellites < ActiveRecord::Migration
  def self.up
    add_column(:satellites, :community, :string)
  end

  def self.down
    remove_column(:satellites, :community)
  end
end
