#!/bin/bash

#DEFINE VARIABLES FOR SLAVE VM
MASTER_IP="192.168.60.11"
SLAVE_IP="192.168.60.15"
SSH_PASSWORD="vagrant"
ALTSCHOOL_PASSWORD="emperor"
ALTSCHOOL_USER="ALTSCHOOL"
ALTSCHOOL_GROUP="ALTSCHOOL"
ALTSCHOOL_DIR="Altschool_dir"
APACHE_PACKAGE="apache2"
PHP_PACKAGES=("php7.4" "php7.4-mysql" "php7.4-curl" "php7.4-gd" "php7.4-mbstring" "php7.4-xml" "php7.4-xmlrpc")
MYSQL_PACKAGE="mysql-server"
MYSQL_ROOT_PASSWORD="LAMP"
WWW_DIR="/var/www"
HTML_DIR="$WWW_DIR/html"
PHPINFO_FILE="$HTML_DIR/phpinfo.php"
MYSQL_ROOT_PASSWORD="password"

#Define Slave configurations for vagrantfile
cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|
#Set up Slave VM
config.vm.define "slave" do |slave|
  slave.vm.box = "ubuntu/focal64"
  slave.vm.network "private_network", ip: "$SLAVE_IP"

  config.vm.provider "virtualbox" do |virtualbox|
        virtualbox.memory = "1024"
        virtualbox.cpus = "1"
  end

  #Define the box and hostname for Slave VM
    slave.vm.hostname = "SLAVE"

    #Define the IP address for Slave VM
    slave.vm.network "private_network", ip: "$SLAVE_IP"

    slave.vm.network "forwarded_port", guest: 22, host: 2251, id: "ssh"

    slave.vm.network "forwarded_port", guest: 3306, host: 3352, id: "mysql"

    slave.vm.network "forwarded_port", guest: 80, host: 8051, id: "apache"

    slave.vm.network "forwarded_port", guest: 443, host: 8456, id: "https"

    #Update, upgrade and install packages on Slave VM
    slave.vm.provision "shell", inline: <<-SHELL

     #Install openssh on Slave VM
      if ! command -v sshd &> /dev/null; then
      sudo apt-get update -y
      sudo apt-get upgrade -y
      sudo apt-get install -y openssh-server
    fi

    #Install sshpass on the Slave VM
    if ! command -v sshpass &> /dev/null; then
      sudo apt-get install -y sshpass
    fi

   #Install avahi on the Slave VM
    if ! dpkg -l | grep -q avahi-daemon; then
     sudo apt-get install -y avahi-daemon
   fi

  #Set password authentication to yes on the Slave VM
     sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

    # Copying SSH Keys
    ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@$MASTER_IP

    # Restart sshd service on the Slave VM
    if sudo systemctl restart sshd; then
      echo "sshd service restarted"
    else
      echo "Failed to restart sshd service"
      exit 1
    fi


    # Create the /mnt/altschool/slave directory on the Slave VM
    if ! sudo mkdir -p /mnt/altschool/slave; then
      exit 1
    fi
    # Set permissions for the /mnt/altschool/slave directory on the Slave VM
    if sudo chmod -R 777 /mnt/altschool/slave; then
    echo "Permissions have been set"
    else
    echo "Failed to set permissions"
      exit 1
    fi

    #Check currently running processes and storing them in a file on the Slave VM 
    if sudo ps aux > /home/vagrant/processes.txt; then
      echo "Processes have been stored in processes.txt"
    else
      echo "Failed to store processes in processes.txt"
      exit 1
    fi



    # Setting LAMPSTACK Installations
    # Update, upgrade and install packages on Slave VM
    if sudo apt-get update -y; then
        echo "apt-get update -y was successful"
    else
        echo "apt-get update -y was not successful"
      exit 1
    fi

    if sudo apt-get upgrade -y; then
        echo "apt-get upgrade -y was successful"
    else
        echo "apt-get upgrade -y was not successful"
      exit 1
    fi

    # Install Apache on Slave VM
    if ! dpkg -l | grep -q $APACHE_PACKAGE; then
        echo "Installing $APACHE_PACKAGE"
        sudo apt-get install -y $APACHE_PACKAGE || exit 1
    else
        echo "$APACHE_PACKAGE is already installed"
    fi

    # Add firewall rule only if Apache is installed
    if dpkg -l | grep -q $APACHE_PACKAGE; then
        echo "Adding firewall rule for $APACHE_PACKAGE"
        sudo ufw allow in "Apache Full" || exit 1
    fi

    # Check Apache status and set to start on boot
    if sudo systemctl status $APACHE_PACKAGE | grep -q "active (running)"; then
        echo "$APACHE_PACKAGE is running"
    else
        echo "$APACHE_PACKAGE is not running"
        sudo systemctl start $APACHE_PACKAGE || exit 1
    fi

    # Install PHP Packages on Slave VM
    for package in "${PHP_PACKAGES[@]}"; do
        if ! dpkg -l | grep -q $package; then
            echo "Installing $package"
            sudo apt-get install -y $package || exit 1
        else
            echo "$package is already installed"
        fi
    done

    # Install MySQL on Slave VM
    if ! dpkg -l | grep -q $MYSQL_PACKAGE; then
        echo "Installing $MYSQL_PACKAGE"
        sudo apt-get install -y $MYSQL_PACKAGE || exit 1
    else
        echo "$MYSQL_PACKAGE is already installed"
    fi

    # Check MySQL status and set to start on boot
    if sudo systemctl status $MYSQL_PACKAGE | grep -q "active (running)"; then
        echo "$MYSQL_PACKAGE is running"
    else
        echo "$MYSQL_PACKAGE is not running"
        sudo systemctl start $MYSQL_PACKAGE || exit 1
    fi

    # Set MySQL root password
    if sudo debconf-set-selections <<< "$MYSQL_PACKAGE $MYSQL_PACKAGE/root_password password $MYSQL_ROOT_PASSWORD" && sudo debconf-set-selections <<< "$MYSQL_PACKAGE $MYSQL_PACKAGE/root_password_again password $MYSQL_ROOT_PASSWORD"; then
        echo "MySQL root password is set"
    else
        echo "Failed to set MySQL root password"
        exit 1
    fi

    # Running my_sql_secure_installation
    if sudo mysql_secure_installation<<EOF
    $MYSQL_ROOT_PASSWORD
    n
    $MYSQL_ROOT_PASSWORD
    Y
    Y
    Y
    Y
  EOF
        echo "MySQL secure installation was successful"
    else
        echo "MySQL secure installation was not successful"
        exit 1
    fi
   SHELL
   end
  end
EOF

