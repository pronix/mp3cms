Given /^в сервисе прописан шлюз "([^\"]*)"$/ do |gateway|
  Factory(gateway.to_sym)
end
