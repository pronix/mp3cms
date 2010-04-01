require "populator"

[Track].each(&:delete_all)

#Track.populate 100 do |track|
#  track.title = Populator.words(2..4)
#  track.author = Populator.words(1..2)
#  track.bitrate = [128, 192, 168]
#  track.delta = 1
#  track.user_id = 1
#  track.state = "active"
#end

