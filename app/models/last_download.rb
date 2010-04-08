class LastDownload < ActiveRecord::Base

  after_create :delete_old_rows

  belongs_to :track, :counter_cache => :rating

  def self.add_download_track(id)
    self.create!(:track_id => id)
  end

  # Выборка для "Топ Mp3"
  def self.top_track
    arr = {}
    distinctlist = self.find(:all).map{ |i| i.track_id }.uniq
    distinctlist.each {|i|
      num_track = self.find(:all, :conditions => ["track_id = ?", i.id])
      temp = {"#{i}" => num_track.size }
      arr.merge!(temp)
    }
    rez_track = arr.sort {|a,b| b[1]<=>a[1]}

    track_id = []

    rez_track.each { |i|
      track_id << i[0]
    }
    Track.find(track_id)
  end

  private

  def delete_old_rows
    old_track = LastDownload.find(:all, :conditions => ["created_at < ?", 1.weeks.ago])
    LastDownload.destroy(old_track)
  end
end
