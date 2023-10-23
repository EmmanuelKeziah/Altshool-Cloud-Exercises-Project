#!/bin/bash

#===================================================================================================
# Program: VIRTUAL MACHINES INITIALIZATION SCRIPT
# Author: Emmanuel Keziah
# Date: 21-10-2023
#===================================================================================================

#   VAGRANT INITIALIZATION
#   ===================================================================================================  
if ! vagrant init ubuntu/focal64; then
    echo "Failed to initialize Vagrant."
    exit 1
fi


# Check if Vagrantfile was created successfully
if [ ! -f Vagrantfile ]; then
    echo "Vagrantfile not found."
    exit 1
fi
#   ===================================================================================================


#   VAGRANTFILE CONFIGURATIONS FOR MASTER AND SLAVE
#   ===================================================================================================
cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|

    config.vm.define "Slave" do |slave|
        slave.vm.box = "ubuntu/focal64"
        slave.vm.hostname = "SlaveBox"

        # Customize the amount of memory on the VM:
        slave.vm.provider "virtualbox" do |virtualbox|
        virtualbox.memory = "1024"
        virtualbox.cpus = "1"
        end

        # Create a private network, which allows host-only access to the machine using a specific IP.
        slave.vm.network "private_network", ip: "192.168.12.12"

        slave.vm.provision "shell", inline: <<-SHELL
            #Update package list
            echo "Checking for updates"
            if sudo apt-get update -y; then
                echo "Package list updated successfully"
            else
                echo "ERROR: Failed to update package list"
            exit 1
            fi

            # Upgrade packages
            echo "Upgrading packages"
            sudo apt-get upgrade -y || exit 1

            # Installing avahi-daemon
            sudo apt-get install -y avahi-daemon libnss-mdns || exit 1
      SHELL
  end
    

    config.vm.define "Master" do |master|
        master.vm.box = "ubuntu/focal64"
        master.vm.hostname = "MasterBox"

       # Customize the amount of memory on the VM:
        master.vm.provider "virtualbox" do |virtualbox|
        virtualbox.memory = "1024"
        virtualbox.cpus = "1" 
        end

        # Create a private network, which allows host-only access to the machine using a specific IP.
        master.vm.network "private_network", ip: "192.168.13.14"

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

            # Installing avahi-daemon
            sudo apt-get install -y avahi-daemon libnss-mdns || exit 1
        SHELL
   end
end
EOF
#   ===================================================================================================


#   EXECUTE VAGRANTFILE CONFIGURATION
#   ===================================================================================================
vagrant up
#   ===================================================================================================

vagrant scp /lampstack_Installation.sh vagrant:/home/vagrant