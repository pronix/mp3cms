class Mp3Cut
  CUT_PATH = File.join(Rails.root, 'tmp', 'mp3_cut')
  class << self
    def cut(track, from, to)
      word= Array.new(100){ ['A'..'Z'].map{ |r| r.to_a }.flatten[ rand( ['A'..'Z'].map{ |r| r.to_a }.flatten.size ) ] }.join
      time_range = [convert_seconds(from), convert_seconds(to)].flatten
      tmp_file = FileUtils.mkdir_p(CUT_PATH) && File.join(CUT_PATH, Digest::MD5.hexdigest([ Time.now.to_i, @word ].join))

      command = "#{Settings[:mp3_cut_command]} -o #{tmp_file} -t %02d:%02d:%02d+000-%02d:%02d:%02d+000 #{track.data.path.gsub(' ','\ ')}"%time_range

      `#{command}`
      return tmp_file

    end

    # получаем из секунд часы, минуты, секунды
    def convert_seconds(t)
      t = t.to_i
      h = (t/1.hours).to_i
      m = ((t-h.hours)/1.minute).to_i
      s = ((t-h.hours - m.minutes)/1.second).to_i
      [h,m,s]
    end

  end # end class << self

end
