  require "populator"

  [Lastsearch].each(&:delete_all)

  Lastsearch.populate 100 do |lastsearch_track|
    lastsearch_track.url_string = Populator.words(1.2)
    lastsearch_track.url_attributes = ["everywhere","author","title"]
    lastsearch_track.url_model = "track"
    lastsearch_track.num = Populator.value_in_range(1..99)
  end

  Lastsearch.populate 100 do |lastsearch_track|
    lastsearch_track.url_string = Populator.words(1.2)
    lastsearch_track.url_model = "news_item"
    lastsearch_track.num = Populator.value_in_range(1..99)
  end

  Lastsearch.populate 100 do |lastsearch_track|
    lastsearch_track.url_string = Populator.words(1.2)
    lastsearch_track.url_model = "playlist"
    lastsearch_track.num = Populator.value_in_range(1..99)
  end

