yum install wget unzip make patch zlib-devel readline-devel zlib-devel gcc openssl-devel gcc-c++ sqlite-devel postgresql-devel git libuuid-devel libxml2-devel libxslt-devel net-snmp -y
    # ставим руби
wget http://rubyforge.org/frs/download.php/68719/ruby-enterprise-1.8.7-2010.01.tar.gz ; tar -xzvf ./ruby-enterprise-1.8.7-2010.01.tar.gz
    # запускаем инсталлер
cd ./ruby-enterprise-1.8.7-2010.01
./installer --dont-install-useful-gems -a /
gem install rack passenger --no-ri --no-rdoc
sed -i 's/download_and_install = should_we_download_and_install_nginx_automatically?/download_and_install = \"1\"/' /lib/ruby/gems/1.8/gems/passenger-2.2.11/bin/passenger-install-nginx-module
sed -i 's/input.empty? || input.*/true/' /lib/ruby/gems/1.8/gems/passenger-2.2.11/bin/passenger-install-nginx-module
sed -i '219,226d' /lib/ruby/gems/1.8/gems/passenger-2.2.11/bin/passenger-install-nginx-module
sed -i 's/if prefix.empty?/if true/' /lib/ruby/gems/1.8/gems/passenger-2.2.11/bin/passenger-install-nginx-module
# запустили установку nginx
passenger-install-nginx-module --auto
cp nginx.conf /etc/nginx.conf
cp nginx /etc/init.d/nginx
mkdir -p /var/www/{data,public,tmp}
cp config.ru /var/www/
chown -R nobody:nobody /var/www
    # настраиваем запускем snmpd
cp snmpd.conf root#{ip}:/etc/snmp/
    # запускаем
service snmpd start ; service nginx start
