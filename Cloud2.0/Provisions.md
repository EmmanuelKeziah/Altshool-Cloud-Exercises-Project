#  TITLE:  Automated Deployment of Master and Slave Machines Using Vagrant and VirtualBox.

# TABLE OF CONTENTS
# 1. Introduction
+ Purpose of Documentation
+ Prerequisites

# 2. Installation
+ Installing VirtualBox 
+ Installing Vagrant
+ Creating Vagrant Deployment

# 3. Configuration
+ Defining virtual machines
+ Declaring variables for the master and slave virtual machines
+ Setting up network configurations

# 4. Provisioning Scripts
+ Master Virtual Machine:
    + Installing necessary packages
    + Password authentication
    + Creating a user
    + Granting the user root (superuser) privileges
    + Setting ownership and file permissions
    + Creating a group
    + Creating authorized_keys file
    + Setting SSH key based authentication
    + Disabling host key checking for all hosts
    + Setting internode communication
    + Closing SHELL block

+ Slave Virtual Machine:
    + Installing necessary packages

# Deploying LAMP stack
+ Starting Virtual Machines

# 5. Vagrant Commands
    + `vagrant up`
    + `vagrant halt`
    + `vagrant destroy`
    + `vagrant ssh`
    + `vagrant provision`

# 6. Accessing Virtual Machines
    + Connecting to a virtual machine via SSH
    + Obtaining the IP address of a virtual machine
 
# 7. Additional Configurations

# 8. Conclusion
    + Summary

#========================================================================================================================================================================
# 1. Introduction:
## Purpose of Documentation:
This documentation gives a detailed information of the steps and procedures used in the development of the master and slave VM along with their configurations.

## Prerequisites:
- VirtualBox
- Vagrant
- Text Editor (Visual Studio Code, Sublime Text, Atom, etc.)

# 2. Installation:
## Installing VirtualBox:
- To install VirtualBox, the following steps are required:
- Go to the VirtualBox download page at https://www.virtualbox.org/wiki/Downloads.
- Download the VirtualBox installer for your operating system.
- Run the VirtualBox installer and follow the on-screen instructions to install VirtualBox.

## Installing Vagrant:
- To install Vagrant, the following steps are required:
- Go to the Vagrant download page at https://www.vagrantup.com/downloads.
- Download the Vagrant installer for your operating system.
- Run the Vagrant installer and follow the on-screen instructions to install Vagrant.

## Creating Vagrant Deployment script:
- To create a script that runs Vagrant , the following steps are required:
- Create a directory for the Vagrant deployment. This directory will contain the Vagrantfile and provisioning scripts.
- Create a Vagrantfile in the directory created in the previous step. The Vagrantfile is used to configure the Vagrant deployment.
- Configure the Vagrantfile to provision the master and slave virtual machines.
- Run the Vagrantfile.

# 3. Configuration:
## Defining virtual machines:
- To define the master and slave virtual machines, the following steps are required:
- Open the Vagrantfile created in the previous step.
- Define the master and slave virtual machines in the Vagrantfile.
- Configure the master and slave virtual machines to use the Ubuntu 20.04 (Focal Fossa 64-bit box).
- Configure the master and slave virtual machines to use 1024MB of RAM each or more.
- Configure the master and slave virtual machines to use 1 CPU each or more.

## Declaring variables for the master and slave virtual machines:
- To declare variables for the master and slave virtual machines, the following steps are required:
- Open the Vagrantfile created in the previous step.
- Declare variables for the master and slave virtual machines based on the different services required to run on the master and slave virtual machines.
- The variables declared for the master and slave virtual machines are as follows:
- `SLAVE_IP="192.168.60.15"`
- `MASTER_IP="192.168.60.11"`
- `SSH_PASSWORD="vagrant"`
- `ALTSCHOOL_PASSWORD="emperor"`
- `ALTSCHOOL_USER="ALTSCHOOL"`
- `ALTSCHOOL_GROUP="ALTSCHOOL"`
- `ALTSCHOOL_DIR="Altschool_dir"`
- `APACHE_PACKAGE="apache2"`
- `PHP_PACKAGES=("libapache2-mod-php" "php-mysql" "php-curl" "php-gd" "php-mbstring" "php-xml" "php-xmlrpc")`
- `MYSQL_PACKAGE="mysql-server"`
- `MYSQL_ROOT_PASSWORD="LAMP"`
- `WWW_DIR="/var/www"`
- `HTML_DIR="$WWW_DIR/html"`
- `PHPINFO_FILE="$HTML_DIR/phpinfo.php"`
These variables are used to store the IP addresses, passwords, usernames, group names, directory names and package names of the master and slave virtual machines. The variables are used to make the provisioning scripts more dynamic and reusable.

# 4. Provisioning Scripts:
## Master Virtual Machine:
### Installing necessary packages:
- To install necessary packages on the master virtual machine, the following steps are required:
- Open the Vagrantfile created in the previous step.
- Configure the Vagrantfile to install necessary packages on the master virtual machine using bashscripts or inline scripts.
- The following packages are installed on the master virtual machine:
- `openssh-server`: This package is used to enable SSH access to the master virtual machine.
- `sshpass`: This package is used to enable password authentication from the master virtual machine to the slave virtual machine.
- `avahi-daemon`: This package is used to enable zeroconf networking on the master virtual machine.
- `libnss-mdns`: This package is used to enable zeroconf networking on the master virtual machine.
- `apache2`: This package is used to install the Apache HTTP Server on the master virtual machine.
- `php7.4`: This package is used to install PHP 7.4 on the master virtual machine.
`- if ! command -v sshd &> /dev/null; then`: This command checks if the sshd service is installed on the master virtual machine. If the sshd service is not installed on the master virtual machine, then the packages in the then block are installed on the master virtual machine. The `command` is a command used to run the `sshd` command. The `-v` option is used to print a version of the `sshd` command. The `&>` is a redirection operator used to redirect the output of the `sshd` command to null. The `then` is a delimiter used to specify the start of the conditional statement. The openssh-server package is used to enable SSH access to the master virtual machine.

- `if ! command -v sshpass &> /dev/null; then`: This command checks if the sshpass package is installed on the master virtual machine. If the sshpass package is not installed on the master virtual machine, then the packages in the then block are installed on the master virtual machine.

- `if ! command -v avahi-daemon &> /dev/null; then`: This command checks if the avahi-daemon package is installed on the master virtual machine. If the avahi-daemon package is not installed on the master virtual machine, then the packages in the then block are installed on the master virtual machine.

### Password authentication:
- To enable password authentication on the master virtual machine, the following steps are required:
- Configure the Vagrantfile to enable password authentication on the master virtual machine.
- The following steps are required to enable password authentication on the master virtual machine:
- `sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config`: This command enables password authentication on the master virtual machine with sudo access. The `sed` command does a search and replace on the `/etc/ssh/sshd_config` file. The `s` is an option used to specify the search and replace operation. The `PasswordAuthentication no` is the search string. The `PasswordAuthentication yes` is the replace string. The `/etc/ssh/sshd_config` is the file to be searched and replaced. The `sudo` is a command used to run the `sed` command with sudo access.
- `sudo systemctl restart sshd || error_message "Failed to restart sshd service."`: This command restarts the sshd service on the master virtual machine and pipes or sends an error message to the error_message function if the previous command fails.

### Creating a user:
- To create a user named "ALTSCHOOL" on the master virtual machine, the following steps are required:
- Configure the Vagrantfile to create a user named "ALTSCHOOL" on the master virtual machine.
- The following steps are required to create a user named "ALTSCHOOL" on the master virtual machine:
- `sudo mkdir -p /home/Altschool_dir`: This command creates a directory named "Altschool_dir" in the `/home` directory with sudo access. The `-p` option is used to create the `/home/Altchool_dir` directory and the `/home` directory if they do not already exist.
- `sudo useradd -m -G sudo -p password ALTSCHOOL`: This command creates a user named "ALTSCHOOL" on the master virtual machine with sudo access. The `-m` option is used to create a home directory for the "ALTSCHOOL" user. The `-G` option is used to add the "ALTSCHOOL" user to the sudo group while the `-p` option sets the password of the "ALTSCHOOL" user to "password".
- `sudo mkdir -p /home/Altschool_dir/.ssh`: This command creates a directory named `.ssh` in the `/home/Alt` directory with sudo access.
- `sudo chown -R ALTSCHOOL:ALTSCHOOL /home/Altschool_dir`: This command changes the ownership of the `/home/Altschool_dir` directory to be the same as the "ALTSCHOOL" user, the `-R` option is used to set the ownership of the `/home/Altschool_dir` directory to the "ALTSCHOOL" user.
- `echo -e "$ALTSCHOOL_PASSWORD\n$ALTSCHOOL_PASSWORD\n" | sudo passwd ALTSCHOOL`: This command sets the password of the "ALTSCHOOL" user to "emperor" and then confirms the password. This allows the user to login to the "ALTSCHOOL" user automatically with the password "emperor" without having to enter the password twice.

### Granting the user root (superuser) privileges:
- To grant the "ALTSCHOOL" user root (superuser) privileges on the master virtual machine, the following steps are required:
- Configure the Vagrantfile to grant the "ALTSCHOOL" user root (superuser) privileges on the master virtual machine.
- The following steps are required to grant the "ALTSCHOOL" user root (superuser) privileges on the master virtual machine:
- `sudo -u ALTSCHOOL -i`: This command switches to the "ALTSCHOOL" user with sudo access. the `-u` option is used to specify the user to switch to and the `-i` option is used to simulate an initial login. The results are stored in the `/home/Altschool_dir` directory.

- `echo "$SSH_PASSWORD ALL=(ALTSCHOOL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/vagrant`: This command adds the vagrant user `ALTSCHOOL` to the sudoers file. This is to enable the vagrant user to run commands with sudo access as the "ALTSCHOOL" user without requiring a password. The `echo` command print the string "vagrant ALL=(ALTSCHOOL) NOPASSWD: ALL" to the terminal, and the `|` is a pipe operator used to pipe the results of the `echo` command to the `tee` command. The `tee` command is used to read from standard input and write to standard output and files. The `-a` option is used to append the results of the `echo` command to the `/etc/sudoers.d/vagrant` file. The `sudo` command is used to run the `tee` command with sudo access.

### Setting ownership and file permissions:
- To set the ownership and file permissions of the `/home/Altschool_dir` directory on the master virtual machine, the following steps are required:
- Open the Vagrantfile created in the previous step.
- Configure the Vagrantfile to set the ownership and file permissions of the `/home/Altschool_dir` directory on the master virtual machine.
- The following steps are required to set the ownership and file permissions of the `/home/Altschool_dir` directory on the master virtual machine:
- `sudo chown -R ALTSCHOOL:ALTSCHOOL /home/Altschool_dir`: This command changes the ownership of the `/home/Altschool_dir` directory to be the same as the "ALTSCHOOL" user, the `-R` option is used to set the ownership of the `/home/Altschool_dir` directory to the "ALTSCHOOL" user.
- `sudo chmod -R 777 /home/Altschool_dir`: This command changes the permissions of the `/home/Altschool_dir` directory to 777. The `sudo` command is used to run the `chmod` command with sudo access. The `-R` option is used to set the permissions of the `/home/Altschool_dir` directory to 777 granting the owner, group and others read, write and execute permissions.

### Creating a group:
- To create a group named "ALTSCHOOL" on the master virtual machine, the following steps are required:
- Configure the Vagrantfile to create a group named "ALTSCHOOL" on the master virtual machine.
- The following steps are required to create a group named "ALTSCHOOL" on the master virtual machine:
- `if ! getent group $ALTSCHOOL_GROUP &>/dev/null; then`: This command checks if the "ALTSCHOOL" group exists, if the `ALTSCHOOL` group does not exist, then it will be created using the `sudo groupadd -g 0 $ALTSCHOOL_GROUP` command. The "-g" option is used to set the group ID of the `$ALTSCHOOL_GROUP` to 0. The `&>` option is used to set the output of the `getent group $ALTSCHOOL_GROUP` command to null and the `then` is a delimiter used to specify the start of the conditional statement.

- `sudo usermod -aG sudo $ALTSCHOOL_USER`: This command adds the "ALTSCHOOL" user to the sudo group.  

###  Creating authorized_keys file
- To create an authorized_keys file on the master virtual machine, the following steps are required:
- Configure the Vagrantfile to create an authorized_keys file on the master virtual machine.
- The following steps are required to create an authorized_keys file on the master virtual machine:
- `sudo mkdir -p /home/Altschool_dir/.ssh`: This command creates a directory named `.ssh` in the `/home/Altschool_dir` directory with sudo access.
- `sudo touch /home/Altschool_dir/.ssh/authorized_keys`: This command creates an authorized_keys file in the `/home/Altschool_dir/.ssh` directory with sudo access.
- `sudo chown -R ALTSCHOOL:ALTSCHOOL /home/Altschool_dir/.ssh`: This command changes the ownership of the `/home/Altschool_dir/.ssh` directory to be the same as the "ALTSCHOOL" user, the `-R` option is used to set the ownership of the `/home/Altschool_dir/.ssh` directory to the "ALTSCHOOL" user.
- `sudo chmod -R 777 /home/Altschool_dir/.ssh`: This command changes the permissions of the `/home/Altschool_dir/.ssh` directory to 777. The `sudo` command is used to run the `chmod` command with sudo access. The `-R` option is used to set the permissions of the `/home/Altschool_dir/.ssh` directory to 777 granting the owner, group and others read, write and execute permissions.

### Setting SSH key based authentication:
- To set SSH key based authentication on the master virtual machine:
- Configure the Vagrantfile to set SSH key based authentication on the master virtual machine.
- The following steps are required to set SSH key based authentication on the master virtual machine:
- `sudo ssh-keygen -t rsa -N "" -f /home/Altschool_dir/.ssh/id_rsa`: This command generates an SSH key pair for the "ALTSCHOOL" user. The `-t` option is used to specify the type of key to be generated. The `rsa` is the type of key to be generated. The `-N` option is used to specify the passphrase of the key to be generated. The `""` is the passphrase of the key to be generated. The `-f` option is used to specify the filename of the key to be generated. The `/home/Altschool_dir/.ssh/id_rsa` is the filename of the key to be generated.

- `sudo cat /home/Altschool_dir/.ssh/id_rsa.pub >> /home/Altschool_dir/.ssh/authorized_keys`: This command adds the public key of the "ALTSCHOOL" user to the authorized_keys file. The `cat` command is used to concatenate the contents of the `/home/Altschool_dir/.ssh/id_rsa.pub` file to the `/home/Altschool_dir/.ssh/authorized_keys` file. The `>>` is a redirection operator used to redirect the contents of the `/home/Altschool_dir/.ssh/id_rsa.pub` file to the `/home/Altschool_dir/.ssh/authorized_keys` file.

- `sudo chmod 600 /home/Altschool_dir/.ssh/authorized_keys`: This command changes the permissions of the `/home/Altschool_dir/.ssh/authorized_keys` file to 600. The `sudo` command is used to run the `chmod` command with sudo access. The `600` is the permissions of the `/home/Altschool_dir/.ssh/authorized_keys` file.

- `sudo chown -R ALTSCHOOL:ALTSCHOOL /home/Altschool_dir/.ssh`: This command changes the ownership of the `/home/Altschool_dir/.ssh` directory to be the same as the "ALTSCHOOL" user, the `-R` option is used to set the ownership of the `/home/Altschool_dir/.ssh` directory to the "ALTSCHOOL" user.

### Disabling host key checking for all hosts:
- To disable host key checking for all hosts on the master virtual machine, the following steps are required:
- Configure the Vagrantfile to disable host key checking for all hosts on the master virtual machine.
- `sudo sed -i 's/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/' /etc/ssh/ssh_config`: This command disables host key checking for all hosts on the master virtual machine with sudo access. The `sed` command does a search and replace on the `/etc/ssh/ssh_config` file. The `s` is an option used to specify the search and replace operation. The `#   StrictHostKeyChecking ask` is the search string. The `StrictHostKeyChecking no` is the replace string. The `/etc/ssh/ssh_config` is the file to be searched and replaced. The `sudo` is a command used to run the `sed` command with sudo access.

### Closing SHELL block:
- The `SHELL` and `end` command is used as a delimiter to specify the end of the inline script.

## Slave Virtual Machine:
### Installing necessary packages:
-The same packages installed on the master virtual machine are also installed on the slave virtual machine. The packages are as follows:
- `openssh-server`
- `sshpass`
- `avahi-daemon`
- `libnss-mdns`

# Deploying LAMP stack:
- To deploy LAMP stack on the master and slave virtual machines, the following steps are required:
- Open the Vagrantfile created in the previous step.
- Configure the Vagrantfile to deploy LAMP stack on the master and slave virtual machines using bashscripts or inline scripts.
- The following steps are required to deploy LAMP stack on the master and slave virtual machines:
- `sudo apt-get update`: This command updates the package list on the master and slave virtual machines.
- `sudo apt-get install -y apache2`: This command installs the Apache HTTP Server on the master and slave virtual machines.
- `sudo systemctl restart apache2`: This command restarts the Apache HTTP Server on the master and slave virtual machines.
- `sudo systemctl enable apache2`: This command enables the Apache HTTP Server to start on boot on the master and slave virtual machines.
- `sudo systemctl status apache2`: This command checks the status of the Apache HTTP Server on the master and slave virtual machines.

# Installing PHP
- `sudo add-apt-repository ppa:ondrej/php`: This command adds the PHP repository to the master and slave virtual machines.
- `sudo apt-get install -y php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc`: This command installs the PHP modules required to run on the master and slave virtual machines.
- `sudo systemctl restart apache2`: This command restarts the Apache HTTP Server on the master and slave virtual machines.
- `sudo systemctl enable apache2`: This command enables the Apache HTTP Server to start on boot on the master and slave virtual machines.
- `sudo systemctl status apache2`: This command checks the status of the Apache HTTP Server on the master and slave virtual machines.
- `sudo apt-get install -y mysql-server`: This command installs MySQL on the master and slave virtual machines.
- `sudo apt-get install -y php-mysql`: This command installs the PHP MySQL module on the master and slave virtual machines.

## Starting Virtual Machines:
- To start the master and slave virtual machines, the following steps are required:
- Open the Vagrantfile created in the previous step.
- Run the Vagrantfile using the `vagrant up` command.
- Run `vagrant provision` to provision the master and slave virtual machines.

# 5. Vagrant Commands:
## `vagrant up`: 
- This command starts the master and slave virtual machines.
- To start the master and slave virtual machines, the following steps are required:
- Open the Vagrantfile created in the previous step.
- Run the Vagrantfile using the `vagrant up` command.

##  `vagrant up --provision`:
- This command provisions the master and slave virtual machines by running the provisioning scripts without destroying the master and slave virtual machines.

## `vagrant halt`:
- This command stops the master and slave virtual machines. To stop the master and slave virtual machines, the following steps are required:
- Open the Vagrantfile created in the previous step.
- Run the Vagrantfile using the `vagrant halt` command.

## `vagrant destroy`:
- This command destroys the master and slave virtual machines. To destroy the master and slave virtual machines, the following steps are required:
- Open the Vagrantfile created in the previous step.
- Run the Vagrantfile using the `vagrant destroy` command or `vagrant destroy -f` command to force the destruction of the master and slave virtual machines.

## `vagrant ssh`:
- This command connects to the master and slave virtual machines via SSH. To connect to the master and slave virtual machines via SSH, the following steps are required:
- Open the Vagrantfile created in the previous step.
- Activate the master and slave virtual machines using the `vagrant up` command.
- Run the Vagrantfile using the `vagrant ssh` command.

## `vagrant provision`:
- This command provisions the master and slave virtual machines. To provision the master and slave virtual machines, the following steps are required:
- Open the Vagrantfile created in the previous step.
- Run the Vagrantfile using the `vagrant provision` command.

# 6. Accessing Virtual Machines:
## Connecting to a virtual machine via SSH:
- To connect to a virtual machine via SSH, the following steps are required:
-Open the text editor of your choice.
- Run the Vagrantfile using the `vagrant up` command.
- Run the Vagrantfile using the `vagrant ssh` command followed by the name of the virtual machine to connect to the virtual machine via SSH.

## Obtaining the IP address of a virtual machine:
- To obtain the IP address of a virtual machine, the following steps are required:
- Open the text editor of your choice.
- Run the Vagrantfile using the `vagrant up` command.
- Run the `if config` command to obtain the IP address of the virtual machine.

# 7. Additional Configurations:
## Configuring the firewall rules:
- To configure the firewall rules on the master and slave virtual machines, the following steps are required:
- Configure the Vagrantfile to configure the firewall rules on the master and slave virtual machines using bashscripts or inline scripts.
- The following steps are required to configure the firewall rules on the master and slave virtual machines:
- `sudo ufw allow 22`: This command allows SSH access to the master and slave virtual machines.
- `sudo ufw allow 80`: This command allows HTTP access to the master and slave virtual machines.
- `sudo ufw allow 443`: This command allows HTTPS access to the master and slave virtual machines.
- `sudo ufw allow 3306`: This command allows MySQL access to the master and slave virtual machines. 
- `sudo ufw allow 8080`: This command allows HTTP access to the master and slave virtual machines.
- `sudo ufw allow 8443`: This command allows HTTPS access to the master and slave virtual machines.
- `sudo ufw allow 3352`: This command allows MySQL access to the master and slave virtual machines.
- `sudo ufw allow 2251`: This command allows SSH access to the master and slave virtual machines.
Other configurations such as validating the firewall rules and enabling the firewall rules are also done using the same conditional statement.

#8 Conclusion:
## Summary:
- This documentation gives a detailed information of the steps and procedures used in the development of the master and slave VM along with their configurations.