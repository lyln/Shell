#!/bin/sh 
if [ $# -ne 3 ]; then
echo "ERROR : MUST BE #./backup.sh hosts/xxx local_src_dir/ remote_dst_dir/";
exit -1;
fi

REMOTE_HOSTS=$1; 
LOCAL_SRC=$2;
REMOTE_DST=$3;
SSH_PORT=xxx

DATE=`date "+%Y%m%d-%H%M%S"`;
TARGET_DIR=`basename $REMOTE_DST`;
BACKUP_DIR="/data/backup/${TARGET_DIR}/${DATE}"

for host in `cat $REMOTE_HOSTS`; do
echo $host;
rsync -ab -e "ssh -p $SSH_PORT"  --backup-dir=$BACKUP_DIR ${LOCAL_SRC}/ root@${host}:${REMOTE_DST};
done
