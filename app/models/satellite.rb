# Сателит с номером 1 - основной сервер и по умолчанию его назначаем мастером и активным еще при установке
class Satellite < ActiveRecord::Base
has_many :tracks

  validates_presence_of :name, :ip, :domainname, :community
  validates_uniqueness_of :domainname

  # ищем активные сателлиты
  def self.f_active
    self.find_by_active true
  end

  # находи мастер сервер
  def self.f_master
    self.find_by_master true
  end

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
        printf "#{i.ip}"
      when 'ip_community'
        printf "#{i.community} #{i.ip}"
      when 'ip_domain'
        printf "#{i.ip} #{i.domainname}"
      when 'id_ip'
        printf "#{i.id} #{i.ip}"
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
    system("ssh root@#{ip} 'mkdir /var/www/data'")
    system("sshfs root@#{ip}:/var/www/data #{RAILS_ROOT}/data/tracks/#{sat.id}")
  end
end
