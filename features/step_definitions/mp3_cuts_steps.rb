Then /(?:|я )увижу кнопку "([^\"]*)"$/ do |text|
  response.body.should have_tag("input[value='#{text}']")
end
