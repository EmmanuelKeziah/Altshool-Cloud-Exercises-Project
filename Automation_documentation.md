# Description: This markdown file gives a detailed information/documentation of the steps and procedures used in the development of the master and slave virtual machines along with their configurations.This is the first markdown file.

# 1. Folder Creation: 
A folder called Cloud_Exercises is created in the home directory using the command `mkdir Cloud_Exercises`. A subfolder called Master_Slave is then created using the command `mkdir Master_Slave`.


# 2. Bashscript Creation:
A Bash script called `Vagrant_automation.sh` is created in the current directory `~/Cloud_Exercises/Master_Slave/` directory using the command `touch Vagrant_automation.sh`.


# 3.Bashscript Permissions:
The `Vagrant_automation.sh` script is given execute permissions using `chmod +x Vagrant_automation.sh` and executed using `./Vagrant_automation.sh` to initiate the deployment process.


# 4. Vagrantfile Creation:
The Vagrantfile is created in the current directory `~/Cloud_Exercises/Master_Slave/` using the command `vagrant init ubuntu/focal64`. The Vagrantfile is then configured using the `Vagrant_automation.sh` script.
- Using the command `vagrant up` will start the virtual machine and set all the provisions in it to be executed.

# 5. Commands For Automating Deployment Process of Both Master and Slave Virtual Machine:
- `#!/bin/bash`: This command (also called `shebang`) specifies the interpreter to be used for the Bash script. Without this command, the Bash script will not be executed.

- `error_message()`: This command defines a function called error_message which is used to display the first argument passed to it as an error message and exit the script with an exit status of 1.

- `vagrant init ubuntu/focal64 || error_message "Failed to initialize vagrant"`: This code initializes the Vagrantfile with the Ubuntu 20.04 (Focal Fossa 64-bit box). The `vagrant init` command creates a Vagrantfile in the current directory and this in turn configures the Vagrant environment. `ubuntu/focal64` specifies the name of the virtual box to be installed and the `||` is an operator used to execute the error_message function if the previous command fails to execute.

- `[ -f Vagrantfile ] || error_message "Error: Failed to create Vagrantfile."`: This line of code checks if the Vagrantfile was created successfully before continuing with the script. If the Vagrantfile was not created successfully, then the error_message function will be executed. The `-f` option is used to check if the Vagrantfile exists. The `||` is an operator used to execute the error_message function if the previous command fails to execute.

- `cat <<EOF > Vagrantfile`: The `<<` is a redirection operator used to redirect the contents of the Vagrantfile to the terminal. The `EOF` is a delimiter used to specify the start and end of the inline script. The `>` is a redirection operator used to redirect the contents of the inline script to the Vagrantfile. 

- `Vagrant.configure("2") do |config|`: This line of code prepares the Vagrantfile for configuration. The `2` specifies the version of the Vagrantfile to be configured. The `do` and `|` are delimiters used to specify the start and end of the Vagrantfile configuration. The `config` is a variable used to store the Vagrantfile configuration. It is within this block that all the Vagrantfile configurations are written.


# 6. Commands For Automating Deployment Process of Slave Virtual Machine:
- `config.vm.define "slave" do |slave|`: This line of code defines the configuration of the slave node. The `slave` is a variable used to store the configuration of the slave node. It is within this block that all the configurations of the slave node are written.

- `slave.vm.provider "virtualbox" do |vb|`: This line of code configures the VirtualBox provider. The `vb` is a variable used to store the VirtualBox provider configuration. It is within this block that all the VirtualBox provider configurations for the slave machine are written.

- `vb.memory = "1024"`: This line of code sets the memory/RAM size of the slave node to 1024MB.

- `vb.cpus = "1"`: This line of code sets the number of CPUs of the slave node to 1.

- `slave.vm.box = "ubuntu/focal64"`: This line of code specifies the name of the box to be installed on the slave node. Other boxes such as "ubuntu/bionic64" and "ubuntu/xenial64" can also be used.

- `slave.vm.hostname = "slave"`: This line of code sets the hostname of the slave node to "slave". The hostname is used to identify the slave node on the network.

- `slave.vm.network "private_network", type: "static", ip: "192.168.33.31"`: This line of code sets the network configuration of the slave node to a private network with a static IP address of `192.168.33.31`. This will allow the slave node to communicate with the master node via the private network.


# 7. Network Configurations and Forwaded Ports for The Slave Machine:
- `slave.vm.network "forwarded_port", guest: 22, host: 2247, id: "ssh"`: This line of code sets the network configuration  and forwarded ports within the guest machine based on the different service required to run on the slave machine. The `guest` is a variable used to store the guest port of the slave machine. The `host` is a variable used to store the host port of the slave machine. The `id` is a variable used to store the identity of the slave machine. The `ssh` is a variable used to store the SSH service of the slave machine.

- `slave.vm.network "forwarded_port", guest: 3306, host: 3306, id: "mysql"`: This  line of code sets the `guest` port of the slave machine, `host` port and `identity` to `3306`, `3306` and `mysql` respectively. This will allow the slave machine to connect to the master machine via MySQL.

- `slave.vm.network "forwarded_port", guest: 80, host: 8080, id: "apache"`: This line of code sets the `guest` port of the slave machine, `host` port and `identity` to `80`, `8080` and `apache` respectively. This will allow the slave machine to connect to the master machine via Apache HTTP Server.

- `slave.vm.network "forwarded_port", guest: 443, host: 8443`: This line of code sets the `guest` port, `host` port and `id` of the slave machine to `443` and `8443` and `https` respectively. `https` is the secure form of the hypertext transfer protocol (http) and is used to connect to the slave machine via the Apache HTTP Server.


# 8. Updating, Upgrading and Installing Packages on the Slave Machine: 
To update, upgrade and install packages on the slave machine, the following conditional statements are required:
-`slave.vm.provision "shell", inline: <<-SHELL`: This line of code prepares the slave machine for shell provisioning. The `<<` is a redirection operator used to redirect the contents of the inline script to the terminal. The `SHELL` is a delimiter used to specify the start and end of the inline script. The `inline` is a variable used to store the inline script. It is within this block that all the inline script configurations for the slave machine are written.

- `if ! dpkg -l | grep -q openssh-server; then`: This line of code checks if the openssh-server package is installed on the slave machine. The openssh-server package is used to enable SSH access to the slave machine. If the openssh-server package is 
not installed on the slave machine, then the error_message function will be executed.

- `dpkg -l` is used to list all installed packages on the slave machine. The `|` is a pipe operator used to pipe the results of the `dpkg -l` command to the `grep` command. The `grep` command is used to search for the "openssh-server" package in the results of the `dpkg -l` command. The `!` is a negation operator used to negate the results of the `grep` command. The `q` is an option used to suppress the output of the `grep` command. The `then` is a delimiter used to specify the start of the conditional statement. The `error_message` is a function used to display the first argument passed to it as an error message and exit the script with an exit status of 1.
- The `fi` is a delimiter used to specify the end of the conditional statement.

The existing packages are first updated to ensure that all new packages correspond with the existing packages. Then, the packages are installed if they do not already exist, otherwise, the script continues to the next command.
- Other packages such as sshpass, avahi-daemon and libnss-mdns are also installed using the same conditional statement.


# 9. Password Authentication on the Slave Machine:
- `sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config`: This line of code enables password authentication on the slave machine with sudo access. The `sed` command does a search and replace on the `/etc/ssh/sshd_config` file. The `s` is an option used to specify the search and replace operation. The `PasswordAuthentication no` is the search string. The `PasswordAuthentication yes` is the replace string. The `/etc/ssh/sshd_config` is the file to be searched and replaced. The `sudo` is a command used to run the `sed` command with sudo access.

- `sudo systemctl restart sshd || error_message "Failed to restart sshd service."`: This line of code restarts the sshd service on the slave machine and pipes or sends an error message to the error_message function if the previous command fails.


# 10. Closing SHELL Block:
- The `SHELL` and `end` command is used as a delimiter to specify the end of the inline script.


# 11. Commands For Automating Deployment Process of Master Virtual Machine:
- The master machine is defined using the command `config.vm.define "master" do |master|`. The virtualbox and network configurations are defined as the slave machine with the following exceptions:
- The use of `master` instead of `slave` in the code. This is to specify the master machine.
- The IP address of the master machine is different from that of the slave machine. This is to ensure that the master machine and slave machine are on different networks.
- The forwarded ports of the master machine are different from that of the slave machine. This is to ensure that the ports of the master machine do not conflict with that of the slave machine.


# 12. Updating and Installing Packages on the Master Machine:
- The same conditional statements used for the slave machine are repeated to update, upgrade and install packages on the master machine. Also, the same packages installed on the slave machine are installed on the master machine. 


# 13. Enabling Password Authentication on the Master Machine:
- The  sshpass package is installed on the master machine to enable password authentication  from the master machine to the slave machine. This is done using the command `sudo apt install sshpass -y`.


# 14. Creating a User on the Master Machine:
-To create a user named "Altschool" on the master machine, the following commands are used:
- `sudo mkdir -p /home/Alt`: This line of  code creates a directory named "Alt" in the `/home directory` with sudo access. The `-p` option is used to create the `/home/Alt` directory and the `/home` directory if they do not already exist.


# 15. Granting the Altschool User Root (Superuser) Privileges to the Altschool User on the Master Machine:
- The following commands is used to grant the Altschool user root (superuser) privileges:
-`sudo -u Altschool -i`: This line of code switches to the Altschool user with sudo access. the `-u` option is used to specify the user to switch to and the `-i` option is used to simulate an initial login. The results are stored in the /home/Alt directory.

- `echo "vagrant ALL=(Altschool) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/vagrant`: This line of code adds the vagrant user `Altschool` to the sudoers file. This is to enable the vagrant user to run commands with sudo access as the Altschool user without requiring a password. The `echo` command print the string "vagrant ALL=(Altschool) NOPASSWD: ALL" to the terminal, and the `|` is a pipe operator used to pipe the results of the `echo` command to the `tee` command. The `tee` command is used to read from standard input and write to standard output and files. The `-a` option is used to append the results of the `echo` command to the `/etc/sudoers.d/vagrant` file. The `sudo` command is used to run the `tee` command with sudo access.

- `if ! id -u Altschool &>/dev/null; then`: This if block checks if the `Altschool` user exists. If the Altschool user does not exist, then it will be created using the `sudo useradd -m -G sudo -p password Altschool` command. The -`m` option is used to create a home directory for the Altschool user. The `-G` option is used to add the Altschool user to the sudo group while the `-p` option sets the password of the Altschool user to "password".


# 16. Setting Ownership and File Permissions For Altschool User on The Master Machine:
The following commands is used to set the ownership and permissions of the` /home/Alt` directory: 
- `sudo chown -R Altschool:Altschool /home/Alt`: This line of code changes the ownership of the ` /home/Alt` directory to be the same as the Altschool user, the `-R` option is used to set the ownership of the ` /home/Alt` directory to the Altschool user.

- `echo -e "king\nking\n" | sudo passwd Altschool`: This line of code sets the password of the Altschool user to "king" and then confirms the password. This allows the user to login to the Altschool user automatically with the password "king" without having to enter the password twice.

# 17. Creating a Group For the Altschool User on the Master Machine:
- `if ! getent group Altschool &>/dev/null; then`: This block of code checks if the Altschool group exists, if the Altschool group does not exist, then it will be created using the `sudo groupadd -g 0 Altschool` command. The "-g" option is used to set the group ID of the Altschool group to 0. The `&>` option is used to set the output of the `getent group Altschool` command to null and the `then` is a delimiter used to specify the start of the conditional statement. 

- `sudo usermod -aG sudo Altschool`: This line of code adds the Altschool user to the sudo group.

- `sudo usermod -g Altschool Altschool`: This line of code sets the primary group of the Altschool user to the Altschool group.

- `sudo groupmod -g 0 Altschool`: This line of code sets the group ID of the Altschool group to 0. The group ID of the Altschool group is set to 0 to ensure that the Altschool group has root (superuser) privileges to run certain commands.

- `sudo usermod -u 0 Altschool`: This code sets the user ID of the Altschool user to 0. This is done to ensure that the Altschool group has root (superuser) privileges.


# 18. Setting SSH Key Based Authentication To Allow Seamless Authentication From The Master Machine to The Slave Machine:
- The following commands are used to enable SSH key based authentication:
- `sudo mkdir -p /home/Alt/.ssh`: This line of code creates a directory named `.ssh` in the `/home/Alt` directory with sudo access.

- `sudo -u Altschool ssh-keygen -t rsa -b 4096 -f /home/Alt/.ssh/id_rsa -N ""`: This code generates an SSH key pair for the Altschool user. The "-t" option is used to specify the type of key to be generated (in this case it is rsa key). The "-b" option is used to specify the number of bits in the key to be generated. The "-f" option is used to specify the filename of the key file. The "-N" option is used to specify the passphrase of the key file(in this case it is an empty string indicating no passphrase). The sshkeygen will generate a public key and a private key. The public key will be stored in the /home/Alt/.ssh/id_rsa.pub file and the private key will be stored in the /home/Alt/.ssh/id_rsa file. The private key will be used to authenticate the Altschool user to the slave machine while the public key will be used to authenticate the Altschool user to the master machine.


# 19. Disabling Host Key Checking For All Hosts on the Master Machine: 
- `echo -e "Host *\n StrictHostKeyChecking no\n" >> /home/Alt/.ssh/config`: This line of code disables host checking on the master machine by configuring the /home/Alt/.ssh/config file . The reason for this is to prevent the Altschool user from being prompted to confirm the authenticity of the host when connecting to the slave machine via SSH. This is because the Altschool user will be connecting to the slave machine via SSH using the private key generated in the previous command and not the password. The results are stored in the /home/Alt/.ssh/config file.

- `if ! sudo -u Altschool sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@192.168.33.31 exit; then`: This code block checks if the `Altschool` user can SSH into the slave machine using the password "vagrant". If the `Altschool` user cannot SSH into the slave machine using the password "vagrant", then the error_message function will be executed. The `sshpass` command is used to provide the password "vagrant" to the `ssh` command. The `StrictHostKeyChecking=no` parameter disables host checking on the slave machine. The `vagrant@192.168.33.31"
parameter specifies the user and IP address of the slave machine. The `exit` parameter is used to exit the SSH session.

- `if ! command -v sshpass &> /dev/null; then`: This line of  code checks if the sshpass package is installed on the master machine. If the sshpass package is not installed on the master machine, then the error_message function will be executed.

- `if ! ssh -o BatchMode=yes -o ConnectTimeout=5 vagrant@192.168.33.31 exit &>/dev/null; then`: This code checks if the Altschool user can SSH into the slave machine using the private key generated in the previous command. If the Altschool user cannot SSH into the slave machine using the private key generated in the previous command, then the error_message function will be executed. The `BatchMode=yes -o` parameter specifies whether to use batch mode, the batch mode is used to prevent the Altschool user from being prompted to enter a password when connecting to the slave machine via SSH. The `ConnectTimeout=5` parameter specifies the timeout interval for connecting to the slave machine.


# 20. Changing Permissions For `.ssh` Directory:
- The `sudo chmod 700` command is used to change the permissions of the `/home/Alt/.ssh` directory to 700. The `sudo chmod 600` command is used to change the permissions of the private key file in the `/home/Alt/.ssh/id_rsa` file to 600. The `sudo -u Altschool cat /home/Alt/.ssh/id_rsa.pub >> /home/Alt/.ssh/authorized_keys` command is used to append the contents of the `/home/Alt/.ssh/id_rsa.pub` file to the `/home/Alt/.ssh/authorized_keys` file. This is to enable the Altschool user to SSH into the slave machine using the private key generated in the previous command.

- `cp -r /vagrant/* /home/Alt/`: This line of code copies all the contents of the /vagrant directory to the `/home/Alt` directory so that the contents of the /vagrant directory can be accessed by the Altschool user.

- `if ! sudo cp /home/Alt/.ssh/id_rsa.pub /home/Alt/Backupkeys; then`: This line of code checks if the `/home/Alt/.ssh/id_rsa.pub` file exists. If the `/home/Alt/.ssh/id_rsa.pub` file does not exist, then the error_message function will be executed. But if it exists, the `/home/Alt/.ssh/id_rsa.pub` file is copied to the `/home/Alt/Backupkeys` directory. This is to backup the `/home/Alt/.ssh/id_rsa.pub` file.


# 21. Setting Internode Communication:
- The following commands are used to copy the contents of the `/mnt/altschool` directory from the master machine to the `/mnt/altschool/slave` directory on the slave machine:
- `if ! sudo mkdir -p /home/Alt/mnt/altschool/slave; then`: This code checks if the `/home/Alt/mnt/altschool/slave  ` directory exists. If the `/home/Alt/mnt/altschool/slave` directory does not exist, then it will be created using the `sudo mkdir -p /home/Alt/mnt/altschool/slave` command.

- `if ! mount | grep -q /mnt/altschool/slave; then`: This block of code checks if the `/mnt/altschool` directory is mounted on the `/mnt/altschool/slave` directory. If the `/mnt/altschool` directory is not mounted on the `/mnt/altschool/slave` directory, then the error_message function will be executed. The `mount` command is used to mount the `/mnt/altschool` directory on the `/mnt/altschool/slave` directory. The `grep` command is used to search for the `/mnt/altschool/slave` directory in the results of the `mount` command. The `q` option is used to suppress the output of the `grep` command.

-`if ! sudo -u Altschool sshpass -p "vagrant" mkdir -p /home/Alt/mnt/altschool/slave; then`: This code block checks if the user `Altschool` can access the specified `/mnt` directory on the slave machine. If the user `Altschool` cannot access the specified `/mnt` directory on the slave machine, then the error_message function will be executed. The `sshpass` command is used to provide the password "vagrant" to the `mkdir` command. The `mkdir` command is used to create the `/home/Alt/mnt/altschool/slave` directory on the slave machine. The `sudo` command is used to run the `mkdir` command with sudo access.

- `if ! sudo -u Altschool sshpass  -p "vagrant" scp -r /home/Alt/mnt/* vagrant@192.168.33.31:/home/Alt/mnt; then`: The command will copy the contents of the `/home/Alt/mnt` directory to the `/home/Alt/mnt/altschool/slave` directory on the slave machine.
   
  
# 22. Process Monitoring:
- On the slave machine, the following commands are used to display an overview of the Linux process management showcasing currently running processes:
- `if ! sudo ps aux > /home/vagrant/running_processes; then`: This block of code checks if the `/home/vagrant/running_processes` file exists. If the `/home/vagrant/running_processes` file does not exist, then the error_message function will be executed. The `sudo ps aux` command is used to display an overview of the Linux process management showcasing currently running processes. The results are stored in the `/home/vagrant/running_processes` file.

  
# 23. LAMP Installation:
The script to enable AMPSTACK deployment is located in a seperate file called `lamp_installation.sh`. At the bottom of the `Vagrant_automation.sh` script, the command `sudo bash /vagrant/lamp_installation.sh` is used to run the `lamp_installation.sh` script with sudo access. The `lamp_installation.sh` script is located in the `/vagrant` directory. The `lamp_installation.sh` script is used to install a LAMP (Linux, Apache, MySQL, PHP) stack on both the master and slave machines. 

# 24. SHELL Block:
- The `SHELL` and `end` command is used as a delimiter to specify the end of the inline script.

# 25. Documentation for the LAMPSTACK deployment:
The documentation for the LAMP installation is available in a `lampstack.md` file in the same directory as the `Vagrant_automation.sh` script.

## SUMMARY:
- This script explains each line of code written in the `Vagrant_automation.sh` script. It also explains the commands used to automate the deployment process of the master and slave machines. The `Vagrant_automation.sh` script is used to automate the deployment process of the master and slave machines. The `lamp_installation.sh` script is used to install a LAMP (Linux, Apache, MySQL, PHP) stack on both the master and slave machines. The documentation for the LAMP installation is available in a `lampstack.md` file in the same directory as the `Vagrant_automation.sh` script.
