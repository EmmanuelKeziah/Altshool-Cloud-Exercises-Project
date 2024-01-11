#!/bin/bash




#===================================================================================================

#  DEFINE MASTER CONFIGURATION FOR VAGRANTFILE
#===================================================================================================
cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|
#Set up Slave VM

 config.vm.define "slave" do |slave|
    slave.vm.box = "ubuntu/focal64"
    slave.vm.hostname = "SLAVE"

    # Customize the amount of memory on the VM:
    slave.vm.provider "virtualbox" do |virtualbox|
     virtualbox.memory = "1024"
      virtualbox.cpus = "1"
    end

    # Create a private network, which allows host-only access to the machine using a specific IP.
    slave.vm.network "private_network", ip: "192.168.60.15"

    slave.vm.network "forwarded_port", guest: 22, host: 2251, id: "ssh"

    slave.vm.network "forwarded_port", guest: 3306, host: 3352, id: "mysql"

    slave.vm.network "forwarded_port", guest: 80, host: 8051, id: "apache"

     slave.vm.network "forwarded_port", guest: 443, host: 8456, id: "https"

    #  UPDATE, UPGRADE AND INSTALL PACKAGES ON SLAVE VM
    #===================================================================================================

    slave.vm.provision "shell", inline: <<-SHELL
     #Install openssh on Slave VM
      echo "Checking for updates"
     if sudo apt-get update -y; then
       echo "apt-get update -y was successful"
      fi

      # Upgrade packages
      echo "Upgrading packages"
      sudo apt-get upgrade -y || exit 1

      #Install openssh on Slave VM
      if sudo apt-get install -y openssh-server; then
        echo "openssh installed successfully"
      else
        echo "Failed to install openssh"
        exit 1
      fi

      #Install sshpass on the Slave VM
      if sudo apt-get install -y sshpass; then
        echo "sshpass installed successfully"
       else
        echo "Failed to install sshpass"
       exit 1
      fi

     # Install avahi on the Slave VM
     if ! dkpg -l avahi-daemon; then
       sudo apt-get install -y avahi-daemon libnss-mdns || exit 1
      fi

      # Set password authentication to yes on the Slave VM
      if sudo sed -i 's/PasswordAuthentication no/ PasswordAuthentication yes/g' /etc/ssh/sshd_config; then
        sudo systemctl restart sshd
        echo "Password Authentication is set to yes"
      else
        echo "Failed to set Password Authentication to yes"
        exit 1
      fi

      # CHECKING CURRENTLY RUNNING PROCESSES 
      #===================================================================================================
     if sudo ps aux > /home/vagrant/processes.txt; then
       echo "Processes have been stored in processes.txt"
     else
       echo "Failed to store processes in processes.txt"
       exit 1
     fi
    SHELL
  end
  
  
  config.vm.define "master" do |master|
   master.vm.box = "ubuntu/focal64"
    master.vm.hostname = "MASTER"

   # Customize the amount of memory on the VM:
    config.vm.provider "virtualbox" do |virtualbox|
      virtualbox.memory = "1024"
     virtualbox.cpus = "1" 
    end

    # Create a private network, which allows host-only access to the machine using a specific IP.
    master.vm.network "private_network", ip: "192.168.60.11"
    master.vm.network "forwarded_port", guest: 22, host: 2250, id: "ssh"

    master.vm.network "forwarded_port", guest: 3306, host: 3350, id: "mysql"

    master.vm.network "forwarded_port", guest: 80, host: 8050, id: "apache"

    master.vm.network "forwarded_port", guest: 443, host: 8450, id: "https"


    #Update, upgrade and install packages on Master VM
    #===================================================================================================
   master.vm.provision "shell", inline: <<-SHELL
      #Update package list
      echo "Checking for updates"
      if sudo apt-get update -y; then
        echo "apt-get update -y was successful"
      else
        echo "ERROR: Failed to update package list"
       exit 1
     fi

      # Upgrade packages
      echo "Upgrading packages"
      sudo apt-get upgrade -y || exit 1

      #Install openssh on Master VM
      if sudo apt-get install -y openssh-server;
      then
        echo "openssh installed successfully"
      else
        echo "Failed to install openssh"
        exit 1
      fi

      #Install sshpass on the Master VM
      if sudo apt-get install -y sshpass;
      then
        echo "sshpass installed successfully"
      else
        echo "Failed to install sshpass"
        exit 1 
      fi

      # Installing avahi-daemon
      if ! dkpg -l avahi-daemon; then
        sudo apt-get install -y avahi-daemon libnss-mdns || exit 1
      fi

      # Set password authentication to yes on the Master VM
      if sudo sed -i 's/PasswordAuthentication no/ PasswordAuthentication yes/g' /etc/ssh/sshd_config;
      then
        sudo systemctl restart sshd
        echo "Password Authentication is set to yes"
      else
        echo "Failed to set Password Authentication to yes"
        exit 1
      fi

      #  Restart sshd service on the Master VM
      if sudo systemctl restart sshd; then
        echo "sshd service restarted"
      else
        echo "Failed to restart sshd service"
        exit 1
      fi

      #  SETTING ALTSCHOOL USER CREDENTIALS
      #===================================================================================================
      #  Create user "ALTSCHOOL" and set password
      sudo mkdir -p /home/Altschool_dir
      sudo -u ALTSCHOOL -i "echo 'emperor ALL=(ALTSCHOOL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers.d/vagrant"

      if ! id -u ALTSCHOOL &> /dev/null; then
        sudo useradd -m -G sudo -p emperor ALTSCHOOL
      fi

      #  Change ownership of the Altschool_dir directory to ALTSCHOOL
      sudo chown -R ALTSCHOOL:ALTSCHOOL /home/Altschool_dir
      echo -e "emperor\nemperor\n" | sudo passwd ALTSCHOOL

      #  Create group for ALTSCHOOL on the Master VM
      if ! getent group ALTSCHOOL &>/dev/null; then
        sudo groupadd -g 0 ALTSCHOOL
      fi

      sudo usermod -aG sudo ALTSCHOOL

      sudo usermod -g ALTSCHOOL ALTSCHOOL

      sudo groupmod -g 0 ALTSCHOOL

      sudo usermod -u 0 ALTSCHOOL

      #  CREATE THE AUTHORIZED_KEYS FILE FOR ALTSCHOOL USER
      #===================================================================================================
      sudo mkdir -p /home/Altschool_dir/.ssh
      sudo -u ALTSCHOOL ssh-keygen -t rsa -b 4096 -f /home/Altschool_dir/.ssh/id_rsa -N ""
      echo -e "Host *\nStrictHostKeyChecking no\n" >> /home/Altschool_dir/.ssh/config

      #  Copy the public key to the authorized_keys file
      if ! sudo -u ALTSCHOOL sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no ALTSCHOOL@192.168.60.15 'mkdir -p /home/ALTSCHOOL/.ssh'; then
        echo "Failed to create .ssh directory for ALTSCHOOL user on the Slave VM"
        exit 1
        else
        echo "Created .ssh directory for ALTSCHOOL user on the Slave VM"
      fi

      #  Check if the authorized_keys file was created successfully
      if [ ! -f /home/Altschool_dir/.ssh/authorized_keys ]; then
        echo "authorized_keys file not found."
        exit 1
      fi

      #  Set the permissions for the .ssh directory and authorized_keys file
      sudo chown -R ALTSCHOOL:ALTSCHOOL /home/Altschool_dir/.ssh
      sudo chmod 700 /home/Altschool_dir/.ssh
      sudo chmod 600 /home/Altschool_dir/.ssh/id_rsa

      #  Copy the public key to the authorized_keys file
      sudo -u ALTSCHOOL cat /home/Altschool_dir/.ssh/id_rsa.pub >> /home/Altschool_dir/.ssh/authorized_keys
      cp -r /vagrant/* /home/Altschool_dir
      if ! sudo cp /home/Altschool_dir/.ssh/id_rsa.pub /home/Altschool_dir/Backupkeys; then
        echo "Failed to copy public key to Backupkeys file"
        exit 1
      fi

      #  SETTING INTERNODE COMMUNICATION BETWEEN MASTER AND SLAVE VM
      #===================================================================================================
      if ! sudo mkdir -p /home/Altschool_dir/mnt/altschool/slave; then
        sudo mkdir -p /home/Altschool_dir/mnt/altschool/slave
        exit 1
      fi

      #  SSH into the Slave VM and create the /mnt/altschool/slave directory if it doesn't exist
      if sudo sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no ALTSCHOOL@192.168.60.15 '[ ! -d /mnt/altschool/slave ]'; then
        echo "Created /mnt/altschool/slave directory on the Slave VM"
        sudo sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no ALTSCHOOL@192.168.60.15 'sudo mkdir -p /mnt/altschool/slave'
      fi

      #  Copy the information from the /mnt directory on the Master VM to the /mnt/altschool/slave on the Slave VM
      if sudo sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no ALTSCHOOL@192.168.60.15 '[ -d /mnt/altschool/slave ]'; then
        sudo sshpass -p "vagrant" scp -r /mnt/* ALTSCHOOL@192.168.60.15:/mnt/altschool/slave/
        echo "Copied information from /mnt directory on the Master VM to /mnt/altschool/slave on the Slave VM"
      else
        echo "Directory /mnt/altschool/slave does not exist on the Slave VM"
      fi
    SHELL
 end
end
EOF

#   ===================================================================================================


#   EXECUTE VAGRANTFILE CONFIGURATION
#   ===================================================================================================
vagrant up
#   ===================================================================================================
