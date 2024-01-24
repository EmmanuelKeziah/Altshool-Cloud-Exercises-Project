#!/bin/bash

# Load environment variables from the .env file
source .env

# Run the playbook command
ansible-playbook  site.yaml