#Description: This is a simple reusable module that provides a simple interface to reproduce the behavior of the current implementation of the module. To use this module, you need to fill in the following functions
variable "region" { }

variable "project" { }

variable "vpc_cidr_block" { }

variable "public_subnet_cidr_block_AZ_1" { }

variable "public_subnet_cidr_block_AZ_2" { }

variable "private_subnet_cidr_block_AZ_1"{ }

variable "private_subnet_cidr_block_AZ_2"{ }

variable "private_data_subnet_az_1" { }

variable "private_data_subnet_az_2" { }

variable "ami" { }

variable "instance_type" { }

variable "key_pair" { }