#!/bin/bash

# Install Apache + PHP 7.4 
yum install httpd -y
amazon-linux-extras enable php7.4 -y
yum install php php-common php-pear -y
yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip} -y

systemctl enable httpd
systemctl restart httpd

# Install WP CLI tool
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Fetch public IP of webserver instance
IP=$(curl https://ifconfig.co/ip)

# Install Wordpress
cd /var/www/html/
wp core download --allow-root

cp -prf wp-config-sample.php wp-config.php
sed -i -e 's/database_name_here/wordpress/g' -e 's/username_here/wordpress/g' -e 's/password_here/Tqweewq/g' -e 's/localhost/wpdb.wprod.com/g' wp-config.php

wp core install --url=http://${IP} --title=Your_Blog_Title --admin_user=admin --admin_password=password --admin_email=test@fasal.cf --allow-root
