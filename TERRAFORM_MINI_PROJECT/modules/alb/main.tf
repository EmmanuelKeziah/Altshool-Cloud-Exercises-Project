# Set up the required providers for AWS
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 5.0.0"
        }
    }
}


# Set up the AWS provider and specify the region.
provider "aws" {
    region = var.region  
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Create Internet gateway and attach it to VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.project_name}-igw"
    }
}

#Use data to pull availability zone information for the current region from aws.
data "aws_availability_zones" "available_zones" { }

#Create public subnet 1 and attach it to an availability zone 
resource "aws_subnet" "public_subnet_1" {
  vpc_id   = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_block_1
  availability_zone = var.AZ1
  map_public_ip_on_launch = true

  tags = {
    Name  = "${var.project_name}-public-subnet-1"
  }
}

#Create public subnet 2 and attach it to an availability zone 
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_block_2
  availability_zone = var.AZ2
  map_public_ip_on_launch = true

  tags = {
   Name  = "${var.project_name}-public-subnet-2"
 }
}

# Create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id 
  }

  tags       = {
    Name     = "${var.project_name}-public-rt"
  }
}

#Associate the public subnet 1 to the public route table
resource "aws_route_table_association" "public_subnet_1_rt_association" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id= aws_route_table.public_route_table.id
}

#Associate the public subnet 2 to the public route table
resource "aws_route_table_association" "public_subnet_2_rt_association" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id= aws_route_table.public_route_table.id
}

# Key pair resource
resource "aws_key_pair" "deployer" {
  key_name   = var.key_pair
  public_key = file(var.public_key_path)
}


# Create network ACL and allow all inbound and outbound traffic
resource "aws_network_acl" "public_network_acl" {
  vpc_id = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  ingress {
        protocol   = -1
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }

    egress {
        protocol   = -1
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }
}

resource "null_resource" "ansible_playbook" {
  depends_on = [aws_instance.instance_1, aws_instance.instance_2, aws_instance.instance_3]

  provisioner "local-exec" {
   command = "ansible-playbook /home/vagrant/TERRAFORM_MINI_PROJECT/ansible/site.yaml -i /home/vagrant/TERRAFORM_MINI_PROJECT/ansible/host-inventory"
  }
}