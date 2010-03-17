  require "populator"

  [Playlist, NewsItem, Track, Lastsearch, User, Newsship, NewsCategory].each(&:delete_all)

  Lastsearch.populate 40 do |lastsearch|
    lastsearch.search_string = Populator.words(2..5)
    lastsearch.site_attributes = ["everywhere", "title", "author"]
    lastsearch.site_section = "mp3"
  end

