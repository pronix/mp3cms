When /^(?:|я )перешел по первой ссылке в письме$/ do
  click_first_link_in_email
end

Given /^мой email "(.*)"/ do |email|
  @email = email
end

