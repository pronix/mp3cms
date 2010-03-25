  require "populator"

  [TagCloud].each(&:delete_all)

#  TagCloud.populate 11 do |track|
#    track.url_string = Populator.words(1..2)
#    track.url_attributes = ["title", "author title", "author"]
#    track.url_model = "track"
#    track.font_size = Populator.value_in_range(10..25)
#  end

#  TagCloud.populate 5 do |news|
#    news.url_string = Populator.words(1..2)
#    news.url_model = "news_item"
#    news.font_size = Populator.value_in_range(10..25)
#  end

#  TagCloud.populate 5 do |playlist|
#    playlist.url_string = Populator.words(1..2)
#    playlist.url_model = "playlist"
#    playlist.font_size = Populator.value_in_range(10..25)
#  end

