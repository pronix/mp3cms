# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.


require 'uri'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)

# Commonly used webrat steps
# http://github.com/brynary/webrat

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

# Use this to fill in an entire form with data from a table. Example:
#
#   When я fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^(?:|я )введу следующие данные:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{я введу "#{name}" в "#{value}"}
  end
end

When /^(?:|я )выберу "([^\"]*)" из "([^\"]*)"$/ do |value, field|
  select(value, :from => field)
end

# Use this step in conjunction with Rail's datetime_select helper. For example:
# When я select "December 25, 2008 10:00" as the date and time
When /^(?:|я )select "([^\"]*)" as the date and time$/ do |time|
  select_datetime(time)
end

# Use this step when using multiple datetime_select helpers on a page or
# you want to specify which datetime to select. Given the following view:
#   <%= f.label :preferred %><br />
#   <%= f.datetime_select :preferred %>
#   <%= f.label :alternative %><br />
#   <%= f.datetime_select :alternative %>
# The following steps would fill out the form:
# When я select "November 23, 2004 11:20" as the "Preferred" date and time
# And я select "November 25, 2004 10:30" as the "Alternative" date and time
When /^(?:|я )select "([^\"]*)" as the "([^\"]*)" date and time$/ do |datetime, datetime_label|
  select_datetime(datetime, :from => datetime_label)
end

# Use this step in conjunction with Rail's time_select helper. For example:
# When я select "2:20PM" as the time
# Note: Rail's default time helper provides 24-hour time-- not 12 hour time. Webrat
# will convert the 2:20PM to 14:20 and then select it.
When /^(?:|я )select "([^\"]*)" as the time$/ do |time|
  select_time(time)
end

# Use this step when using multiple time_select helpers on a page or you want to
# specify the name of the time on the form.  For example:
# When я select "7:30AM" as the "Gym" time
When /^(?:|я )select "([^\"]*)" as the "([^\"]*)" time$/ do |time, time_label|
  select_time(time, :from => time_label)
end

# Use this step in conjunction with Rail's date_select helper.  For example:
# When я select "February 20, 1981" as the date
When /^(?:|я )select "([^\"]*)" as the date$/ do |date|
  select_date(date)
end

# Use this step when using multiple date_select helpers on one page or
# you want to specify the name of the date on the form. For example:
# When я select "April 26, 1982" as the "Date of Birth" date

When /^(?:|я )выберу "(.*)" как дату "(.*)"$/ do |date, date_label|
  day,month,year = date.split(' ')

  select year, :from => "#{date_label}_1i"
  select month, :from => "#{date_label}_2i"
  select day, :from => "#{date_label}_3i"
end


#When /^(?:|я )select "([^\"]*)" as the "([^\"]*)" date$/ do |date, date_label|
#  select_date(date, :from => date_label)
#end

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

# Adds support for validates_attachment_content_type. Without the mime-type getting
# passed to attach_file() you will get a "Photo file is not one of the allowed file types."
# error message
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

