#Creating an ec2 instance for region 1

# Path: EC2_instance.tf

resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_pair
  subnet_id = aws_subnet.public_subnet_AZ_1.id
  vpc_security_group_ids = [aws_security_group.aws_security_group.id]
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  
    user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update -y && sudo apt-get upgrade -y
        sudo apt-get install docker.io --y
        sudo systemctl start docker
        sudo systemctl enable docker
        docker pull ansible/ansible:latest
        docker run -dit --name ANSIBLE_DOCKER -v  ~/terraform:/ansible/playbooks
        ansible/ansible:latest /bin/bash
        EOF

    tags = {
      Name   = "${var.project}-instance"
      source = "terraform"
  }
}