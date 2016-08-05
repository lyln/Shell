#!/bin/bash
# Percona XtraBackup 备份脚本
#author: lijd@rgbvr.com
#date: 2016/05/31
# type: full/full_inc/inc    full_inc基于全备份的增量 inc基于增量的增量
#version: v1.0.0

TYPE=$1
BACKUP_TIME=$(date "+%Y%m%d_%H%M%S")
BACKUP_DIR=/databak

FULLBACKUP_DIR=$BACKUP_DIR/full #全备份目录
INCBACKUP_DIR=$BACKUP_DIR/inc #增量备份目录
LOG_DIR=$BACKUP_DIR/logs   #日志目录

MYSQL_CONF='/etc/mysql/my.cnf'
#MYSQL_OPTS='--host=192.168.1.87 --user=ljd --password=root123 --socket=/tmp/mysql.sock2'
MYSQL_OPTS='--host=192.168.1.158 --user=root --password=111111 --port=3307'

FULL_INC_BASEDIR=$FULLBACKUP_DIR/$(ls $FULLBACKUP_DIR |sort -r |head -1)
INC_BASEDIR=$INCBACKUP_DIR/$(ls $INCBACKUP_DIR |sort -r |head -1)

check()
{
    if [ ! -d $FULLBACKUP_DIR ];then
        mkdir -p $FULLBACKUP_DIR
    fi
    if [ ! -d $INCBACKUP_DIR ];then
        mkdir -p $INCBACKUP_DIR
    fi
    if [ ! -d $LOG_DIR ];then
        mkdir -p $LOG_DIR
    fi

}

fullbackup()
{
	innobackupex --defaults-file=$MYSQL_CONF $MYSQL_OPTS --no-timestamp $BACKUP_DIR/$TYPE/full_$BACKUP_TIME > $LOG_DIR/full_$BACKUP_TIME.log 2>&1
}

full_inc_backup(){
	innobackupex --defaults-file=$MYSQL_CONF $MYSQL_OPTS  --no-timestamp  --incremental --incremental-basedir=$FULL_INC_BASEDIR $BACKUP_DIR/inc/full_inc_$BACKUP_TIME > $LOG_DIR/full_inc_$BACKUP_TIME.log 2>&1
}

incbackup(){
	innobackupex --defaults-file=$MYSQL_CONF $MYSQL_OPTS  --no-timestamp  --incremental --incremental-basedir=$INC_BASEDIR $BACKUP_DIR/$TYPE/inc_$BACKUP_TIME > $LOG_DIR/inc_$BACKUP_TIME.log 2>&1
}

case $TYPE in
    full)
        check
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
		check
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
        check
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
