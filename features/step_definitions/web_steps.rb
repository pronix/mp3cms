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

When /^(?:|я )перейду по ссылке "([^\"]*)"(?: в "([^\"]*)")?$/ do |link, selector|
  with_scope(selector) do
    click_link(link)
  end
end

When /^(?:|я )введу в поле "([^\"]*)" значение "([^\"]*)"(?: в "([^\"]*)")?$/ do |field, value, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end

When /^(?:|я )введу "([^\"]*)" в "([^\"]*)"$/ do |value, field|
  fill_in(field, :with => value)
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^(?:|я )введу следующие данные(?: в "([^\"]*)")?:$/ do |selector, fields|
  with_scope(selector) do
    fields.rows_hash.each do |name, value|
      When %{я введу "#{value}" в "#{name}"}
    end
  end
end

When /^(?:|я )выберу "([^\"]*)" из "([^\"]*)"(?: в "([^\"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    select(value, :from => field)
  end
end

When /^(?:|я )установлю (?:флажок|галку) "([^\"]*)"(?: в "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    check(field)
  end
end

When /^(?:|я )сниму (?:флажок|галку) "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    uncheck(field)
  end
end

When /^(?:|я )выберу "([^\"]*)"(?: в "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    choose(field)
  end
end

When /^(?:|я )прикреплю файл "([^\"]*)" в поле "([^\"]*)"(?: в "([^\"]*)")?$/ do |path, field, selector|
  with_scope(selector) do
    attach_file(field, path)
  end
end


Then /^(?:|я )увижу "([^\"]*)"$/ do |text|
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

Then /^поле "([^\"]*)"(?: в "([^\"]*)")? будет содержать "([^\"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      find_field(field).value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_labeled(field).value)
    end
  end
end

Then /^поле "([^\"]*)"(?: в "([^\"]*)")? не будет содержать "([^\"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      find_field(field).value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, find_field(field).value)
    end
  end
end

Then /^(?:флажок|галка) "([^\"]*)"(?: в "([^\"]*)")? будет стоять$/ do |label, selector|
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      find_field(label)['checked'].should == 'checked'
    else
      assert field_labeled(label)['checked'] == 'checked'
    end
  end
end

Then /^(?:флажок|галка) "([^\"]*)"(?: в "([^\"]*)")? не будет стоять$/ do |label, selector|
  with_scope(selector) do
    if defined?(Spec::Rails::Matchers)
      find_field(label)['checked'].should_not == 'checked'
    else
      assert field_labeled(label)['checked'] != 'checked'
    end
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

Then /^я увижу заголовок "(.*)"$/ do |text|
  assert have_tag('title', {:content => text}).matches?(response.body), "Искали в заголовке '#{text}', но не нашли"
end

Then /^будет (?:нотис|уведомление|сообщение|notice) "(.*)"$/ do |text|
  assert_equal text, flash[:notice], "flash[:notice] не содержит #{text}"
end

Then /^будет получен rss\-feed$/ do
  assert_equal "application/rss+xml", response.content_type
end

Then /^(?:|я )увижу "([^\"]*)"$/ do |text|
  if defined?(Spec::Rails::Matchers)
    response.should contain(text)
  else
    assert_contain text
  end
end

