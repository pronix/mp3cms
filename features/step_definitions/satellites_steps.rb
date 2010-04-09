Допустим /^к системе привязанны следующие сервера хранения$/ do |table|
  table.hashes.each {|i|
    Satellite.create!(:name => i[:name],
                      :ip => i[:ip],
                      :domainname => i[:domainname],
                      :description => i[:description],
                      :id => i[:id],
                      :master => i[:master])
  }
  print Satellite.find(:first).description
end