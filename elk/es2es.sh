#!/bin/sh

dir="/opt/apps/linux64"
cd $dir

esindex=`curl -s 'http://127.0.0.1:9200/_cat/indices' | grep logstash-2018.09.* | awk '{print $3}'`
#echo $esindex

for i in $esindex;

do
        echo $i
        ./esm  -s http://127.0.0.1:9200 -x $i  -d http://192.168.1.100:9200 -x $i  -w=5 -b=10 -c 10000

done
