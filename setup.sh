#!/bin/bash


# Initialize Vagrant
if ! vagrant init ubuntu/focal64; then
    echo "Failed to initialize Vagrant."
    exit 1
fi

# Check if Vagrantfile was created successfully
if [ ! -f Vagrantfile ]; then
    echo "Vagrantfile not found."
    exit 1
fi

# Add the slave provisioning script to the Vagrantfile
./provision_slave.sh

