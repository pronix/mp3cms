#!/bin/bash
REZ=`./script/runner -e $RAILS_ENV "Satellite.get_servers(id_ip)"`

for LINE in $REZ
do
        ls data/tracks/`echo $LINE | cut -d" " -f1`
        if [ $? == '0' ]
        then
                fusermount -u data/tracks/`echo $LINE | cut -d" " -f1`
                sshfs root@#`echo $LINE | cut -d" " -f2`:/var/www/data data/tracks/`echo $LINE | cut -d" " -f1`
        fi
done
