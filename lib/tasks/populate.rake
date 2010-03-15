namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
  require "populator"
  require "faker"

   [Playlist, NewsItem, Track, Lastsearch, User].each(&:delete_all)

    NewsCategory.populate 5 do |news_category|
      news_category.name = Populator.words(2..4).titleize
      NewsItem.populate 10 do |newsitem|
        newsitem.header = Populator.words(2..4).titleize
        newsitem.text = Populator.words(20..30).titleize
        newsitem.meta = Populator.words(4..7).titleize
        newsitem.news_category_id = news_category.id
        Newsship.populate 1 do |newsship|
          newsship.news_category_id = news_category.id
          newsship.news_item_id = newsitem.id
        end
      end
    end


    User.populate 10 do |user|
      user.login = Faker::Name.name
      user.email = Faker::Internet.email
      user.active = true
      user.icq = Populator.interpret_value(99999999)
      user.balance = Populator.value_in_range(11..99)
      user.total_withdrawal = Populator.value_in_range(11..99)
      user.last_login_ip = ["234.221.4.1", "234.221.4.2", "234.221.4.2"]
      user.current_login_ip = ["234.221.4.1", "234.221.4.2", "234.221.4.4"]
      Playlist.populate 3 do |playlist|
        playlist.title = Populator.words(1.5)
        playlist.description = Populator.words(30..50)
        playlist.user_id = user.id
        Track.populate 40 do |track|
          track.title = Populator.words(2..7)
          track.author = Populator.words(1..3)
          track.bitrate = [128, 192, 168, 224, 320]
          track.dimension = Populator.value_in_range(30..90)
          track.user_id = user.id
          track.playlist_id = playlist.id
          track.state = ["active", "moderation", "banned"]
        end
      end
    end

    Lastsearch.populate 40 do |lastsearch|
      lastsearch.search_string = Populator.words(2..5)
      lastsearch.site_attributes = ["everywhere", "title", "author"]
      lastsearch.site_section = "mp3"
    end

  end
end

