Vagrant.configure("2") do |config|
  # Set up slave VM
  config.vm.define "slave" do |slave|
     slave.vm.provider "virtualbox" do |virtualbox|
          virtualbox.memory = "1024"
          virtualbox.cpus = "1"
        end

        # Define the box and hostname for the slave VM
        slave.vm.box = "ubuntu/focal64" 
        slave.vm.hostname = "SLAVE"

        # Define the IP address for the slave VM
        slave.vm.network "private_network", type: "static", ip: "192.168.60.10"

        slave.vm.network "forwarded_port", guest: 22, host: 2250, id: "ssh"

        slave.vm.network "forwarded_port", guest: 3306, host: 3350, id: "mysql"

        slave.vm.network "forwarded_port", guest: 80, host: 8050, id: "apache"

        slave.vm.network "forwarded_port", guest: 443, host: 8450

        # Update, upgrade, and install packages on the Slave VM
        slave.vm.provision "shell", inline: <<-SHELL

            #Install openssh on the Slave VM
            if ! command -v sshd &> /dev/null; then
                sudo apt-get update -y
                sudo apt-get upgrade -y
                sudo apt-get install -y openssh-server
            fi

           #Install sshpass on the Slave VM
            if ! dpkg -l | grep -q "sshpass"; then
                sudo apt-get install -y sshpass
            fi

            #Install avahi on the Slave VM
            if ! dpkg -l | grep -q "avahi-daemon"; then
                sudo apt-get install -y avahi-daemon
            fi
            
            #Set password authentication on the Slave VM
            if sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config && sudo service ssh restart; then
                echo "Successfully set password authentication and restarted sshd service on the Slave VM"
            else
                echo "Failed to set Password authentication and restart sshd service on the Slave VM"
                exit 1
            fi

            #Create the /mnt/altschool/slave directory on the Slave VM
            if sudo mkdir -p /mnt/altschool/slave; then
                echo "Successfully created the /mnt/altschool/slave directory on the Slave VM"
            else
                echo "Failed to create the /mnt/altschool/slave directory on the Slave VM"
                exit 1
            fi

            #Set permissions for the /mnt/altschool/slave directory on the Slave VM
            if sudo chmod -R 777 /mnt/altschool/slave; then
                echo "Successfully set permissions for the /mnt/altschool/slave directory on the Slave VM"
            else
                echo "Failed to set permissions for the /mnt/altschool/slave directory on the Slave VM"
                exit 1
            fi
        SHELL
    end

    # Set up configurations for the master VM
    config.vm.define "master" do |master|
        master.vm.provider "virtualbox" do |virtualbox|
            virtualbox.memory = "1024"
            virtualbox.cpus = "1"
        end
        #Define the box and hostname for the master VM
        master.vm.box = "ubuntu/focal64"
        master.vm.hostname = "MASTER"
        
        #Define the IP address for the master VM
        master.vm.network "private_network", type: "static", ip: "192.168.60.11"

        master.vm.network "forwarded_port", guest: 22, host: 2249, id: "ssh"

        master.vm.network "forwarded_port", guest: 3306, host: 3349, id: "mysql"

        master.vm.network "forwarded_port", guest: 80, host: 8049, id: "apache"
        
        master.vm.network "forwarded_port", guest: 443, host: 8449

        # Update, upgrade, and install packages on the Master VM

       #Install packages on the Master VM
        master.vm.provision "shell", inline: <<-SHELL
            #Install openssh on the Master VM
            if ! command -v sshd &> /dev/null; then
                sudo apt-get update -y
                sudo apt-get upgrade -y
                sudo apt-get install -y openssh-server
            fi

            #Install sshpass on the Master VM
            if ! dpkg -l | grep -q "sshpass"; then
                sudo apt-get install -y sshpass
            fi

            #Install avahi on the Master VM
            if ! dpkg -l | grep -q "avahi-daemon"; then
                sudo apt-get install -y avahi-daemon
            fi

            if sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && sudo service ssh restart; then
                echo "Successfully set password authentication and restarted sshd service on the Master VM"
            else
                echo "Failed to set Password authentication and restart sshd service on the Master VM"
                exit 1
            fi

            #Create a user "ALTSCHOOL" and set password for the user on the Master VM

            sudo mkdir -p /home/Altschool_dir
            su - ALTSCHOOL -c "echo 'vagrant ALL=(ALTSCHOOL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers.d/vagrant"

            if ! id -u ALTSCHOOL &> /dev/null; then
                sudo useradd -m -G sudo -p emperor ALTSCHOOL
            fi

            sudo chown -R ALTSCHOOL:ALTSCHOOL /home/Altschool_dir
            echo -e "emperor\nemperor\n" | sudo passwd ALTSCHOOL

            #Create group for ALTSCHOOL user
            if ! getent group ALTSCHOOL &>/dev/null; then
              sudo groupadd -g 0 ALTSCHOOL
            fi

            sudo usermod -aG sudo ALTSCHOOL

            sudo usermod -g ALTSCHOOL ALTSCHOOL

            sudo groupmod -g 0 ALTSCHOOL

            sudo usermod -u 0 ALTSCHOOL

            #Create ssh keys for ALTSCHOOL user and add the keys to list of authorized keys
            if sudo mkdir -p /home/Altschool_dir/.ssh
            sudo -u ALTSCHOOL ssh-keygen -t rsa --b 4096 -f /home/Altschool_dir/.ssh/id_rsa -N "" 
            echo -e "Host *\n\tStrictHostKeyChecking no\n" > /home/Altschool_dir/.ssh/config

            #Copy the public key to the slave VM
            if sudo -u ALTSCHOOL sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@192.168.60.10 "mkdir -p /home/Altschool_dir/.ssh && echo  >> /home/Altschool_dir/.ssh/authorized_keys"; then
                echo "Successfully copied the public key to the slave VM"
            else
                echo "Failed to copy the public key to the slave VM"
                exit 1
            fi

            #Copy the publickey to remote server
            if sudo -u ALTSCHOOL sshpass -p "vagrant" ssh-copy-id -i /home/Altschool_dir/.ssh/id_rsa.pub vagrant@192.168.60.10; then
                echo "Successfully copied the public key to the slave VM"
            else
                echo "Failed to copy the public key to the slave VM"
                exit 1
            fi

            #Create the stored_keys backup file on the Master VM and copy the public key to the file
            if ! sudo cp /home/Altschool_dir/.ssh/id_rsa.pub /mnt/altschool/stored_keys; then
                echo "Failed to copy the public key to the stored_keys file"
                exit 1
            fi

            #Create directory /mnt/altschool/master on the Master VM
           if ! sudo mkdir -p /mnt/altschool/master; then
           sudo mkdir -p /mnt/altschool/master
           else
                echo "Successfully created the /mnt/altschool/master directory on the Master VM"
            fi

            #Set the permissions for the /mnt/altschool/master directory on the Master VM
           if ! sudo chmod 755 /mnt/altschool/master; then
                echo "Successfully set permissions for the /mnt/altschool/master directory on the Master VM"
            else
                echo "Failed to set permissions for the /mnt/altschool/master directory on the Master VM"
                exit 1
            fi

            #Copy files to /mnt/altschool/master on the Master VM
           if ! sudo cp /home/Altschool_dir/.ssh/id_rsa.pub /mnt/altschool/master; then
                echo "Successfully copied files to /mnt/altschool/master on the Master VM"
            else
                echo "Failed to copy files to /mnt/altschool/master on the Master VM"
                exit 1
            fi

            #Check if /mnt/altschool/master is mounted on /mnt/altschool/slave on the Slave VM
            if sudo -u ALTSCHOOL sshpass -p "vagrant" ssh vagrant@192.168.60.10 mount | grep -q /mnt/altschool/master; then
                echo "Successfully mounted /mnt/altschool/master on /mnt/altschool/slave on the Slave VM"
            else
                echo "Failed to mount /mnt/altschool/master on /mnt/altschool/slave on the Slave VM"
                exit 1
            fi
            
            #Save list of running processes to a file called running_processes on the Master VM
            if sudo ps aux > /home/vagrant/running_processes; then
                echo "Successfully saved list of running processes to a file called running_processes on the Master VM"
            else
                echo "Failed to save list of running processes to a file called running_processes on the Master VM"
                exit 1
            fi
        SHELL

        config.vm.provision "shell", inline: <<-SHELL
        source ./LAMP.sh
        SHELL
    end    
end
