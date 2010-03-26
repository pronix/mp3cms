  require "populator"

  [Lastsearch].each(&:delete_all)

  Lastsearch.populate 1000 do |lastsearch_track|
    lastsearch_track.url_string = Populator.words(1.2)
    lastsearch_track.url_attributes = ["author title","author","title"]
    lastsearch_track.url_model = "track"
    lastsearch_track.num = Populator.value_in_range(1..9999)
  end

  Lastsearch.populate 1000 do |news_item|
    news_item.url_string = Populator.words(1.2)
    news_item.url_model = "news_item"
    news_item.num = Populator.value_in_range(1..9999)
  end

  Lastsearch.populate 1000 do |playlist|
    playlist.url_string = Populator.words(1.2)
    playlist.url_model = "playlist"
    playlist.num = Populator.value_in_range(1..9999)
  end


  Lastsearch.populate 1000 do |playlist|
    playlist.url_string = Populator.words(1.2)
    playlist.url_model = "playlist"
    playlist.num = Populator.value_in_range(1..9999)
    playlist.created_at = 2.week.ago.to_s(:db)
    playlist.updated_at = 2.week.ago.to_s(:db)
  end

