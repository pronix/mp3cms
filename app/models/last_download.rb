class LastDownload < ActiveRecord::Base
  belongs_to :track
  def self.add_download_track(id)
    LastDownload.find_by_created_at(1.weeks.ago).destroy
    last_download_track = LastDownload.find(:first, :conditions => ["track_id = ?", id])
    if last_download_track
      last_download_track.update_attribute(:num, last_download_track.num + 1)
      last_download_track.save
    else
      self.create!(:track_id => id, :num => 1)
    end

  end

  # Выборка для "Топ Mp3"
  def self.top_track
    self.find(:all).collect {|i| i.track }
  end
end
