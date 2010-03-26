Given /^the following mp3_cuts:$/ do |mp3_cuts|
  Mp3Cuts.create!(mp3_cuts.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) mp3_cuts$/ do |pos|
  visit mp3_cuts_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following mp3_cuts:$/ do |expected_mp3_cuts_table|
  expected_mp3_cuts_table.diff!(tableish('table tr', 'td,th'))
end
