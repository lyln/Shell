#!/bin/sh
#set -x

if [ $# -eq 0 ]; then
    echo "usage: $0 \$remote_ip_file|remote_ip hostname"
    exit 1
fi
cd `dirname $0`

remote_op() {
    ip=$1
    echo -----------------------$ip--------------------

    ssh -o StrictHostKeyChecking=no $ip << eeooff
#set -x
wget http://xxx.xx/change_hostname.sh
sh change_hostname.sh $2
eeooff
}

if [ -f $1 ]; then
    for ip in `cat $1 | grep -v "#"`; do
        args=`echo $ip|awk -F"," '{print $1" "$2}'`
        remote_op $args
    done
else
    remote_op $1 $2
fi
