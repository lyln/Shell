#!/bin/bash
#author:lijd@rgbvr.com
#date:2016/08/18
#desc: backup mysql user innobackupex
#note: ignore copy-back
#version: v0.0.1
#set -x
HOST="localhost"
PORT="3306"
USER="backup"
PASS="123456"

BACKUP_TIME=$(date "+%Y%m%d_%H%M%S")
BACKUP_DIR=/data_backup/full


INNOBACK_OPTS="--defaults-file=/etc/mysql/my.cnf --user=$USER --host=$HOST --port=$PORT --password=$PASS  --parallel=4 --no-timestamp --stream=xbstream ."

INNOBACK=/usr/bin/innobackupex

echo "===== Start backup at $BACKUP_TIME to remote====="
ssh 192.168.1.168 -p 10123 "mkdir -p $BACKUP_DIR/full_$BACKUP_TIME"
$INNOBACK $INNOBACK_OPTS |lz4 -B4 | ssh 192.168.1.168 -p 10123 "cat - |lz4 -d -B7 |xbstream -x -C $BACKUP_DIR/full_$BACKUP_TIME"
echo "====== End backup ====="