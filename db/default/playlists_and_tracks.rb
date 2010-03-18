  require "populator"

  [NewsItem, Newsship, NewsCategory].each(&:delete_all)

  # Добавляем категории новостей + новости в этих категориях + связи между новостяни и категориями

    Playlist.populate 5 do |playlist|
      playlist.title = Populator.words(2..4)
      playlist.description = Populator.paragraphs(1)
      user_id = 2
      Track.populate 5 do |track|
        track.title = Populator.words(1..2)
        track.author = Populator.words(1..2)
        track.data_file_size = Populator.value_in_range(1..100)
        track.playlist_id = playlist.id
        track.user_id = 2
        track.state = ["moderation", "banned", "active"]
      end
    end

