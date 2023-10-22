#!/bin/bash

#===================================================================================================
# Program: LAMP Stack Installation Script
# Author: Emmanuel Keziah
# Date: 21-10-2023
#===================================================================================================


# INSTALLING LAMP STACK- APACHE, MYSQL, PHP
#===================================================================================================
echo "Installing LAMP stack"
sudo apt-get install -y apache2 || exit 1

echo "Installing MySQL"
sudo apt-get install -y mysql-server || exit 1

echo "Preparing to install PHP"
sudo add-apt-repository -y ppa:ondrej/php || exit 1

echo "Updating package list"


echo "Installing PHP and its modules"
echo "..."
if sudo apt-get install -y php; then
    echo "php installed successfully"
else
    echo "ERROR: Failed to install php"
    exit 1
fi

if sudo apt-get install -y libapache2-mod-php; then
    echo "libapache2-mod-php installed successfully"
else
    echo "ERROR: Failed to install libapache2-mod-php"
    exit 1
fi

if sudo apt-get install -y php-common; then
    echo "php-common installed successfully"
else
    echo "ERROR: Failed to install php-common"
    exit 1
fi

if sudo apt-get install -y php-xml; then
    echo "php-xml installed successfully"
else
    echo "ERROR: Failed to install php-xml"
    exit 1
fi

if sudo apt-get install -y php-mysql; then
    echo "php-mysql installed successfully"
else
    echo "ERROR: Failed to install php-mysql"
    exit 1
fi

if sudo apt-get install -y php-gd; then
    echo "php-gd installed successfully"
else
    echo "ERROR: Failed to install php-gd"
    exit 1
fi

if sudo apt-get install -y php-tokenizer; then
    echo "php-tokenizer installed successfully"
else
    echo "ERROR: Failed to install php-tokenizer"
    exit 1
fi

if sudo apt-get install -y php-json; then
    echo "php-json installed successfully"
else
    echo "ERROR: Failed to install php-json"
    exit 1
fi

if sudo apt-get install -y php-mbstring; then
    echo "php-mbstring installed successfully"
else
    echo "ERROR: Failed to install php-mbstring"
    exit 1
fi

if sudo apt-get install -y php-curl; then
    echo "php-curl installed successfully"
else
    echo "ERROR: Failed to install php-curl"
    exit 1
fi 

if sudo apt-get install -y php-bcmath; then
    echo "php-bcmath installed successfully"
else
    echo "ERROR: Failed to install php-bcmath"
    exit 1
fi

if sudo apt-get install -y php-zip; then
    echo "php-zip installed successfully"
else
    echo "ERROR: Failed to install php-zip"
    exit 1
fi

if sudo apt-get install -y unzip; then
    echo "unzip installed successfully"
else
    echo "ERROR: Failed to install unzip"
    exit 1
fi
#===================================================================================================


#      CONFIGURING APACHE2 WEB SERVER
#===================================================================================================
echo "Configuring apache2 web server"
cat <<EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
    ServerName 192.168.13.14
    ServerAdmin keziahema@gmail.com
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
#===================================================================================================

#     CLONING PHP Laravel GitHub Repository:
#===================================================================================================
cd /var/www/html && git clone https://github.com/laravel/laravel.git
#===================================================================================================


#      ENABLING APACHE MODULES
#===================================================================================================
echo "Enabling Apache Modules"
sudo a2enmod rewrite || exit 1
#===================================================================================================


#     ENABLING THE LARAVEL CONFIGURATION FILE
#===================================================================================================
sudo a2ensite laravel.conf || exit 1 
#===================================================================================================


#     RESTARTING APACHE WEB SERVER
#===================================================================================================
echo "Restarting Apache Web Server"
sudo systemctl restart apache2 || exit 1
#===================================================================================================
echo "LAMP stack installed successfully"
#===================================================================================================




#   CONFIGURING MYSQL
#===================================================================================================
echo "Configuring MySQL"
