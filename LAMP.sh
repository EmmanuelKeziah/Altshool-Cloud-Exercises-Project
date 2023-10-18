#!/bin/bash

# Common variables
APACHE_PACKAGE="apache2"
PHP_PACKAGES=("php7.4" "php7.4-mysql" "php7.4-curl" "php7.4-gd" "php7.4-mbstring" "php7.4-xml" "php7.4-xmlrpc")
MYSQL_PACKAGE="mysql-server"
MYSQL_ROOT_PASSWORD="LAMP"
WWW_DIR="/var/www"
HTML_DIR="$WWW_DIR/html"
PHPINFO_FILE="$HTML_DIR/phpinfo.php"
MASTER_IP="192.168.60.11"
SLAVE_IP="192.168.60.10"

# Function to install a package if it's not already installed
install_package() {
    package=$1
    if ! dpkg -l | grep -q $package; then
        echo "Installing $package..."
        sudo apt-get install $package -y || exit 1
    else
        echo "$package is already installed. Skipping..."
    fi
}

# SSH into the master VM and run the commands
echo "Running on MASTER VM:"
ssh -o StrictHostKeyChecking=no vagrant@$MASTER_IP "echo 'Running on $(hostname) VM'; sudo apt-get update -y; sudo apt-get upgrade -y"

# Update, upgrade, and install packages on the VM

echo -e "\n\nUpdating Apt Packages and upgrading latest patches\n"
sudo apt-get update -y || exit 1
sudo apt-get upgrade -y || exit 1


# Install Apache package
install_package $APACHE_PACKAGE

# Add firewall rule only if Apache is installed
if dpkg -l | grep -q $APACHE_PACKAGE; then
    echo -e "\n\nAdding firewall rule to Apache\n"
    sudo ufw allow in "Apache" || exit 1
fi

# Check Apache status and set to start on boot
if sudo systemctl status $APACHE_PACKAGE; then
    sudo systemctl enable $APACHE_PACKAGE || exit 1
else
    echo "$APACHE_PACKAGE is not running on the VM. Exiting..."
    exit 1
fi

# Install PHP packages
for package in "${PHP_PACKAGES[@]}"; do
    install_package $package
done

# Install php-mcrypt package
if [[ $(lsb_release -rs) == "18.04" ]]; then
    install_package "php7.4-mcrypt"
else
    echo "php-mcrypt package is not available on this version of Ubuntu. Skipping..."
fi

# SSH into the slave VM and run the commands
echo "Running on SLAVE VM:"
ssh -o StrictHostKeyChecking=no vagrant@$SLAVE_IP "echo 'Running on $(hostname) VM'; sudo apt-get update -y; sudo apt-get upgrade -y"

# Update, upgrade, and install packages on the VM

echo -e "\n\nUpdating Apt Packages and upgrading latest patches\n"
sudo apt-get update -y || exit 1
sudo apt-get upgrade -y || exit 1


# Install Apache package
install_package $APACHE_PACKAGE

# Add firewall rule only if Apache is installed
if dpkg -l | grep -q $APACHE_PACKAGE; then
    echo -e "\n\nAdding firewall rule to Apache\n"
    sudo ufw allow in "Apache" || exit 1
fi

# Check Apache status and set to start on boot
if sudo systemctl status $APACHE_PACKAGE; then
    sudo systemctl enable $APACHE_PACKAGE || exit 1
else
    echo "$APACHE_PACKAGE is not running on the VM. Exiting..."
    exit 1
fi

# Install PHP packages
for package in "${PHP_PACKAGES[@]}"; do
    install_package $package
done

# Install php-mcrypt package
if [[ $(lsb_release -rs) == "18.04" ]]; then
    install_package "php7.4-mcrypt"
else
    echo "php-mcrypt package is not available on this version of Ubuntu. Skipping..."
fi


# Install MySQL server
install_package $MYSQL_PACKAGE

# Set MySQL root password
if sudo debconf-set-selections <<< "$MYSQL_PACKAGE $MYSQL_PACKAGE/root_password password $MYSQL_ROOT_PASSWORD" && sudo debconf-set-selections <<< "$MYSQL_PACKAGE $MYSQL_PACKAGE/root_password_again password $MYSQL_ROOT_PASSWORD"; then
    echo -e "\n\nMySQL root password successfully set to $MYSQL_ROOT_PASSWORD"
else
    echo -e "\n\nUnable to set MySQL root password. Exiting..."
    exit 1
fi

# Running mysql_secure_installation
if sudo mysql_secure_installation <<EOF
$MYSQL_ROOT_PASSWORD
n
$MYSQL_ROOT_PASSWORD
Y
Y
Y
Y
EOF
then
    echo -e "\n\nMySQL secure installation completed successfully"
else
    echo -e "\n\nMySQL secure installation failed. Exiting..."
    exit 1
fi

# Create directory if it doesn't exist
if sudo mkdir -p $HTML_DIR; then
    echo -e "\n\nCreated directory $HTML_DIR successfully"
else
    echo -e "\n\Failed to create directory $HTML_DIR. Exiting..."
    exit 1
fi

# Create phpinfo.php
if echo '<?php phpinfo(); ?>' | sudo tee $PHPINFO_FILE; then
    echo -e "\n\nCreated $PHPINFO_FILE successfully"
else
    echo -e "\n\nFailed to create $PHPINFO_FILE. Exiting..."
    exit 1
fi

# Set permissions for $WWW_DIR
echo -e "\n\nPermissions for $WWW_DIR\n"

# Set ownership to www-data
if sudo chown -R www-data:www-data $WWW_DIR; then
    echo -e "\n\nOwnership for $WWW_DIR set to www-data successfully"
else
    echo -e "\n\nFailed to set ownership for $WWW_DIR. Exiting..."
    exit 1
fi

# Enable Apache Modules
echo -e "\n\nEnabling Modules\n"
if sudo a2enmod rewrite && sudo phpenmod mcrypt; then
    echo -e "\n\nApache modules rewrite and mcrypt enabled successfully"
else
    echo -e "\n\nFailed to enable Apache modules. Exiting..."
    exit 1
fi

# Update Apache configuration
sudo sed -i 's/DirectoryIndex index.html index.cgi index.pl index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/' /etc/apache2/mods-enabled/dir.conf

# Restart Apache
echo -e "\n\nRestarting Apache\n"
if sudo service $APACHE_PACKAGE restart; then
    echo -e "\n\n$APACHE_PACKAGE restarted successfully"
else
    echo -e "\n\nFailed to restart $APACHE_PACKAGE. Exiting..."
    exit 1
fi

echo -e "\n\nLAMP Installation Completed"

exit 0
