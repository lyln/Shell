#!/bin/bash
apt-get install libaio -y > /dev/null 2>&1
if id -g mysql > /dev/null 2>&1
then
	echo 'mysql group exists'
else
	groupadd mysql > /dev/null 2>&1 && echo 'creating mysql group success'
fi
if id -u mysql > /dev/null 2>&1
then
	echo 'mysql user exists'
else
	useradd -r -g mysql -s /sbin/nologin mysql > /dev/null 2>&1 && echo 'creating mysql user success'
fi
src_binary_dir=/soft/mysql
install_dir=/usr/local
mydatadir=/mdata
[ -d $mydatadir ] || mkdir -p $mydatadir
echo -n "Enter you version of Mysql: "
read version
cd ${src_binary_dir}/${version}
tar zxf $(/usr/bin/ls mysql*.tar.gz) -C ${install_dir}
cd ${install_dir}
ln -s $(ls -d mysql-${verion}*) mysql
echo 'export PATH=/usr/local/mysql/bin:$PATH' > /etc/profile.d/mysql.sh

cat << EOF > /etc/my.cnf
[mysql]
prompt=(\\\u@\\\h) [\\\d]>\\\_
[mysqld]
port = 3306
user = mysql
datadir = /mdata/mysql_test_data
log_error = error.log
log_timestamps=SYSTEM
EOF

cd mysql
case $version in
     5.7)
     mkdir mysql-files
     chmod 750 mysql-files
     chown mysql:mysql .
     bin/mysqld --initialize --user=mysql > /dev/null 2>&1
     [ $? -eq 0 ] && echo "Installing mysql-server success"
     chown -R root .
     cp support-files/mysql.server /etc/init.d/mysql.server
     grep "temporary password" $mydatadir/mysql_test_data/error.log | awk -F: '{print $4}' > /tmp/mypass.txt
     systemctl enable mysql.server > /dev/null 2>&1
     ;;
     5.6)
     sed -i '/log_timestamps/d' /etc/my.cnf
     chown mysql:mysql .
     scripts/mysql_install_db --user=mysql > /dev/null 2>&1
     [ $? -eq 0 ] && echo "Installing mysql-server success"
     chown -R root .
     cp support-files/mysql.server /etc/init.d/mysql.server
     systemctl enable mysql.server > /dev/null 2>&1
     ;;
esac