class CartTrack < ActiveRecord::Migration
  def self.up
  create_table "cart_tracks", :force => true do |t|
    t.integer "user_id"
    t.integer "track_id"
  end
  end

  def self.down
    drop_table :cart_tracks
  end
end
