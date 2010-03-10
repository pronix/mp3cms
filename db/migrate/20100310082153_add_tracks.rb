class AddTracks < ActiveRecord::Migration
  def self.up
    Track.create(:title => "Sleep All Day", :author => "jason marz", :bitrate => 128, :dimension => 23000)
    Track.create(:title => "Too Much Food", :author => "jason marz", :bitrate => 128, :dimension => 23000)
    Track.create(:title => "You And I Food", :author => "jason marz", :bitrate => 128, :dimension => 23000)
    Track.create(:title => "Rescue Me", :author => "Badboe", :bitrate => 128, :dimension => 23000)
  end

  def self.down
    Track.delete_all
  end
end

