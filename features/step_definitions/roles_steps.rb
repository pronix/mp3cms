Then /^в сервисе должена появивться роль "([^\"]*)"$/ do |title_role|
  @role = Role.find_by_title title_role
  @role.should be_present
  @role.name.start_with?("custom").should be_true
end

Then /^у роль с ид "([^\"]*)" название должно быть "([^\"]*)"$/ do |_id, new_title|
  @role = Role.find _id
  @role.should_not be_nil
  @role.title.should == new_title
end



