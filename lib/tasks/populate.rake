namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
  require "populator"
  require "faker"

   [Playlist, NewsItem, Track, Lastsearch].each(&:delete_all)

    NewsItem.populate 40 do |newsitem|
      newsitem.header = Populator.words(2..4).titleize
      newsitem.text = Populator.words(20..30).titleize
      newsitem.meta = Populator.words(4..7).titleize
    end

    Playlist.populate 40 do |playlist|
      playlist.title = Populator.words(1.5)
      playlist.description = Populator.words(30..50)
    end

    Track.populate 40 do |track|
      track.title = Populator.words(2..7)
      track.author = Populator.words(1..3)
      track.bitrate = [128, 192, 168, 224, 320]
    end

    Lastsearch.populate 40 do |lastsearch|
      lastsearch.search_string = Populator.words(2..5)
      lastsearch.site_attributes = ["everywhere", "title", "author"]
      lastsearch.site_section = "mp3"
    end

  end
end

