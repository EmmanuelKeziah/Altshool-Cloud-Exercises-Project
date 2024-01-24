# Terraform Mini Project
# This file contains the variables that will be used in the main.tf file
# Description: This file contains the variables used to configure the VPC module.

# Declare ami variable for the VPC module
variable "ami" {
  description = "AMI for the EC2 instance"
  default    = "ami-06dd92ecc74fdfb36"
  type        = string
}

# Declare the instance variable to define the type of instance
variable "instance_type" {
  description = "Defines the type of the instance"
  default = "t2.micro"
  type = string
  
}
# Assign a region to the given variable
variable "region" {
  description = "AWS region"
  type        = string
}

#Assign a name/title to the project
variable "project_name" {
    description = "Name or title of the project"
    type        = string
}

variable "lb_name" {
  description = "Name of Load Balancer"
  type = string
}

#Assign a CIDR block to the VPC
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

# Declare a CIDR block 
variable "public_subnet_cidr_block_1"{ 
  description = "first public subnet for the VPC"
  type = string
}

variable "public_subnet_cidr_block_2"{ 
 description = "second public subnet for the VPC"
  type = string
}

variable "key_pair" {
  default = "project_key"
  description = "key pair required to ssh into the EC2 instance"
}

variable "private_key_path" {
  default =  "/home/vagrant/TERRAFORM_MINI_PROJECT/modules/alb/miniproject.pem"
  description = "path to the private key"
}

variable "public_key_path" {
  default = "/home/vagrant/TERRAFORM_MINI_PROJECT/modules/alb/mini_project.pub"
  description = "Path to the public key"
}

variable "AZ1" {
  description = "The availability zone where the subnet will be created"
  type = string
  default = "eu-central-1a"
}

variable "AZ2" {
  description = "The availability zone where the subnet will be created"
  type = string
  default = "eu-central-1b"
}

variable "domain_name" {
  default = "kc-crest.com.ng"
  description = "domain name"
  type = string
}