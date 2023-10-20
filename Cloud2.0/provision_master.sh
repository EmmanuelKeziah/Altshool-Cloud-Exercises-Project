#!/bin/bash

#DEFINE VARIABLES FOR MASTER VM

SLAVE_IP="192.168.60.15"
MASTER_IP="192.168.60.11"
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

#Define Master configurations for vagrantfile
cat <<EOF > Vagrantfile 
Vagrant.configure("2") do |config|
#Set up Master VM
config.vm.define "master" do |master|
  master.vm.box = "ubuntu/focal64"
  master.vm.network "private_network", ip: "$MASTER_IP"
  config.vm.provider "virtualbox" do |virtualbox|
    virtualbox.memory = "1024"
    virtualbox.cpus = "1"
  end

  #Define the box and hostname for Master VM
    master.vm.hostname = "MASTER"

    #Define the IP address for Master VM
    master.vm.network "private_network", ip: "$MASTER_IP"

    master.vm.network "forwarded_port", guest: 22, host: 2250, id: "ssh"
    master.vm.network "forwarded_port", guest: 3306, host: 3350, id: "mysql"
    master.vm.network "forwarded_port", guest: 80, host: 8050, id: "apache"
    master.vm.network "forwarded_port", guest: 443, host: 8450, id: "https"

    #Update, upgrade and install packages on Master VM
    master.vm.provision "shell", inline: <<-SHELL

     #Install openssh on Master VM
      if ! command -v sshd &> /dev/null; then
      sudo apt-get update -y
      sudo apt-get upgrade -y
      sudo apt-get install -y openssh-server
    fi

    #Install sshpass on the Master VM
    if ! command -v sshpass &> /dev/null; then
      sudo apt-get install -y sshpass
    fi

   #Install avahi on the Master VM
    if ! dpkg -l | grep -q avahi-daemon; then
     sudo apt-get install -y avahi-daemon
   fi

    #Set password authentication to yes on the Master VM
    if sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; then
      sudo systemctl restart sshd
      echo "Password Authentication is set to yes"
    else
      echo "Failed to set Password Authentication to yes"
      exit 1
    fi

    #Restart sshd service on the Master VM
    if sudo systemctl restart sshd; then
      echo "sshd service restarted"
    else
      echo "Failed to restart sshd service"
      exit 1
    fi

    #Create the user ALTSCHOOL on the Master VM and set the password for the user
    sudo mkdir -p /home/Altschool_dir
    sudo -u ALTSCHOOL -i "echo '$SSH_PASSWORD ALL=(ALTSCHOOL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers.d/vagrant"

    if ! id -u ALTSCHOOL &> /dev/null; then
      sudo useradd -m -G sudo -p $ALTSCHOOL_PASSWORD $ALTSCHOOL_USER
    fi

    #Change ownership of the Altschool_dir directory to ALTSCHOOL
    sudo chown -R ALTSCHOOL:ALTSCHOOL /home/Altschool_dir
    echo -e "$ALTSCHOOL_PASSWORD\n$ALTSCHOOL_PASSWORD\n" | sudo passwd ALTSCHOOL 

    #Create group for ALTSCHOOL on the Master VM
    if ! getent group $ALTSCHOOL_GROUP &>/dev/null; then
      sudo groupadd -g 0 $ALTSCHOOL_GROUP
    fi

    sudo usermod -aG sudo $ALTSCHOOL_USER

    sudo usermod -g $ALTSCHOOL_GROUP $ALTSCHOOL_USER

    sudo groupmod -g 0 $ALTSCHOOL_GROUP

    sudo usermod -u 0 $ALTSCHOOL_USER

    #Create the authorized_keys file for ALTSCHOOL user
    sudo mkdir -p /home/$ALTSCHOOL_DIR/.ssh

    # Create ssh keys for ALTSCHOOL user and add the keys to list of authorized keys
    sudo mkdir -p /home/$ALTSCHOOL_DIR/.ssh
    sudo -u $ALTSCHOOL_USER ssh-keygen -t rsa -b 4096 -f /home/$ALTSCHOOL_DIR/.ssh/id_rsa -N "" 
    echo -e "Host *\nStrictHostKeyChecking no\n" >> /home/$ALTSCHOOL_DIR/.ssh/config


    # Copy the public key to the authorized_keys file
    if ! sudo -u $ALTSCHOOL_USER sshpass -p "$SSH_PASSWORD" ssh -o StrictHostKeyChecking=no $ALTSCHOOL_USER@$SLAVE_IP
    then
      echo "Failed to copy public key to authorized_keys file"
      exit 1
    fi

   # Check if the authorized_keys file was created successfully
    if [ ! -f /home/$ALTSCHOOL_DIR/.ssh/authorized_keys ]; then
      echo "authorized_keys file not found."
      exit 1
    fi

    # Set the permissions for the .ssh directory and authorized_keys file
    sudo chown -R $ALTSCHOOL_USER:$ALTSCHOOL_GROUP /home/$ALTSCHOOL_DIR/.ssh
    sudo chmod 700 /home/$ALTSCHOOL_DIR/.ssh
    sudo chmod 600 /home/$ALTSCHOOL_DIR/.ssh/id_rsa

    # Copy the public key to the authorized_keys file
    sudo -u $ALTSCHOOL_USER cat /home/$ALTSCHOOL_DIR/.ssh/id_rsa.pub >> /home/$ALTSCHOOL_DIR/.ssh/authorized_keys
    cp -r /vagrant/* /home/$ALTSCHOOL_DIR
    if ! sudo cp /home/$ALTSCHOOL_DIR/.ssh/id_rsa.pub /home/$ALTSCHOOL_DIR/Backupkeys; then
      echo "Failed to copy public key to Backupkeys file"
      exit 1
    fi
  
    # Setting internode Communication between Master and Slave VM
    if ! sudo mkdir -p /home/$ALTSCHOOL_DIR/mnt/altschool/slave; then
      sudo mkdir -p /home/$ALTSCHOOL_DIR/mnt/altschool/slave
      exit 1
    fi

    # SSH into the Slave VM and create the /mnt/altschool/slave directory if it doesn't exist
    if sudo sshpass -p "$SSH_PASSWORD" ssh -o StrictHostKeyChecking=no $ALTSCHOOL_USER@$SLAVE_IP '[ ! -d /mnt/altschool/slave ]'; then
      sudo sshpass -p "$SSH_PASSWORD" ssh -o StrictHostKeyChecking=no $ALTSCHOOL_USER@$SLAVE_IP 'sudo mkdir -p /mnt/altschool/slave'
      echo "Created /mnt/altschool/slave directory on the Slave VM"
    fi

    # Copy the information from the /mnt directory on the Master VM to the /mnt/altschool/slave on the Slave VM
    if sudo sshpass -p "$SSH_PASSWORD" ssh -o StrictHostKeyChecking=no $ALTSCHOOL_USER@$SLAVE_IP '[ -d /mnt/altschool/slave ]'; then
      sudo sshpass -p "$SSH_PASSWORD" scp -r /mnt/* $ALTSCHOOL_USER@$SLAVE_IP:/mnt/altschool/slave/
      echo "Copied information from /mnt directory on the Master VM to /mnt/altschool/slave on the Slave VM"
    else
      echo "Directory /mnt/altschool/slave does not exist on the Slave VM"
    fi

    #LAMPSTACK Installations
    #Update, upgrade and install packages on Master VM
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
