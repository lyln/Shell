#!/bin/bash
#author:lijd@rgbvr.com
#date:2016/08/18
#desc: mysqldump backup mysql
#version: v0.0.1

HOST="192.168.1.168"
PORT="3306"
USER="root"
PASS="admin123"

MYSQL_OPTS="--master-data=2 --single-transaction -R --triggers"

BACKUP_TIME=$(date "+%Y%m%d_%H%M%S")
BACKUP_DIR=/data/backup/mysql

MYSQLDUMP=/usr/local/mysql/bin/mysqldump

echo "===== Start backup ====="
$MYSQLDUMP -u$USER -h$HOST -P$PORT -p$PASS $MYSQL_OPTS rgbvr_show > $BACKUP_DIR/rgbvr_$BACKUP_TIME.sql
echo "====== End backup ====="
