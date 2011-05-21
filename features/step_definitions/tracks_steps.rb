
def find_track(title)
  Track.find_by_title(title)
end

def user_tracks(user_login)
  user = User.find_by_login(user_login)
  tracks = Track.find(:all, :conditions => {:user_id => user.id})
  return tracks
end

def user_playlists(user_login)
  user = User.find_by_login(user_login)
  playlists = Playlist.find(:all, :conditions => {:user_id => user.id})
  return playlists
end

def tracks_by_titles(track_titles)
  tracks = []
  track_titles.split(", ").each do |track_title|
    track = Track.find_by_title(track_title)
    tracks << track if track
  end
  tracks
end

When /^я выберу треки "([^\"]*)"$/ do |title_tracks|
  @tracks = Track.where(:title => title_tracks.split(',').map(&:strip))
  @tracks.map{ |t|
    with_scope("#track_#{t.id}") { check("track_ids[]") }
  }
end

Given /^скачено "([^\"]*)" раза "([^\"]*)"$/ do |num, title|
  track = Track.find_by_title(title)
  1.upto(num.to_i) {|i|
    LastDownload.create!(:track_id => track.id)
  }
end

Given /^в сервисе есть следующие треки$/ do |table|
  hash = table.hashes()
  hash.each {|i|
    Track.create(
      :title => i[:title],
      :author => i[:author],
      :bitrate => i[:bitrate],
      :dimension => i[:dimension],
      :playlist_id => i[:playlist_id]
    )
  }
end


Then /^загружены следующие треки:$/ do |table|
  table.hashes.each do |hash|
    user = User.find_by_email(hash["user_email"])
    satellites = Satellite.find(:all)
    options = {
      :user_id => user.id,  :title => hash["title"],
      :author => hash["author"], :data_file_name => "track.mp3" }
    options[:data_file_size] = hash["data_file_size"] if hash["data_file_size"]
    options[:bitrate] = hash["bitrate"] if hash["bitrate"]
    options[:id] = hash["id"] if hash["id"]
    options[:count_downloads] = hash["count_downloads"] if hash["count_downloads"]
    options[:check_sum] = hash["title"].to_s.to_md5
    options[:satellite_id] = rand(10)
    track = Factory.create(:track, options)
    track.check_sum = Digest::MD5.hexdigest((Time.now - ([1,2,3,4].rand).days).to_i.to_s )
    track.send("to_#{hash["state"]}!".to_sym) if hash["state"][/active|banned/]
    if hash["playlist"]
      playlist = Playlist.find_by_title(hash["playlist"])
      track.playlists << playlist
      track.save
    end
  end
end

Given /^загружены в систему следующие треки:$/ do |table|
  table.hashes.each do |hash|
    Given %(я зашел в сервис как "#{hash["user_email"]}/secret")
    And %(я на странице админки просмотра плейлиста "#{hash["playlist"]}")
    When %(я введу в поле "track_1[title]" значение "#{hash["title"]}") if hash["title"]
    And %(я введу в поле "track_1[author]" значение "#{hash["author"]}") if hash["author"]
    file_name = hash["file_name"].blank? ? "normal_2.mp3" : hash["file_name"]
    And %(я прикреплю файл "test/files/#{file_name}" в поле "track_1[data]")
    And %(я нажму "track_submit")
    #И %(треку "#{hash["title"]}" присвоен статус "#{hash["state"]}") if hash["state"]
    if hash["file_name"]

      track = Track.find_by_data_file_name(file_name)
      track.state = hash["state"] unless hash["state"].blank?
      track.check_sum = "#{hash["title"]}".to_md5
      track.save
    end
    And %(я вышел из системы)
  end
end

Then /^я забаню файл "([^\"]*)"$/ do |track_title|
  # put complete_admin_tracks_path, {"banned" => "Забанить", "track_ids" => ["#{find_track(track_title).id}"]}
  pennding
end

Given /^забанены треки:$/ do |table|
  table.hashes.each do |hash|
    Given %(я войду в систему как администратор)
    And %(я на странице управления треками)
    And %(я перейду по ссылке "Активные")
    And %(я установлю флажок в "track_ids[]")
    And %(я нажму "banned")
    And %(я вышел из системы)
  end
end

Then /^треку "([^\"]*)" присвоен статус "([^\"]*)"$/ do |track, state|
  track = find_track(track)
  track.to_active if state == "active"
  track.to_banned if state == "banned"
  track.save
end

Then /^я увижу следующие треки:$/ do |table|
  table.hashes.each do |hash|
    @track = Track.find_by_title(hash["Название"].strip)
    And %(я увижу "#{hash["Исполнитель"]}" в "#track_#{@track.id}")
    And %(я увижу "#{hash["Название"]}" в "#track_#{@track.id}")
    And %(я увижу "#{hash["Скачано"]}" в "#track_#{@track.id}") if hash["Скачано"]
  end
end

Then /^я увижу треки:$/ do |table|
  table.hashes.each_with_index do |hash, index|
    And %(я увижу "#{hash["Исполнитель"]}")
    And %(я увижу "#{hash["Название"]}")
  end
end

When /^я введу в поле "([^\"]*)" ссылки для треков "([^\"]*)"$/ do |field, track_titles|
  tracks = []
  track_titles.split(", ").each do |track_title|
    track = find_track(track_title)
    tracks << track_url(track)
  end
  And %(я введу в поле "#{field}" значение "#{tracks.join("\n")}")
end

Then /^я увижу следующие треки в таблице:$/ do |expected_tracks_table|
  expected_tracks_table.diff!(tableish('table#tracks tr', 'td,th'))
end

Then /^трек "([^\"]*)" принадлежит пользователю "([^\"]*)"$/ do |track, user_email|
  user = User.find_by_email(user_email)
  find_track(track).user_id.should == user.id
end

Then /^фай\w+ "([^\"]*)" буд\w+ забан\w+$/ do |track_titles|
  track_titles.split(", ").each do |title|
    find_track(title).state.should == "banned"
  end
end

Then /^фай\w+ "([^\"]*)" буд\w+ актив\w+$/ do |track_titles|
  track_titles.split(", ").each do |title|
    find_track(title).state == "active"
  end
end

Then /^фай\w+ "([^\"]*)" буд\w+ удал\w+$/ do |track_titles|
  track_titles.split(", ").each do |title|
    find_track(title).nil?
  end
end

When /^трек "([^\"]*)" пройдет модерацию$/ do |track_title|
  track = find_track(track_title)
  track.to_active
  track.save
end

Then /^я увижу песню "([^\"]*)" в плейлисте "([^\"]*)"$/ do |song, playlist|
  playlist = Playlist.find_by_title(playlist)
  visit playlist_path(playlist)
  And %(я увижу "#{song}" в "#tracks")
end

Then /^размер песни "([^\"]*)" будет ([0-9]+) б$/ do |track, dimension|
  find_track(track).data_file_size.should == dimension.to_i
end

Then /^битрейт песни "([^\"]*)" будет ([0-9]+) кбит\/с$/ do |track, bitrate|
  find_track(track).bitrate.should == bitrate.to_i
end

When /^я прикреплю ([0-9]+) фай\w+$/ do |count_files|
  Array.new(count_files.to_i).each_index do |index|
    And %(я введу в поле "track_#{index+1}[title]" значение "Трек #{index+1}")
    And %(я прикреплю файл "test/files/normal_#{index+1}.mp3" в поле "track_#{index+1}[data]")
  end
end

When /^треки пройдут модерацию$/ do
  for track in Track.all
    track.to_active
  end
end

Then /^я увижу ([0-9]+) новых тре\w+ на странице$/ do |count_tracks|
  Array.new(count_tracks.to_i).each_index do |index|
    And %(я увижу "Трек #{index+1}" в "#tracks")
  end
end

When /^задача будет запущена$/ do
  Delayed::Job.reserve_and_run_one_job
end

Then /^треки "([^\"]*)" появятся в плейлисте "([^\"]*)"$/ do |tracks, playlist|
  And %(я на странице просмотра плейлиста "#{playlist}")
  tracks.split(", ").each do |track|
    And %(я увижу "#{track}" в "#tracks")
  end
end

Then /^мне (разреш\w+|запре\w+) просмотр списка треков$/ do |permission|
  visit tracks_path
  Then "мне #{permission} доступ"
end

Then /^мне (разреш\w+|запре\w+) просмотр новых треков$/ do |permission|
  visit new_mp3_tracks_path
  Then "мне #{permission} доступ"
end

Then /^мне (разреш\w+|запре\w+) просмотр топа треков$/ do |permission|
  visit top_mp3_tracks_path
  Then "мне #{permission} доступ"
end

Then /^мне (разреш\w+|запре\w+) посещение админки управления треками$/ do |permission|
  visit admin_tracks_path
  Then "мне #{permission} доступ"
end

Then /^мне (разреш\w+|запре\w+) посещение админки плейлистов для управления треками$/ do |permission|
  for playlist in Playlist.all
    visit admin_playlist_path(playlist)
    Then "мне #{permission} доступ"
  end
end

Then /^мне (разреш\w+|запре\w+) просмотр треков$/ do |permission|
  for playlist in Playlist.all
    visit playlist_path(playlist)
    Then "мне #{permission} доступ"
  end
end

Then /^мне (разреш\w+|запре\w+) создание треков$/ do |permission|
  visit new_track_path
  Then "мне #{permission} доступ"

end

Then /^мне (разреш\w+|запре\w+) редактирование треков$/ do |permission|
  for track in Track.all
    visit edit_admin_track_path(track)
    Then "мне #{permission} доступ"
  end
end

Then /^мне (разреш\w+|запре\w+) удаление треков$/ do |permission|
  for track in Track.all
    delete admin_track_path(track)
    Then "мне #{permission} доступ"
  end
end

When /^мне (разреш\w+|запре\w+) редактирование треков пользователя "([^\"]*)"$/ do |permission, email|
  visit edit_admin_track_path(User.find_by_email(email).tracks.first)
  Then "мне #{permission} доступ"
end

When /^мне (разреш\w+|запре\w+) удаление треков пользователя "([^\"]*)"$/ do |permission, email|
  delete admin_tracks_path(User.find_by_email(email).tracks.first)
  Then "мне #{permission} доступ"
end

When /^я отмечу и отправлю в корзину треки "([^\"]*)"$/ do |track_titles|
  track_ids = []
  track_titles.split(", ").each do |track_title|
    track = Track.find_by_title(track_title)
    track_ids << track.id if track
  end
  post to_cart_admin_playlists_path, {:track_ids => track_ids}
  visit root_path
end

Then /^трек с названием "([^\"]*)" не будет сохранен в системе$/ do |track_title|
  find_track(track_title).should be_nil
end

Then /^трек автора "([^\"]*)" не будет сохранен в системе$/ do |track_title|
  track = Track.find_by_author(track_title)
  track.should be_nil
end

Then /^в забаненных треках появятся хэши треков "([^\"]*)"$/ do |track_titles|
  for track in tracks_by_titles(track_titles)
    BanTrack.all.inspect.to_s.should include track.check_sum
  end
end

Then /^мне запрещено удаление треков из плейлистов$/ do
  for playlist in Playlist.all
    delete delete_from_playlist_path(playlist, playlist.tracks.first)
  end
end

Then /^мне (разреш\w+|запре\w+) удаление треков из плейлистов пользователя "([^\"]*)"$/ do |permission, email|
  playlist = User.find_by_email(email).playlists.first
  Then "мне #{permission} доступ"
end

Then /^я увижу сообщение что должен быть автрозирован/ do
  Then %Q(я увижу "Вы должны быть авторизорованны, для доступа к этой странице")
end
Then /^мне как не авторизованному пользователю запрещено посещение админки управления треками$/ do
  visit admin_tracks_path
  Then %Q(я увижу сообщение что должен быть автрозирован)
end

Then /^мне как не авторизованному пользователю запрещено посещение админки плейлистов для управления треками$/ do
  visit admin_playlists_path
  Then %Q(я увижу сообщение что должен быть автрозирован)
end

Then /^мне как не авторизованному пользователю запрещено удаление треков из плейлистов$/ do
  delete delete_from_playlist_path(Playlist.first, Playlist.first.tracks.first)
  Then %Q(я увижу сообщение что должен быть автрозирован)
end

Then /^мне как не авторизованному пользователю запрещено создание треков$/ do
  visit new_track_path
  Then %Q(я увижу сообщение что должен быть автрозирован)
end

Then /^мне как не авторизованному пользователю запрещено редактирование треков$/ do
  visit edit_admin_track_path(Track.first)
  Then %Q(я увижу сообщение что должен быть автрозирован)
end

Then /^мне как не авторизованному пользователю запрещено удаление треков$/ do
  delete admin_track_path(Track.first)
  Then %Q(я увижу сообщение что должен быть автрозирован)
end
