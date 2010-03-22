Given /^в сервисе прописан шлюз "([^\"]*)"$/ do |gateway|
  Factory(gateway.to_sym)
end

Given /^у шлюза "([^\"]*)" прописаны следующие страны "([^\"]*)"$/ do |gateway, country|
  gw = Gateway.send gateway.to_sym
  country.split(',').each do |c|
    Factory("cost_country_#{c.split(':').first.strip}".to_sym, :cost => c.split(':').last, :gateway => gw)
  end
end
Then /^(?:|я )нажму "([^\"]*)" для "([^\"]*)" позиции в "([^\"]*)"$/ do |link, pos, elements|
  within("#{elements}:eq(#{pos.to_i+1})") do
    click_link link
  end
end
