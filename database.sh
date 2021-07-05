#!/bin/bash

yum install mariadb-server mariadb -y
systemctl enable mariadb || systemctl enable mysql
systemctl restart mariadb || systemctl restart mysql

mysql -e "create database wordpress;"
mysql -e "CREATE USER 'wordpress'@'%' IDENTIFIED BY 'Tqweewq';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'wordpress'@'%' IDENTIFIED BY 'Tqweewq';"
mysql -e "FLUSH PRIVILEGES;"
