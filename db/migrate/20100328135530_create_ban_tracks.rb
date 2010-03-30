class CreateBanTracks < ActiveRecord::Migration
  def self.up
    create_table :ban_tracks do |t|
      t.string :check_sum

      t.timestamps
    end
  end

  def self.down
    drop_table :ban_tracks
  end
end
