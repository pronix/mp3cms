
When /^я введу в скрытое поле "([^\"]*)" значение "([^\"]*)"$/ do |field_name, value|
  xpath = %{//input[@type="hidden" and @name="#{field_name}"]}
  find(:xpath, xpath).set(value)
end

Given /^я введу в поле "([^\"]*)" значение "([^\"]*)" в селекторе "([^\"]*)"$/ do |field, value, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end

Given /^я выберу "([^\"]*)" в "([^\"]*)"$/ do |field, selector|
  with_scope(selector) do
    choose(field)
  end
end

Given /^(?:|я )на (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|я )зайду на (.+)$/ do |page_name|
  visit path_to(page_name)
end
When /^(?:|я )перешел на страницу (.+)$/ do |page_name|
  visit path_to(page_name)
end


When /^(?:|я )нажму "([^\"]*)"(?: в "([^\"]*)")?$/ do |button, selector|
  with_scope(selector) do
    click_button(button)
  end
end

When /^(?:|я )перейду по ссылке "([^\"]*)"$/ do |link|
  click_link(link)

end

When /^(?:|я )перейду по ссылке "([^\"]*)" в "([^\"]*)"$/ do |link, parent|
  click_link_within(parent, link)
end

When /^(?:|я )введу в поле "([^\"]*)" значение "([^\"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|я )введу "([^\"]*)" в "([^\"]*)"$/ do |value, field|
  fill_in(field, :with => value)
end


When /^(?:|я )введу следующие данные:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{я введу "#{name}" в "#{value}"}
  end
end

When /^(?:|я )выберу "([^\"]*)" из "([^\"]*)"$/ do |value, field|
  select(value, :from => field)
end


When /^(?:|я )select "([^\"]*)" as the date and time$/ do |time|
  select_datetime(time)
end

When /^(?:|я )select "([^\"]*)" as the "([^\"]*)" date and time$/ do |datetime, datetime_label|
  select_datetime(datetime, :from => datetime_label)
end

When /^(?:|я )select "([^\"]*)" as the time$/ do |time|
  select_time(time)
end


When /^(?:|я )select "([^\"]*)" as the "([^\"]*)" time$/ do |time, time_label|
  select_time(time, :from => time_label)
end

When /^(?:|я )select "([^\"]*)" as the date$/ do |date|
  select_date(date)
end

When /^(?:|я )выберу "(.*)" как дату "(.*)"$/ do |date, date_label|
  day,month,year = date.split(' ')

  select year, :from => "#{date_label}_1i"
  select month, :from => "#{date_label}_2i"
  select day, :from => "#{date_label}_3i"
end


When /^(?:|я )установлю (?:флажок|галку) в "([^\"]*)"$/ do |field|
  check(field)
end

When /^(?:|я )сниму (?:флажок|галку) в "([^\"]*)"$/ do |field|
  uncheck(field)
end

When /^(?:|я )установлю (?:флажок|галку) "([^\"]*)" в "([^\"]*)"$/ do |field, parent|
  with_scope(parent) do |scope|
    scope.check(field)
  end
end

When /^(?:|я )сниму (?:флажок|галку) "([^\"]*)" в "([^\"]*)"$/ do |field, parent|
  with_scope(parent) do |scope|
    scope.uncheck(field)
  end
end

When /^(?:|я )выберу "([^\"]*)"$/ do |field|
  choose(field)
end

When /^(?:|я )прикреплю файл "([^\"]*)" в поле "([^\"]*)"$/ do |path, field|
  attach_file(field, File.expand_path(path))
end

Then /^(?:|я )увижу "([^\"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /^(?:|я )увижу "([^\"]*)" в "([^\"]*)"$/ do |text, selector|
  with_scope(selector) do |content|
    if page.respond_to? :should
      page.should have_content(text)
    else
      assert page.has_content?(text)
    end
  end
end

Then /^(?:|я )увижу \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  if defined?(Spec::Rails::Matchers)
    response.should contain(regexp)
  else
    assert_match(regexp, response_body)
  end
end

Then /^(?:|я )увижу \/([^\/]*)\/ в "([^\"]*)"$/ do |regexp, selector|
  with_scope(selector) do |content|
    regexp = Regexp.new(regexp)

    if page.respond_to? :should
      page.should have_xpath('//*', :text => regexp)
    else
      assert page.has_xpath?('//*', :text => regexp)
    end
  end
end

Then /^(?:|я )не увижу "([^\"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end

Then /^(?:|я )не увижу "([^\"]*)" в "([^\"]*)"$/ do |text, selector|
  with_scope(selector) do |content|
    page.should have_no_content(text)
  end
end

Then /^(?:|я )не увижу \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  if page.respond_to? :should
    page.should have_no_xpath('//*', :text => regexp)
  else
    assert page.has_no_xpath?('//*', :text => regexp)
  end
end

Then /^(?:|я )не увижу \/([^\/]*)\/ в "([^\"]*)"$/ do |regexp, selector|
  with_scope(selector) do |content|
    regexp = Regexp.new(regexp)
    if page.respond_to? :should
      page.should have_no_xpath('//*', :text => regexp)
    else
      assert page.has_no_xpath?('//*', :text => regexp)
    end
  end
end

Then /^поле "([^\"]*)" будет содержать "([^\"]*)"$/ do |field, value|
  if defined?(Spec::Rails::Matchers)
    field_labeled(field).value.should =~ /#{value}/
  else
    assert_match(/#{value}/, field_labeled(field).value)
  end
end

Then /^полу "([^\"]*)" не будет содержать "([^\"]*)"$/ do |field, value|
  if defined?(Spec::Rails::Matchers)
    field_labeled(field).value.should_not =~ /#{value}/
  else
    assert_no_match(/#{value}/, field_labeled(field).value)
  end
end

Then /^(?:флажок|галка) "([^\"]*)" будет включен$/ do |label|
  if defined?(Spec::Rails::Matchers)
    field_labeled(label).should be_checked
  else
    assert field_labeled(label).checked?
  end
end

Then /^(?:флажок|галка) "([^\"]*)" будет выключен$/ do |label|
  if defined?(Spec::Rails::Matchers)
    field_labeled(label).should_not be_checked
  else
    assert !field_labeled(label).checked?
  end
end

Then /^(?:|я )должен быть на (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then /^я буду на (.+)$/ do |page_name|
  URI.parse(current_url).path.should == path_to(page_name)
end

Then /^покажи страницу$/ do
  save_and_open_page
end

Then /^я увижу форму ввода$/ do
  all("form").should be_present
end

Then /^я не увижу форму ввода$/ do
  all("form").should be_blank
end

Then /^заголовок страницы будет содержать "([^\"]*)"$/ do |text|
  all("title", :text => text)
end

Then /^будет (?:нотис|уведомление|сообщение|notice) "(.*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /^будет получен rss\-feed$/ do
  assert_equal "application/rss+xml", response.content_type
end

Then /^(?:|я )увижу табличные данные в "([^\"]*)":$/ do |element, _table|
  _table.diff!(tableish("table#{element} tr", 'td,th'))
end

Then /^мне (запр\w+|разр\w+) доступ$/ do |permission|
  if permission =~ /разр/
    page.should(have_no_content("Вы не имеете прав для просмотра данной страници."))
  else
    page.should have_content("Вы не имеете прав для просмотра данной страници.")

  end
end

Then /показать страницу в консоле/ do
  puts "-"*90
  puts page.body
  puts "-"*90
end


When /^я введу в поле "([^\"]*)" значение "([^\"]*)" в "([^\"]*)"$/ do |field, value, parent|
  with_scope(parent) do
    fill_in(field, :with => value)
  end
end
