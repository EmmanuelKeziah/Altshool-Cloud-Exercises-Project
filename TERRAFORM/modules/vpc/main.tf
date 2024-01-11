# Create a VPC for region 1
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

    tags      = {
    Name    = "${var.project}-vpc"
  }
}

# Create internet gateway and attach it to VPC
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.project}-igw"
  }
}

#Use data to pull availability zone information for the current region from aws.
data "aws_availability_zones" "available_zones" { }

#Create public subnet 1 and attach it to an availability zone 
resource "aws_subnet" "public_subnet_AZ_1" {
  vpc_id   = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_block_AZ_1
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name  = "${var.project}-public-subnet-AZ1"
  }
}

#Create public subnet 2 and attach it to an availability zone 
resource "aws_subnet" "public_subnet_AZ_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_block_AZ_2
  availability_zone = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
   Name  = "${var.project}-public-subnet AZ2"
 }
}

# Create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id 
  }

  tags       = {
    Name     = "${var.project}-public-rt"
  }
}

#Associate the public subnet AZ1 to the public route table
resource "aws_route_table_association" "public_subnet_1_rt_association" {
  subnet_id = aws_subnet.public_subnet_AZ_1.id
  route_table_id= aws_route_table.public_route_table.id
}

#Associate the public subnet AZ2 to the public route table
resource "aws_route_table_association" "public_subnet_2_rt_association" {
  subnet_id = aws_subnet.public_subnet_AZ_2.id
  route_table_id= aws_route_table.public_route_table.id
}
#Create private subnet for AZ1
resource "aws_subnet" "private_subnet_az_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr_block_AZ_1
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name  = "${var.project}-private-subnet-AZ_1"
  }
}

#Create private subnet for AZ2
resource "aws_subnet" "private_subnet_az_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr_block_AZ_2
  availability_zone = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name  = "${var.project}-private-subnet-AZ_2"
  }
}

#Create private data subnet az1
resource "aws_subnet" "private_data_subnet_az_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_data_subnet_az_1
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project}-private-data-subnet-az1"
  }
}

#Create private data subnet az2
resource "aws_subnet" "private_data_subnet_az_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_data_subnet_az_2
  availability_zone = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project}-private-data-subnet-az2"
  }
}
