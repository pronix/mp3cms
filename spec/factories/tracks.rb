Factory.define :track do |u|
  u.bitrate "128"
  u.data File.new("#{RAILS_ROOT}/test/files/normal_2.mp3", "rb")
end

