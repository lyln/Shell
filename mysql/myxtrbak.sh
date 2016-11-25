#!/bin/bash
# Percona XtraBackup 备份脚本
#author: lijd@rgbvr.com
#date: 2016/05/31
# type: full/full_inc/inc    full_inc基于全备份的增量 inc基于增量的增量
#version: v1.0.0
source /etc/profile

TYPE=$1
BACKUP_TIME=$(date "+%Y%m%d_%H%M%S")
BACKUP_DIR=/data1/backup/online

INNOBX=/opt/xtrabackup/bin/innobackupex

FULLBACKUP_DIR=$BACKUP_DIR/full #全备份目录
INCBACKUP_DIR=$BACKUP_DIR/inc #增量备份目录
LOG_DIR=$BACKUP_DIR/logs   #日志目录

MYSQL_CONF='/data/script/my.cnf'
MYSQL_OPTS='--host=localhost --user=root --password=rvbgradmin --port=3306'

FULL_INC_BASEDIR=$FULLBACKUP_DIR/$(ls $FULLBACKUP_DIR |sort -r |head -1)
INC_BASEDIR=$INCBACKUP_DIR/$(ls $INCBACKUP_DIR |sort -r |head -1)

fullbackup()
{
        $INNOBX --defaults-file=$MYSQL_CONF $MYSQL_OPTS --no-timestamp $BACKUP_DIR/$TYPE/full_$BACKUP_TIME > $LOG_DIR/full_$BACKUP_TIME.log 2>&1
}

full_inc_backup(){
        $INNOBX --defaults-file=$MYSQL_CONF $MYSQL_OPTS  --no-timestamp  --incremental --incremental-basedir=$FULL_INC_BASEDIR $BACKUP_DIR/inc/full_inc_$BACKUP_TIME > $LOG_DIR/full_inc_$BACKUP_TIME.log 2>&1
}

incbackup(){
        $INNOBX --defaults-file=$MYSQL_CONF $MYSQL_OPTS  --no-timestamp  --incremental --incremental-basedir=$INC_BASEDIR $BACKUP_DIR/$TYPE/inc_$BACKUP_TIME > $LOG_DIR/inc_$BACKUP_TIME.log 2>&1
}

case $TYPE in
    full)
        fullbackup $TYPE
        if [ $(tail -n1 $LOG_DIR/full_$BACKUP_TIME.log|grep "completed OK"|wc -l) -gt 0 ];then
                        echo  ""
                                echo "***********************************************************"
                        echo  "* fullbackup is success! *"
                                echo "***********************************************************"
            else
                        echo  ""
                                echo "***********************************************************"
                        echo  "* fullbackup is fail!!! check the log *"
                                echo "***********************************************************"
        fi
        ;;
    full_inc)
                full_inc_backup $TYPE
                echo $FULL_INC_BASEDIR
                if [ $(tail -n1 $LOG_DIR/full_inc_$BACKUP_TIME.log|grep "completed OK"|wc -l) -gt 0  ];then
                        echo  ""
                                echo "***********************************************************"
                        echo  "* full inc backup is success! *"
                                echo "***********************************************************"
                else
                        echo  ""
                                echo "***********************************************************"
                        echo  "* full inc backup is fail!!! check the log *"
                                echo "***********************************************************"
            fi
                ;;
    inc)
        incbackup $TYPE
        echo $INC_BASEDIR
                if [ $(tail -n1 $LOG_DIR/inc_$BACKUP_TIME.log|grep "completed OK"|wc -l) -gt 0  ];then
                        echo  ""
                                echo "***********************************************************"
                        echo  "*inc backup is success! *"
                                echo "***********************************************************"
                else
                        echo  ""
                                echo "***********************************************************"
                        echo  "*inc backup is fail!!! check the log *"
                                echo "***********************************************************"
        fi
        ;;
    *)
         echo "Usage: $0 {full|full_inc|inc}"
        ;;
esac
