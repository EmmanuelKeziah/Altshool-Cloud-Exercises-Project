#!/bin/bash
#===================================================================================================
# Program: LAMP Stack Installation Script
# Author: Emmanuel Keziah
# Date: 21-10-2023
#===================================================================================================


# INSTALLING LAMP STACK- APACHE, MYSQL, PHP
#=============================================================================================
echo "Checking system updates"
 if sudo apt-get update -y; then
    echo "Package updates installed successfully"
else
    echo "ERROR: Failed to install system updates"
    exit 1
fi

echo "Installing LAMP stack"
if sudo apt-get install -y apache2; then
    echo "Apache installed successfully"  
    sudo systemctl start apache2
else
    echo "ERROR: Failed to install Apache"
    exit 1
fi

# CONFIGURING APACHE2 WEB SERVER
#===================================================================================================
echo "Configuring apache2 web server"

# Create laravel.conf file in /etc/apache2/sites-available directory
echo "<VirtualHost *:80>
    ServerName 192.168.13.14
    ServerAlias keziahema@gmail.com
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" | sudo tee /etc/apache2/sites-available/laravel.conf > /dev/null
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

#  INSTALLING PHP AND ITS MODULES
echo "Preparing to install PHP"
sudo add-apt-repository -y ppa:ondrej/php 

echo "Updating package list"
sudo apt-get update -y || exit 1
echo "Installing PHP and its modules"
echo "..."
if sudo apt-get install -y php; then
    echo "php installed successfully"
else
    echo "ERROR: Failed to install php"
        sudo apt-get install -y php
    exit 1
fi

if sudo apt-get install -y libapache2-mod-php; then
    echo "libapache2-mod-php installed successfully"
else
    echo "ERROR: Failed to install libapache2-mod-php"
        sudo apt-get install -y libapache2-mod-php
    exit 1
fi

if sudo apt-get install -y php-common; then
    echo "php-common installed successfully"
else
    echo "ERROR: Failed to install php-common"
        sudo apt-get install -y php-common
    exit 1
fi

if sudo apt-get install -y php-xml; then
    echo "php-xml installed successfully"
else
    echo "ERROR: Failed to install php-xml"
        sudo apt-get install -y php-xml
    exit 1
fi

if sudo apt-get install -y php-mysql; then
    echo "php-mysql installed successfully"
else
    echo "ERROR: Failed to install php-mysql"
        sudo apt-get install -y php-mysql
    exit 1
fi

if sudo apt-get install -y php-gd; then
    echo "php-gd installed successfully"
else
    echo "ERROR: Failed to install php-gd"
        sudo apt-get install -y php-gd
    exit 1
fi

if sudo apt-get install -y php-tokenizer; then
    echo "php-tokenizer installed successfully"
else
    echo "ERROR: Failed to install php-tokenizer"
        sudo apt-get install -y php-tokenizer
    exit 1
fi

if sudo apt-get install -y php-json; then
    echo "php-json installed successfully"
else
    echo "ERROR: Failed to install php-json"
        sudo apt-get install -y php-json
    exit 1
fi

if sudo apt-get install -y php-mbstring; then
    echo "php-mbstring installed successfully"
else
    echo "ERROR: Failed to install php-mbstring"
        sudo apt-get install -y php-mbstring
    exit 1
fi

if sudo apt-get install -y php-curl; then
    echo "php-curl installed successfully"
else
    echo "ERROR: Failed to install php-curl"
        sudo apt-get install -y php-curl
    exit 1
fi 

if sudo apt-get install -y php-bcmath; then
    echo "php-bcmath installed successfully"
else
    echo "ERROR: Failed to install php-bcmath"
        sudo apt-get install -y php-bcmath
    exit 1
fi

if sudo apt-get install -y php-zip; then
    echo "php-zip installed successfully"
else
    echo "ERROR: Failed to install php-zip"
        sudo apt-get install -y php-zip
    exit 1
fi

if sudo apt-get install -y unzip; then
  echo "unzip installed successfully"
else
    echo "ERROR: Failed to install unzip"
    sudo apt-get install -y unzip
 exit 1
fi
#===================================================================================================

# Modify the php.ini file for Apache web server
if sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini; then
    echo "php.ini file modified successfully"
else
    echo "ERROR: Failed to modify php.ini file"
    exit 1
fi

# Restart Apache web server
if sudo systemctl restart apache2; then
    echo "Apache web server restarted successfully"
else
    echo "ERROR: Failed to restart Apache web server"
    exit 1
fi
#===================================================================================================

# GIT CLONING
#===================================================================================================
if [ -d "/var/www/html/laravel" ]; then
    echo "Laravel directory already exists, skipping git clone"
else
    cd /var/www/html && sudo git clone https://github.com/laravel/laravel.git || exit 1
fi
#===================================================================================================

# INSTALLING COMPOSER
#===================================================================================================
# Downloading composer as altcomposer user
sudo apt-get update -y || exit 1
sudo apt install curl -y
if sudo apt install composer -y; then
    echo "Composer installed successfully"
else
    echo "ERROR: Failed to download Composer"
fi

# Check composer version
if composer --version; then
    echo "Composer is installed on the system"
else
    echo "ERROR: Composer is not installed on the system"
    exit 1
fi

# Create a new user to run Composer and Laravel dependencies if it doesn't exist
sudo useradd altcomposer

if ! id -u altcomposer > /dev/null 2>&1; then
    sudo useradd -m -p $(openssl passwd -1 LaRaVeL_WaHaLa) -G sudo altcomposer && \
    echo "altcomposer user created successfully" || \
    { echo "ERROR: Failed to create altcomposer user"; exit 1; }
fi

# Switch to the new user
if sudo -u altcomposer bash -c 'echo "Switched to altcomposer user successfully"'; then
    :
else
    echo "ERROR: Failed to switch to altcomposer user"
    exit 1
fi

# Change the ownership of the /var/www/html/laravel directory to altcomposer
if sudo chown -R altcomposer:www-data /var/www/html/laravel; then
    echo "Changed ownership of /var/www/html/laravel directory to altcomposer"
else
    echo "ERROR: Failed to change ownership of /var/www/html/laravel directory"
    exit 1
fi
#===================================================================================================

# Generating Laravel application key
if sudo -u altcomposer bash -c 'cd /var/www/html/laravel && composer install && php artisan key:generate'; then
    echo "Laravel application key generated successfully"
else
    echo "ERROR: Failed to generate Laravel application key"
    exit 1
fi
  
# Add the user to the www-data group
if sudo usermod -a -G www-data altcomposer; then
    echo "Added altcomposer to www-data group"
else
    echo "ERROR: Failed to add altcomposer to www-data group"
    exit 1
fi

# Change the ownership of /usr/local/bin to altcomposer
if sudo chown -R altcomposer:www-data /var/www/html/laravel/storage /var/www/html/laravel/bootstrap/cache && \
sudo chmod -R ug+rwx,o+rx /var/www/html/laravel/storage /var/www/html/laravel/bootstrap/cache; then
    echo "Changed ownership of Laravel directories to altcomposer and set permissions"
else
    echo "ERROR: Failed to change ownership of Laravel directories to altcomposer and set permissions"
    exit 1
fi

sudo chmod -R 775 /var/www/html/laravel || exit 1
sudo chmod -R 777 /var/www/html/laravel/storage || exit 1

echo "Laravel Project cloned, Composer installed and Laravel Dependencies installed successfully"
#===================================================================================================

# INSTALLING MYSQL
#===================================================================================================
echo "Installing MySQL"
if sudo apt-get install -y mysql-server; then
    echo "MySQL installed successfully"
else
    echo "ERROR: Failed to install MySQL"
    exit 1
fi

# Setting permissions for MySQL directories
if sudo chown -R mysql:mysql /var/lib/mysql; then
    echo "Changed ownership of /var/lib/mysql directory to mysql"
else
    echo "ERROR: Failed to change ownership of /var/lib/mysql directory"
    exit 1
fi

if sudo chmod -R 775 /var/lib/mysql; then
    echo "Changed permissions of /var/lib/mysql directory to 775"
else
    echo "ERROR: Failed to change permissions of /var/lib/mysql directory"
    exit 1
fi

if sudo chmod -R 777 /var/lib/mysql/mysql; then
    echo "Changed permissions of /var/lib/mysql/mysql directory to 777"
else
    echo "ERROR: Failed to change permissions of /var/lib/mysql/mysql directory"
    exit 1
fi

# Copying the .env.example file to .env
if sudo cp /var/www/html/laravel/.env.example /var/www/html/laravel/.env; then
    echo ".env.example file copied successfully"
else
    echo "ERROR: Failed to copy .env.example file"
    exit 1
fi

#   CONFIGURING MYSQL
# ===================================================================================================
# Function to configure MySQL
mysql_config() {
    set_username="$1"
    set_database="$2"
    set_password="$3"

    echo "Configuring MySQL"
    echo "Creating MySQL user and database"

   # Generate a password if not provided
    if [ -z "$set_password" ]; then
        password=$(openssl rand -base64 8)
    else
        password="$set_password"
    fi

    # Run MySQL commands
    mysql -u root <<MYSQL_SCRIPT
    CREATE DATABASE $set_database;
    CREATE USER '$set_username'@'localhost' IDENTIFIED BY '$password';
    GRANT ALL PRIVILEGES ON $set_database.* TO '$set_username'@'localhost';
    FLUSH PRIVILEGES;
MYSQL_SCRIPT

if [[ $? -eq 0 ]]; then
    echo "MySQL user created."
    echo "Username:   $set_username"
    echo "Database:   $set_database"
    echo "Password:   $password"
else
    echo "ERROR: Failed to create MySQL user and database."
    exit 1
fi
}

# Set the username, database name and password for MySQL
username="root"
database="laravel"
password="LARAVEL_PASSWORD"

# Call the function to configure MySQL
mysql_config "$username" "$database" "$password"
#===================================================================================================
# Caching the configuration
cd /var/www/html/laravel && php artisan config:cache || exit 1

# Migrating the database
cd /var/www/html/laravel && php artisan migrate || exit 1
#===================================================================================================

#    RESTARTING APACHE WEB SERVER 
#===================================================================================================
echo "Restarting Apache Web Server"
sudo systemctl restart apache2 || exit 1
echo "LAMP stack installed successfully"