class Satellite < ActiveRecord::Base
has_many :tracks

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

# задача на разворачивание всех необходимых компонентов на сателлите
class SatelliteJob < Struct.new :id

  # деплоить будем с помощью капистраны
  def deploy_all
    sat = Satellite.find(id)
    ip = sat.ip
    # ставим пакеты через yum
    shr(ip,'yum install wget unzip make patch zlib-devel readline-devel zlib-devel gcc openssl-devel gcc-c++ sqlite-devel postgresql-devel vsftpd git libuuid-devel libxml2-devel libxslt-devel net-snmp -y')
    # ставим руби
    shr(ip,'')
    shr(ip,'wget http://rubyforge.org/frs/download.php/68719/ruby-enterprise-1.8.7-2010.01.tar.gz')
    shr(ip,'tar -xzvf ./ruby-enterprise-1.8.7-2010.01.tar.gz')
    shr(ip,'cd ./ruby-enterprise-1.8.7-2010.01 ; ./installer -a / ')
    # ставим rack и пассажира
    shr(ip,'gem install rack passenger --no-ri --no-rdoc ')
    shr(ip,'passenger-install-nginx-module --auto')
    # ставим  и настраиваем pam_pgsql - все соединения с базой через проксирование по ssh(необходим проверяльщий к соединения - для пересоздания)
    # FIXME а еще лучше керберос
    shr(ip,'wget http://downloads.sourceforge.net/project/pam-pgsql/pam-pgsql/0.7/pam-pgsql-0.7.1.tar.gz ; tar -xzvf pam-pgsql-0.7.1.tar.gz ; cd ./pam-pgsql-0.7.1 ; ./configure ; make ; make install ;')
    system(" scp doc/satellite/pam_pgsql_vsftpd.conf root@#{sat.ip}:/etc/pam_pgsql_vsftpd.conf")
    # настраиваем vsftpd
    system(" scp doc/satellite/vsftpd.conf root@#{sat.ip}:/etc/vsftpd/vsftpd.conf")
    # настраиваем nginx
    system(" scp doc/satellite/nginx.conf root@#{sat.ip}:/etc/nginx.conf")
    system(" scp doc/satellite/nginx root@#{sat.ip}:/etc/init.d/nginx")
    # устанавливаем rack- приложение и служебные скрипты
    system(" ssh root@#{sat.ip} 'mkdir -p /var/www/mp3cms/shared/data; mkdir -p /var/www/mp3cms/current/public ;'")
    system("scp doc/satellite/gatekeeperkoza.ru root#{sat.ip}:/var/www/mp3cms/current/")
    # настраиваем запускем snmpd
    system("scp doc/satellite/snmpd.conf root#{sat.ip}:/etc/snmp/")
    # запускаем
    shr(ip,' server snmpd start ; service vsftpd start ; service nginx start ; ')
    # тестируем
    # после успешной проверки ставим что сервер активен
    sat.active = true
    sat.save!
  end
  private
  # выполнении комманды на удаленном сервере
  def shr(ip,str)
    system("ssh root@#{ip} '#{str}'")
  end
end
