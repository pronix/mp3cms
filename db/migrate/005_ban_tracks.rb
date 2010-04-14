class BanTracks < ActiveRecord::Migration
  def self.up
  create_table "ban_tracks", :force => true do |t|
    t.string   "check_sum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  end

  def self.down
    drop_table :ban_tracks
  end
end
