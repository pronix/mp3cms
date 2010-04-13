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
      Satellite.f_master.each {|x| x.master = false; x.save! ;}
      self.master = true
      self.save!
    end if self.active?
  end

  def self.get_servers
    satellites = Satellite.find(:all)
    satellites.each {|i|
      printf "#{i.community} #{i.ip}"
    }
  end
end

# задача на разворачивание всех необходимых компонентов на сателлите
class SatelliteJob < Struct.new :id

  # деплоить будем с помощью капистраны
  def perform
    sat = Satellite.find(id)
    ip = sat.ip
    # ставим пакеты через yum
    shr(ip,'yum install wget unzip make patch zlib-devel readline-devel zlib-devel gcc openssl-devel gcc-c++ sqlite-devel postgresql-devel git libuuid-devel libxml2-devel libxslt-devel net-snmp -y')
    # ставим руби
    shr(ip,'')
    shr(ip,'wget http://rubyforge.org/frs/download.php/68719/ruby-enterprise-1.8.7-2010.01.tar.gz')
    shr(ip,'tar -xzvf ./ruby-enterprise-1.8.7-2010.01.tar.gz')
    shr(ip,'cd ./ruby-enterprise-1.8.7-2010.01 ; ./installer -a / ')
    # ставим rack и пассажира
    shr(ip,'gem install rack passenger --no-ri --no-rdoc ')
    shr(ip,'passenger-install-nginx-module --auto')
    # настраиваем nginx
    system(" scp doc/satellite/nginx.conf root@#{sat.ip}:/etc/nginx.conf")
    system(" scp doc/satellite/nginx root@#{sat.ip}:/etc/init.d/nginx")
    # устанавливаем rack- приложение и служебные скрипты
    system(" ssh root@#{ip} 'mkdir -p /var/www/mp3cms/shared/data; mkdir -p /var/www/mp3cms/current/public ;'")
    system("scp doc/satellite/gatekeeperkoza.ru root#{ip}:/var/www/mp3cms/current/")
    # настраиваем запускем snmpd
    system("scp doc/satellite/snmpd.conf root#{ip}:/etc/snmp/")
    # запускаем
    shr(ip,' server snmpd start ; service nginx start ; ')
    # тестируем
    # после успешной проверки ставим что сервер активен
    sat.active = true
    sat.save!
    system("ssh root@#{ip} 'mkdir /var/www/data'")
    system("sshfs root@#{ip}:/var/www/data #{RAILS_ROOT}/data/tracks/#{sat.id}")
  end
  private
  # выполнении комманды на удаленном сервере
  def shr(ip,str)
    system("ssh root@#{ip} '#{str}'")
  end
end
