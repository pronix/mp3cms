#!/bin/bash
PATH_RDD='rdd_bases'
PATH_IMAGES='public/images/graf
REZ=`./script/runner -e $RAILS_ENV "Satellite.get_servers(ip_community)"`

for argument in $REZ
do
    BASE_NAME='/$argument\.rdd'
    # Свободное место на диске
    echo "snmpwalk -v2c -c $argument host.hrStorage.hrStorageTable.hrStorageEntry.hrStorageSize.3 | cut -d" " -f4"
    allblocks=`snmpwalk -v2c -c $argument host.hrStorage.hrStorageTable.hrStorageEntry.hrStorageSize.3 | cut -d" " -f4`
    busy_blocks=`snmpwalk -v2c -c "$argument" host.hrStorage.hrStorageTable.hrStorageEntry.hrStorageUsed.3 | cut -d" " -f4`
    echo "allblocks == $allblocks"
    echo "busy_blocks == $busy_blocks"

    prcentage_blocks=$[busy_blocks / (allblocks / 100)]
    echo $prcentage_blocks


    # Нагрузка на сеть
    ifoutoctes=`snmpwalk -v2c -c $argument IF-MIB::ifOutOctets.2 | cut -d" " -f4`
    ifinoctes=`snmpwalk -v2c -c $argument IF-MIB::ifInOctets.2 | cut -d" " -f4`


    if [ -e $PATH_RDD$BASE_NAME ]
    then
    echo 'db exist'
    else
    rrdtool create $PATH_RDD$BASE_NAME \
                            -s 300 \
                            DS:ifoutoctets:COUNTER:600:0:4263543800 \
                            DS:ifinoctets:COUNTER:600:0:4263543800 \
                            DS:prcentage_blocks:GAUGE:600:0:100 \
                            RRA:AVERAGE:0.5:5:12 \
                            RRA:AVERAGE:0.5:30:48 \

    fi
    IN=`ifconfig eth0 | grep -i bytes | cut -d":" -f2 | cut -d" " -f1`

    echo "rrdtool update test.rrd N:$ifoutoctes:$ifinoctes:$prcentage_blocks"
    rrdtool update $PATH_RDD$BASE_NAME N:$ifoutoctes:$ifinoctes:$prcentage_blocks


    # graph
    rm -rf $PATH_RDD/$argument\_lan.png
    rm -rf $PATH_RDD/$argument\_hdd.png
            rrdtool graph $PATH_RDD/$argument\_lan.png \
                    -s -300seconds \
                    -t network \
                    --lazy \
                    -h 80 -w 600 \
                    -l 0 \
                    -a PNG \
                    DEF:ifoutoctets=$PATH_RDD$BASE_NAME:ifoutoctets:AVERAGE \
                    DEF:ifinoctets=$PATH_RDD$BASE_NAME:ifinoctets:AVERAGE \
                    AREA:ifoutoctets#ac26cd:Outcoming \
                    LINE1:ifoutoctets#3350e1 \
                    HRULE:0#000000 \
                    AREA:ifinoctets#929ce5:Incoming \
                    LINE1:ifinoctets#001efd \
                    HRULE:0#000000 \


            rrdtool graph $PATH_RDD/$argument\_hdd.png \
                    -s -300seconds \
                    -t network \
                    --lazy \
                    -h 80 -w 600 \
                    -l 0 \
                    -a PNG \
                    DEF:prcentage_blocks=$PATH_RDD$BASE_NAME:prcentage_blocks:AVERAGE \
                    AREA:prcentage_blocks#94d036:HDD \
                    LINE1:prcentage_blocks#ff0000 \
                    HRULE:0#000000

done

