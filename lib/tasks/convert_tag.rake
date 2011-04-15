# encoding: utf-8
require 'mp3info'
require 'iconv'

namespace :mp3cms do
  namespace :track_tag => :environment do

    test_utf8 = Iconv.new('UTF-8', 'UTF-8')
    convert_to_utf8 = Iconv.new('UTF-8//IGNORE', 'WINDOWS-1251')
    Track.transaction do
    Track.all.each do |track|
      puts track.id
      if File.exists? track.data.path
        Mp3Info.open(track.data.path) do |mp3|
          begin
            test_utf8.iconv(mp3.tag.title)
            test_utf8.iconv(mp3.tag.artist)
          rescue
            track.title = convert_to_utf8.iconv(mp3.tag.title)
            track.author = convert_to_utf8.iconv(mp3.tag.artist)
            track.save
          end
        end
      end
    end
    end

  end
end
