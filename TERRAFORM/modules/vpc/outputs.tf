output "region_name" {
  value = var.region
}

output "project_name" {
  value = var.project
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_ip" {
  value = aws_instance.instance.public_ip
}
output "public_subnet_AZ_1_id" {
  value = aws_subnet.public_subnet_AZ_1.id
}

output "public_subnet_AZ_2_id" {
  value = aws_subnet.public_subnet_AZ_2.id
}

output "private_subnet_AZ_1_id" {
  value = aws_subnet.private_data_subnet_az_1.id
}

output "private_subnet_AZ_2_id" {
  value = aws_subnet.private_subnet_az_2.id
}

output "private_data_subnet_az_1_id" {
  value = aws_subnet.private_data_subnet_az_1.id
}

output "private_data_subnet_az_2_id" {
  value = aws_subnet.private_data_subnet_az_2.id
}

output "igw" {
  value = aws_internet_gateway.internet_gateway
}