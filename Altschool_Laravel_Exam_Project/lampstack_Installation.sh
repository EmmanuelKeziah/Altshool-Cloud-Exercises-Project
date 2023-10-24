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

#  INSTALLING MYSQL
echo "Installing MySQL"
if sudo apt-get install -y mysql-server; then
    echo "MySQL installed successfully"
else
    echo "ERROR: Failed to install MySQL"
    exit 1
fi

echo "Preparing to install PHP"
sudo add-apt-repository -y ppa:ondrej/php || exit 1

echo "Updating package list"
sudo apt-get update -y || exit 1

#  INSTALLING PHP AND ITS MODULES
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

#Modify the php.ini file for Apache web server
sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini || exit 1

sudo systemctl restart apache2


#===================================================================================================


#  Automated Installation of curl
sudo apt install curl -y
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

if ! command -v composer &> /dev/null; then
    echo "Composer not found, please install it manually."
    exit 1
fi

# Create a non-root user with sudo privileges
if sudo adduser AltCompose; then
  sudo usermod -aG sudo AltCompose

  # Switch to the new user
  su - AltCompose
else
  echo "Failed to create user AltCompose"
fi

#  Move composer.phar to /usr/local/bin/composer
sudo mv composer.phar /usr/local/bin/composer

#  Check composer version
composer --version
cd /var/www/html/laravel && cp .env.example .env


#      CONFIGURING APACHE2 WEB SERVER
#===================================================================================================
echo "Configuring apache2 web server"

# Create laravel.conf file in /etc/apache2/sites-available directory
cat <<EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
    ServerName 192.168.13.14
    ServerAlias keziahema@gmail.com
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



# GIT CLONE (LARAVEL)
#===================================================================================================
mkdir /var/www/html/laravel && cd /var/www/html/laravel

cd /var/www/html && sudo git clone https://github.com/laravel/laravel.git || exit 1
#===================================================================================================


#Changing Ownership of the laravel directory
sudo chown -R www-data:www-data /var/www/html/laravel || exit 1

sudo chmod -R 775 /var/www/html/laravel || exit 1

sudo chmod -R 777 /var/www/html/laravel/storage || exit 1

sudo chmod -R 777 /var/www/html/laravel/bootstrap/cache || exit 1

cd /var/www/html/laravel && sudo cp .env.example .env || exit 1

php artisan key:generate || exit 1
#===================================================================================================



#   CONFIGURING MYSQL
#===================================================================================================
# Passing a function to generate a random password if not provided
random_pass() {
    if [ -z "$1" ]; then
        openssl rand -base64 8
    else
        echo "$1"
    fi
}

# Function to configure MySQL
mysql_config() {
    set_username="$1"
    set_database="$2"
    set_password="$3"

    echo "Configuring MySQL"
    echo "Creating MySQL user and database"

    # Generate a password if not provided
    password=$(random_pass "$password")

    # Run MySQL commands
    mysql -u root <<MYSQL_SCRIPT
    CREATE DATABASE $database;
    CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';
    GRANT ALL PRIVILEGES ON $database.* TO '$username'@'localhost';
    FLUSH PRIVILEGES;
MYSQL_SCRIPT

    echo "MySQL user created."
    echo "Username:   $username"
    echo "Database:   $database"
    echo "Password:   $password"
}
# To run the function, pass the username, database name and password as arguments 
# e.g. sudo ./lampstack_installation.sh "username" "database_name" "password". In this case,  `sudo bash ./lampstack_installation LARAVEL Lamp` will be used instead

 
# Set the username, database name and password for MySQL
sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=laravel/' /var/www/html/laravel/.env

sudo sed -i 's/DB_USERNAME=root/DB_USERNAME=laravel/' /var/www/html/laravel/.env

sudo sed -i 's/DB_PASSWORD=/DB_PASSWORD=laravel/' /var/www/html/laravel/.env

php artisan config:cache || exit 1

cd /var/www/html/laravel && php artisan migrate || exit 1


#Restart Apache
sudo systemctl restart apache2


echo "LAMP stack installed successfully"
#===================================================================================================







