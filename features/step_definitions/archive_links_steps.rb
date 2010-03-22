То /^я увижу временную ссылку для скачивания архива$/ do
  within("#link") do |content|
    regexp = "http://"
    if defined?(Spec::Rails::Matchers)
      content.should contain(regexp)
    else
      assert_match(regexp, content)
    end
  end
end

Если /^я перейду по временной ссылке для скачивания архива$/ do
  Допустим %(я перейду по ссылке "my_archive_link" в "#link")
end

То /^начнется закачка архива на компьютер$/ do
  response.header.to_s.should contain("zip")
end

