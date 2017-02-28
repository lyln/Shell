#!/bin/bash
PID=`ps -ef | grep java | grep tomcat|awk '{print $2}'`  
echo $PID   
echo "kill tomcat"  
kill -9 $PID  
