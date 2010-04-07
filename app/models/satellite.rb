class Satellite < ActiveRecord::Base

  validates_presence_of :name
  validates_presence_of :ip
  validates_presence_of :domainname
  validates_uniqueness_of :domainname

  def self.get_servers
    satellites = Satellite.find(:all)
    satellites.each {|i|
      printf "#{i.address} "
    }
  end

end
