
#/bin/bash

#===================================================================================================
# Program: LAMP Stack Installation Script
# Author: Emmanuel Keziah
#To run this script, use the command: sudo bash LampInstallation.sh or ./LampInstallation.sh
#===================================================================================================

# INSTALLING LAMP STACK- APACHE, MYSQL, PHP FOR MASTER AND SLAVE 
#===================================================================================================

#  DECLARING VARIABLES
APACHE_PACKAGE="apache2"
PHP_PACKAGES=("libapache2-mod-php" "php-mysql" "php-curl" "php-gd" "php-mbstring" "php-xml" "php-xmlrpc")
MYSQL_PACKAGE="mysql"
MYSQL_ROOT_PASSWORD="LAMP"
WWW_DIR="/var/www"
HTML_DIR="$WWW_DIR/html"
PHPINFO_FILE="$HTML_DIR/phpinfo.php"


echo "Installing LAMP stack"
if sudo apt-get update -y; then
    echo "Package list updated successfully"
else
    echo "ERROR: Failed to update package list"
    exit 1
fi

if sudo apt-get upgrade -y; then
    echo "Packages upgraded successfully"
else
    echo "ERROR: Failed to upgrade packages"
    exit 1
fi

#  Installing Apache
if ! dkpg -l | grep -q "$APACHE_PACKAGE"; then
  echo "Installing $APACHE_PACKAGE"
  sudo apt-get install -y "$APACHE_PACKAGE" || exit 1
else
    echo "$APACHE_PACKAGE already installed"
fi

#  Adding firewall rules
echo "Adding firewall rules"
if sudo ufw app list | grep -q "Apache"; then
    echo "Firewall rules already added"
else
    sudo ufw allow in "Apache"
    echo "Firewall rules added successfully"
fi

#  Checking Apache status
if sudo systemctl status "$APACHE_PACKAGE" | grep -q "active (running)"; then
    echo "$APACHE_PACKAGE is running"
else
    echo "ERROR: $APACHE_PACKAGE is not running"
    sudo systemctl start "$APACHE_PACKAGE" ||exit 1
fi

#  Installing PHP and its modules
echo "Installing PHP and its modules"
for package in "${PHP_PACKAGES[@]}"; do
    if ! dkpg -l | grep -q "$package"; then
        echo "Installing $package"
        sudo apt-get install -y "$package" || exit 1
    else
        echo "$package already installed"
    fi
done

#  Installing MySQL
if ! dpkg -l | grep -q "$MYSQL_PACKAGE"; then
  echo "Installing $MYSQL_PACKAGE"
  sudo apt-get install -y "$MYSQL_PACKAGE" || exit 1
else
    echo "$MYSQL_PACKAGE already installed"
fi

#  Checking MySQL status
if sudo systemctl status "$MYSQL_PACKAGE" | grep -q "active (running)"; then
    echo "$MYSQL_PACKAGE is running"
else
    echo "ERROR: $MYSQL_PACKAGE is not running"
    sudo systemctl start "$MYSQL_PACKAGE" || exit 1
fi
# Setting MySQL root password
if sudo debconf-set-selections <<< "mysql-server-$MYSQL_PACKAGE mysql-server/root_password password $MYSQL_ROOT_PASSWORD"; then
    echo "MySQL root password set successfully"
else
    echo "ERROR: Failed to set MySQL root password"
    exit 1
fi

if sudo debconf-set-selections <<< "mysql-server-$MYSQL_PACKAGE mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"; then
    echo "MySQL root password confirmed successfully"
else
    echo "ERROR: Failed to confirm MySQL root password"
    exit 1
fi

# Running MySQL secure installation
if sudo mysql_secure_installation; then
    echo "MySQL secure installation completed successfully"
else
    echo "ERROR: Failed to run MySQL secure installation"
    exit 1
fi

#  Installing php
echo "Preparing to install PHP"
sudo add-apt-repository -y ppa:ondrej/php || exit 1

echo "Updating package list"
if sudo apt-get update -y; then
    echo "Package list updated successfully"
else
    echo "ERROR: Failed to update package list"
    exit 1
fi

echo "Installing PHP and its modules"
echo "..."
if sudo apt-get install -y php php-common php-xml php-mysql php-gd php-tokenizer; then
    echo "php installed successfully"
else
    echo "ERROR: Failed to install php"
    exit 1
fi

#  Creating phpinfo.php file
echo "Creating phpinfo.php file"
if sudo touch "$PHPINFO_FILE"; then
    echo "phpinfo.php file created successfully"
else
    echo "ERROR: Failed to create phpinfo.php file"
    exit 1
fi

#  Adding content to phpinfo.php file
echo "Adding content to phpinfo.php file"
if sudo echo "<?php phpinfo(); ?>" > "$PHPINFO_FILE"; then
    echo "Content added to phpinfo.php file successfully"
else
    echo "ERROR: Failed to add content to phpinfo.php file"
    exit 1
fi
#  VALIDATION OF PHP AUTHENTICATION FILE WITH APACHE
echo "Validating php authentication file with apache"
if sudo sed -i 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g' /etc/apache2/mods-enabled/dir.conf; then
    echo "php authentication file validated successfully"
else
    echo "ERROR: Failed to validate php authentication file"
    exit 1
fi

# Automate the MySQL Password Validation
echo "Automating MySQL Password Validation..."
expect -c '
spawn sudo mysql_secure_installation
expect "Press y|Y for Yes, any other key for No:"
send "y\r"
expect eof
'


