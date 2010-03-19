  require "populator"
  require 'faker'

  [Playlist, Track].each(&:delete_all)

  # Добавляем категории новостей + новости в этих категориях + связи между новостяни и категориями


  User.populate 1 do |user|
    user.id = 2
    user.email = Faker::Internet.email
    user.balance = [3,5,6,8]
    user.login = Faker::Name.name
    user.active = true
    user.password_salt = "MBdB_21h3IDzr63RDxIb"
    user.crypted_password = "92c8e189627993f5698af73641cc273db0eb4c70bde1a56a30a7612a62bbbeb8163793d1e9447f9ea1c7f6bedf199eff4d713bccdd8fe33638ae42e79db5623c"
    user.webmoney_purse = Populator.value_in_range(111111111111..999999999999)
    user.perishable_token = "11111111111111111111"
    user.login_count = 0
    user.total_withdrawal = 0
    user.users = 0
    user.delta = false
  end

    Playlist.populate 5 do |playlist|
      playlist.title = Populator.words(2..4)
      playlist.description = Populator.paragraphs(1)
      playlist.user_id = 2
      Track.populate 30 do |track|
        track.title = Populator.words(1..2)
        track.author = Populator.words(1..2)
        track.data_file_size = Populator.value_in_range(1..100)
        track.playlist_id = playlist.id
        track.user_id = 2
        track.state = ["moderation", "banned", "active"]
        track.bitrate = [128, 168, 192, 324]
      end
    end

