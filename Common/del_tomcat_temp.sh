#!/bin/bash
dir=/opt/tomcat/temp
files=`ls ${dir}`
for file in $files
do
    if [ -e ${dir}/${file} ];then
        echo "" > ${dir}/${file}
    fi
done