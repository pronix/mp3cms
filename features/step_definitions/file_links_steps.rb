То /^я увижу временную ссылку на скачивание$/ do
  within("#track_mp3") do |content|
    regexp = "http://"
    if defined?(Spec::Rails::Matchers)
      content.should contain(regexp)
    else
      assert_match(regexp, content)
    end
  end
end

Если /^я перейду по временной ссылке$/ do
  Допустим %(я перейду по ссылке "my_track_link" в "#link")
end

То /^я не увижу ссылку генерации$/ do
  #И %(покажи страницу)
  И %(я не увижу "Сгенерировать ссылку" в "#link")
end

Если /^я попытаюсь сгенерировать ссылку для скачивания трека "([^\"]*)"$/ do |track|
  track = Track.find_by_title(track)
  visit generate_file_link_path(track)
end

То /^начнется закачка файла "([^\"]*)" на компьютер$/ do |file|
  response.header.to_s.should contain("filename=#{file}")
end

Если /^я перейду по временной ссылке формата "([^\"]*)"$/ do |format|
  То %(я перейду по ссылке "track_#{format}" в "#link")
end

