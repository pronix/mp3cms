Then /^график дисковой активности$/ do
  response.should have_tag("img[alt=Diskio]")
end

Then /^увижу график сетевой активности$/ do
  response.should have_tag("img[alt=Network]")
end
