Given /^the following mobilcents:$/ do |mobilcents|
  Mobilcents.create!(mobilcents.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) mobilcents$/ do |pos|
  visit mobilcents_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following mobilcents:$/ do |expected_mobilcents_table|
  expected_mobilcents_table.diff!(tableish('table tr', 'td,th'))
end

Given /^пользователь "([^\"]*)" отправил смс и ей пришел пароль "([^\"]*)"$/ do |user_email, code|
  @user =  User.find_by_email(user_email)
  @sms_payment = SmsPayment.create!({
                                      :user => @user,
                                      :country  => "RU",  :shortcode  => "12",
                                      :provider => "dat", :cost_local => "300",
                                      :cost_usd => 10,    :phone      => "+9227423148",
                                      :msgid    => "222",  :sid        => "32",
                                      :content  => "send sms"   })
  @sms_payment.code = code
  @sms_payment.deliver!

end

Then /^баланс пользователя "([^\"]*)" будет "([^\"]*)"$/ do |user_email, balance|
  user = User.find_by_email user_email
  user.balance.to_f.should == balance.to_f
end

