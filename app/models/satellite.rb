# Сателит с номером 1 - основной сервер и по умолчанию его назначаем мастером и активным еще при установке
class Satellite < ActiveRecord::Base
  has_many :tracks

  validates_presence_of :name, :ip, :domainname, :community
  validates_uniqueness_of :domainname
  scope :active, where(:active => true)
  class << self
    # Локальный сателит, создаем если его нет
    #
    def local_satellite
      @local_satellite ||= find_by_domainname(Settings.app_domain) ||
        create!(:name => Settings.app_name,
                :ip => Settings.app_ip,
                :domainname => Settings.app_domain,
                :master => true,
                :active => true,
                :community => ActiveSupport::SecureRandom.hex(46) )
      @local_satellite
    end

    # находи мастер сервер
    # или локальный сателит
    #
    def master
      @master ||= find_by_master(true) || local_satellite
      @master
    end

  end # end class << self


  # проверяем активен ли сервер и если да - назначаем мастером,перед этим отменив других мастеров
  def set_master
    self.transaction do
      Satellite.all.each {|x| x.update_attribute(:master,false)}
      self.master = true
      self.save!
    end if self.active?
  end

  def self.get_servers(col='ip_community')
    satellites = Satellite.find(:all)
    satellites.each {|i|
      case col
      when 'ip'
        puts "#{i.ip}"
      when 'ip_community'
        puts "#{i.community} #{i.ip}"
      when 'ip_domain'
        puts "#{i.ip} #{i.domainname}"
      when 'id_ip'
        puts  "#{i.id} #{i.ip}"
      end
    }
  end
end

# задача на разворачивание всех необходимых компонентов на сателлите
class SatelliteJob < Struct.new :id

  # деплоить будем с помощью капистраны
  def perform
    sat = Satellite.find(id)
    ip = sat.ip
    system("scp -r /var/www/mp3cms/current/doc/satelite/* root#{ip}:/root/")
    system(" ssh root@#{ip} '/root/autodeploy.sh'")
    # тестируем
    # после успешной проверки ставим что сервер активен
    sat.active = true
    sat.save!
    system("ssh root@#{ip} 'mkdir -p /var/www/data'")
    system("sshfs root@#{ip}:/var/www/data #{Rails.root}/data/tracks/#{sat.id} -o umask=770 ")
  end
end
