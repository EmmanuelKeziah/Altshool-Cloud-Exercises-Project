Vagrant.configure("2") do |config|
#Set up Slave VM
config.vm.define "slave" do |slave|
  slave.vm.box = "ubuntu/focal64"
  slave.vm.network "private_network", ip: "192.168.60.15"

  config.vm.provider "virtualbox" do |virtualbox|
        virtualbox.memory = "1024"
        virtualbox.cpus = "1"
  end

  #Define the box and hostname for Slave VM
    slave.vm.hostname = "SLAVE"

    #Define the IP address for Slave VM
    slave.vm.network "private_network", ip: "192.168.60.15"

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
    ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.60.11

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
    if ! dpkg -l | grep -q apache2; then
        echo "Installing apache2"
        sudo apt-get install -y apache2 || exit 1
    else
        echo "apache2 is already installed"
    fi

    # Add firewall rule only if Apache is installed
    if dpkg -l | grep -q apache2; then
        echo "Adding firewall rule for apache2"
        sudo ufw allow in "Apache Full" || exit 1
    fi

    # Check Apache status and set to start on boot
    if sudo systemctl status apache2 | grep -q "active (running)"; then
        echo "apache2 is running"
    else
        echo "apache2 is not running"
        sudo systemctl start apache2 || exit 1
    fi

    # Install PHP Packages on Slave VM
    for package in "php7.4 php7.4-mysql php7.4-curl php7.4-gd php7.4-mbstring php7.4-xml php7.4-xmlrpc"; do
        if ! dpkg -l | grep -q ; then
            echo "Installing "
            sudo apt-get install -y  || exit 1
        else
            echo " is already installed"
        fi
    done

    # Install MySQL on Slave VM
    if ! dpkg -l | grep -q mysql-server; then
        echo "Installing mysql-server"
        sudo apt-get install -y mysql-server || exit 1
    else
        echo "mysql-server is already installed"
    fi

    # Check MySQL status and set to start on boot
    if sudo systemctl status mysql-server | grep -q "active (running)"; then
        echo "mysql-server is running"
    else
        echo "mysql-server is not running"
        sudo systemctl start mysql-server || exit 1
    fi

    # Set MySQL root password
    if sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password password" && sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password password"; then
        echo "MySQL root password is set"
    else
        echo "Failed to set MySQL root password"
        exit 1
    fi

    # Running my_sql_secure_installation
    if sudo mysql_secure_installation<<EOF
    password
    n
    password
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
