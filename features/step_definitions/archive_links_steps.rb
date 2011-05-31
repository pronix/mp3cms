Then /^я увижу временную ссылку для скачивания архива$/ do
  with_scope("#link") do |content|
    regexp = "http://"
    regexp = Regexp.new(regexp)
    if page.respond_to? :should
      page.should have_no_xpath('//*', :text => regexp)
    else
      assert page.has_no_xpath?('//*', :text => regexp)
    end
  end
end

When /^я перейду по временной ссылке для скачивания архива$/ do
  find(:css, "#link > a:first").click
end

Then /^начнется закачка архива на компьютер$/ do
  page.response_headers["X-Accel-Redirect"].match(/\/internal_download\/archives\/(.*).zip/).should be_present
end

