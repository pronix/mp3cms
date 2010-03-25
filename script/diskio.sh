#!/bin/bash
PATH_RDD='/home/maxim/www/mp3-cms/data/rdd'
BASE_NAME='/test.rdd'

if [ -e $PATH_RDD$BASE_NAME ]
then
echo 'db exist'
else
rrdtool create $PATH_RDD$BASE_NAME \
                        -s 60 \
                        DS:in:DERIVE:600:0:125000000 \
                        DS:out:DERIVE:600:0:125000000 \
                        DS:read:GAUGE:600:0:12500 \
                        DS:write:GAUGE:600:0:12500 \
                        RRA:AVERAGE:0.1:1:576 \
                        RRA:AVERAGE:0.5:6:672 \
                        RRA:AVERAGE:0.5:24:732 \
                        RRA:AVERAGE:0.5:144:1460

fi
IN=`ifconfig eth0 | grep -i bytes | cut -d":" -f2 | cut -d" " -f1`
OUT=`ifconfig eth0 | grep -i bytes | cut -d":" -f3 | cut -d" " -f1`
READ=`iostat -x | grep -A 1 Device | grep -vi device | awk '{ print $6*100}'`
WRITE=`iostat -x | grep -A 1 Device | grep -vi device | awk '{ print $7*100}'`

echo "rrdtool update test.rrd N:$IN:$OUT:$READ:$WRITE"
rrdtool update $PATH_RDD$BASE_NAME N:$IN:$OUT:$READ:$WRITE


# graph
rm -rf $PATH_RDD/network.png
        rrdtool graph $PATH_RDD/network.png \
                -s -1hour \
                -t network \
                --lazy \
                -h 80 -w 600 \
                -l 0 \
                -a PNG \
                -v "network" \
                DEF:in=$PATH_RDD$BASE_NAME:in:AVERAGE \
                DEF:out=$PATH_RDD$BASE_NAME:out:AVERAGE \
                AREA:in#32CD32:Incoming \
                LINE1:in#336600 \
                AREA:out#4169E1:Outgoing \
                LINE1:out#0033CC \
                HRULE:0#000000

rm -rf $PATH_RDD/diskio.png
        rrdtool graph $PATH_RDD/diskio.png \
                -s -1hour \
                -t diskio \
                --lazy \
                -h 80 -w 600 \
                -l 0 \
                -a PNG \
                -v "read:write block per sec" \
                DEF:read=$PATH_RDD$BASE_NAME:read:AVERAGE \
                DEF:write=$PATH_RDD$BASE_NAME:write:AVERAGE \
                AREA:read#32CD32:READ \
                LINE1:read#336600 \
                AREA:write#4169E1:WRITE \
                LINE1:write#0033CC \
                HRULE:0#000000

