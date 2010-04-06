class Satellite < ActiveRecord::Base

  after_create :create_script

  validates_presence_of :name

  def self.get_servers
    satellites = Satellite.find(:all)
    satellites.each {|i|
      printf "#{i.address} "
    }
  end

end
