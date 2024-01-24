# Description: This script sets up the necessary infrastructure components such as VPC, subnets, and EC2 instance.

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# Provider Configuration: The "provider" block configures AWS as the cloud provider authenticator.
provider "aws" {
  region = var.region
}

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# VPC Module Configuration: The "module" block configures the VPC module to be used in the deployment.

# Create the module to start up the VPC.
module "vpc" {
  source                          = "../modules/vpc"

  region                          = var.region
  
  project                         = var.project

  vpc_cidr_block                  = var.vpc_cidr_block

  public_subnet_cidr_block_AZ_1   = var.public_subnet_cidr_block_AZ_1

  public_subnet_cidr_block_AZ_2   = var.public_subnet_cidr_block_AZ_2

  private_subnet_cidr_block_AZ_1  = var.private_subnet_cidr_block_AZ_1

  private_subnet_cidr_block_AZ_2  = var.private_subnet_cidr_block_AZ_2

  private_data_subnet_az_1        = var.private_data_subnet_az_1

  private_data_subnet_az_2        = var.private_data_subnet_az_2

  ami                             = var.ami

  instance_type                   = var.instance_type

  key_pair                        = var.key_pair
}