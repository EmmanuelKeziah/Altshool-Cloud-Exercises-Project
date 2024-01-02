# Description: This file contains the variables used to configure the VPC module.

#Assign a name/title to the region
variable "region" { 
  description = "AWS region"
  type        = string
}

#Assign a name/title to the project
variable "project" {
    description = "Name or title of the project"
    type        = string
}
#Assign a CIDR block to the VPC
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}


################################
variable "public_subnet_cidr_block_AZ_1"{ 
  description = "first public subnet for the VPC"
  type = string
}

variable "public_subnet_cidr_block_AZ_2"{ 
 description = "second public subnet for the VPC"
  type = string
}

variable "private_subnet_cidr_block_AZ_1"{ 
  description = "first private subnet for the VPC"
  type = string
}

variable "private_subnet_cidr_block_AZ_2"{ 
  description = "second private subnet for the VPC"
  type = string
}


variable "private_data_subnet_az_1"{ 
  description = "first private data subnet for the VPC"
  type = string
}

variable "private_data_subnet_az_2"{ 
description = "second private data subnet for the VPC"
  type = string
}

variable "ami" {
  description = "AMI for the EC2 instance"
  
}

variable "instance_type" {
  description = "instance type for the EC2 instance"
  default = "t2.micro"
}

variable "key_pair" {
  description = "key pair required to ssh into the EC2 instance"
}
