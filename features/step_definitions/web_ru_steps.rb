
When /^я введу в скрытое поле "([^\"]*)" значение "([^\"]*)"$/ do |field, value|
  set_hidden_field(field, :to => value)
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
  within parent do |scope|
    scope.check(field)
  end
end

When /^(?:|я )сниму (?:флажок|галку) "([^\"]*)" в "([^\"]*)"$/ do |field, parent|
  within parent do |scope|
    scope.uncheck(field)
  end
end

When /^(?:|я )выберу "([^\"]*)"$/ do |field|
  choose(field)
end

When /^(?:|я )прикреплю файл "([^\"]*)" в поле "([^\"]*)"$/ do |path, field|
  type = path.split(".")[1]

  case type
  when "jpg"
    type = "image/jpg"
  when "jpeg"
    type = "image/jpeg"
  when "png"
    type = "image/png"
  when "gif"
    type = "image/gif"
  when "mp3"
    type = "audio/mp3"
  end

  attach_file(field, path, type)
end

Then /^(?:|я )увижу "([^\"]*)"$/ do |text|
  @tracks = Track.search :conditions => { :state => "moderation"}
  if defined?(Spec::Rails::Matchers)
    response.should contain(text)
  else
    assert_contain text
  end
end

Then /^(?:|я )увижу "([^\"]*)" в "([^\"]*)"$/ do |text, selector|
  within(selector) do |content|
    if defined?(Spec::Rails::Matchers)
      content.should contain(text)
    else
      hc = Webrat::Matchers::HasContent.new(text)
      assert hc.matches?(content), hc.failure_message
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
  within(selector) do |content|
    regexp = Regexp.new(regexp)
    if defined?(Spec::Rails::Matchers)
      content.should contain(regexp)
    else
      assert_match(regexp, content)
    end
  end
end

Then /^(?:|я )не увижу "([^\"]*)"$/ do |text|
  if defined?(Spec::Rails::Matchers)
    response.should_not contain(text)
  else
    assert_not_contain(text)
  end
end

Then /^(?:|я )не увижу "([^\"]*)" в "([^\"]*)"$/ do |text, selector|
  within(selector) do |content|
    if defined?(Spec::Rails::Matchers)
      content.should_not contain(text)
    else
      hc = Webrat::Matchers::HasContent.new(text)
      assert !hc.matches?(content), hc.negative_failure_message
    end
  end
end

Then /^(?:|я )не увижу \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  if defined?(Spec::Rails::Matchers)
    response.should_not contain(regexp)
  else
    assert_not_contain(regexp)
  end
end

Then /^(?:|я )не увижу \/([^\/]*)\/ в "([^\"]*)"$/ do |regexp, selector|
  within(selector) do |content|
    regexp = Regexp.new(regexp)
    if defined?(Spec::Rails::Matchers)
      content.should_not contain(regexp)
    else
      assert_no_match(regexp, content)
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
  current_path = URI.parse(current_url).select(:path, :query).compact.join('?')
  if defined?(Spec::Rails::Matchers)
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
  assert have_tag('form').matches?(response_body), 'Искали форму ввода, но не нашли'
end

Then /^я не увижу форму ввода$/ do
  assert !have_tag('form').matches?(response_body), 'Форма не должна быть, а есть сука'
end

Then /^заголовок страницы будет содержать "([^\"]*)"$/ do |text|
  assert have_tag('title', {:content => text}).matches?(response.body), "Искали в заголовке '#{text}', но не нашли"
end

Then /^будет (?:нотис|уведомление|сообщение|notice) "(.*)"$/ do |text|
  if respond_to? :selenium
    response.should contain(text)
  else
    assert_equal text, flash[:notice], "flash[:notice] не содержит #{text}"
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
	  assert @response.success? || @response.redirect?, "действие запрещено"
  else
    assert flash[:error].eql?(I18n.t(:permission_denied)) || flash[:notice].eql?(I18n.t(:require_user)), "Доступ возможен"
  end
end

