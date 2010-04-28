#!/bin/bash
REZ=`./script/runner -e $RAILS_ENV "Satellite.get_servers(id_ip)"`

for LINE in $REZ
do
        ls data/tracks/`echo $LINE | cut -d" " -f1`
        if [ $? == '0' ]
        then
                fusermount -u data/tracks/`echo $LINE | cut -d" " -f1`
                sudo -u apache sshfs root@`echo $LINE | cut -d" " -f2`:/var/www/data /var/www/mp3cms/shared/data/tracks/`echo $LINE | cut -d" " -f1` -o umask=770
        fi
done
