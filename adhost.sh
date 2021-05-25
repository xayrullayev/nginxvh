#!/bin/bash

availabelHostsFolder="/etc/nginx/sites-available/"
enabledHostsFolder="/etc/nginx/sites-enabled/"
hostsFolder="/var/www/";

echo 'Starting ad vitual host';
echo '';
echo '';

cat <<-"EOF"
   ______            _____                        __  _           
  / ____/___  ____  / __(_)___ ___  ___________ _/ /_(_)___  ____ 
 / /   / __ \/ __ \/ /_/ / __ `/ / / / ___/ __ `/ __/ / __ \/ __ \
/ /___/ /_/ / / / / __/ / /_/ / /_/ / /  / /_/ / /_/ / /_/ / / / /
\____/\____/_/ /_/_/ /_/\__, /\__,_/_/   \__,_/\__/_/\____/_/ /_/ 
                       /____/                                     
                       
EOF
echo "Nginx sites availables folder path is "$availabelHostsFolder;
echo "Nginx sites enables folder path is "$enabledHostsFolder;
echo "Projects source folder path is "$hostsFolder;
echo '';
echo '';

#
# $1 to be need virtual host name
# example example.com
#

mkdir $hostsFolder$1;
chmod +777 -R $hostsFolder$1;
echo '';
echo "Source folder created "$hostsFolder$1;
#checking file exists or not;

FILE=$hostsFolder"/"$1"/index.php";

	cat > $FILE <<- EOF 
	<?php
	echo"<h1>This page created automatically</h1>"; 
	phpinfo();
	?>
	EOF
chmod -R +777 $hostsFolder"/"$1;

cat > $availabelHostsFolder$1.conf <<- EOF
# server successfully created
server {
        listen 80;
        server_name $1;
        root /var/www/$1;
        index index.php index.html;

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    }
}
EOF

ln -s $availabelHostsFolder$1.conf $enabledHostsFolder


echo '';
echo '';
echo "check configured success with 'nginx -t'";
echo '';
echo '';
cat <<"EOF"
                _                     __ 
   ____  ____ _(_)___  _  __         / /_
  / __ \/ __ `/ / __ \| |/_/  ______/ __/
 / / / / /_/ / / / / />  <   /_____/ /_  
/_/ /_/\__, /_/_/ /_/_/|_|         \__/  
      /____/                                                                       
EOF

echo '';
echo '';

#check configured success with "nginx -t"
nginx -t
echo '';
echo '';
systemctl restart nginx

sleep 2;
echo "Congratulation configuration successfully created";
echo "You can check with url www."$1;
