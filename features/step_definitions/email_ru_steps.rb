When /^(?:|я )перешел по первой ссылке в письме$/ do
  click_first_link_in_email
end

Given /^мой email "(.*)"/ do |email|
  @email = email
end

Then /^должен получить письмо на адрес "([^\"]*)"$/ do |address|
  unread_emails_for(address).size.should > 0
end

Given /все email пусты/ do
  reset_mailer
end

When /^я открыл почту "([^\"]*)"$/ do |address|
  open_email(address)
end