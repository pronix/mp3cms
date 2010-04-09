require 'populator'

[Track].each(&:delete_all)

  Track.populate(16) do |track|
    track.title = Populator.words(1..3)
    track.author = Populator.words(1..3)
    track.bitrate = [128, 192, 256]
    track.user_id = 1
    track.state = "active"
    track.count_downloads = Populator.value_in_range(1..20)
    track.tracks = true
    track.delta = true
  end
