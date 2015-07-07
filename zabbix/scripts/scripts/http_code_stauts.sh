#!/bin/bash
logname='/data/log/nginx/sevenga.access.log'
total=`sudo cat $logname|wc -l`
array=(`sudo cat $logname|grep "$1"| awk '{print $9}'|sort|uniq -c |sort -n|grep $2`)
len=${#array[@]}

for ((i=0;i<$len;i=i+2))
{
echo ${array[$i]}
}
