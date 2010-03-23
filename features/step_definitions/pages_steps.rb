Given /^в сервисе прописан статические страницы "([^\"]*)"$/ do |pages|
  Page.destroy_all
  pages.split(",").map{ |x|  x[/(\w+)(?:|\()(.*)(?:|\))/]
    _page = $1
    _fields = $2[1..-2] unless $2.blank?
    _hash = { }
    _fields.split(';').map{|x| _hash[x.split(':').first] = x.split(':').last  } unless _fields.blank?
    Factory("#{_page.strip}_page".to_sym, _hash)
  }


end

Then /^введу в поле "([^\"]*)" значение$/ do |field, string|
  fill_in(field, :with => string)
end
