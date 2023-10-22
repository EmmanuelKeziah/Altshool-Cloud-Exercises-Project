# TITLE: Automated Deployment of Laravel with PostgreSQL on Two Virtual Machines with GitHub Cloning and Cron Job Integration.

# Author: EMMANUEL KEZIAH

# Date Created: 21-Oct-2023

# TABLE OF CONTENTS
# 1. Introduction
+ Purpose of Documentation
+ Prerequisites

# 2. Installation
+ Installing VirtualBox 
+ Installing Vagrant
+ Creating Vagrant Deployment
+ Installing Laravel
+ Installing PostgreSQL
+ Installing LAMPstack

# 3. Configuration
+ Defining virtual machines
+ Setting up network configurations
+ Starting Virtual Machines

# 4. Provisioning Scripts
+ Master Virtual Machine:
    + Deploying LAMPstack
    + Installing MySQL
    + Configuring Apache Server
    + Installing PostgreSQL
    + Installing Laravel
    + Installing Composer
    + Installing Git
    + Cloning GitHub Repository
    + Creating Cron Job

+ Slave Virtual Machine:
    + Deploying LAMPstack
    + Installing MySQL
    + Configuring Apache Server
    + Installing PostgreSQL
    + Installing Laravel
    + Installing Composer
    + Installing Git
    + Cloning GitHub Repository
    + Creating Cron Job

# 5. Vagrant Commands
+ `vagrant up`
+ `vagrant halt`
+ `vagrant destroy`
+ `vagrant ssh`
+ `vagrant provision`

# 6. Accessing Virtual Machines
+ Connecting to a virtual machine via SSH
+ Obtaining the IP address of a virtual machine
+ Accessing the virtual machine via web browser

# 7. Additional Configurations
+ Configuring the firewall rules
+ Customizing server settings

# 8. Testing the Environment
+ Verifying web server access
+ Running Sample Applications

# 9. Troubleshooting
+ Common Errors
+ Debugging

# 10. Conclusion
+ Summary
+ References




