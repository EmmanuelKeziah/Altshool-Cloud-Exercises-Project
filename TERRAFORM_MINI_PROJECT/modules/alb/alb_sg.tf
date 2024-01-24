# Create security group for the application load balancer
resource "aws_security_group" "alb_security_group_1" {
  name = "alb_security_group_1"
  description = "Allow inbound traffic from HTTP on port 80 and HTTPS on port 443"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    description = "Allow SSH access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
   description = "Allow HTTPS access"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group rule for the container with ingress and egress rules
resource "aws_security_group" "alb_security_group_2" {
  name = "alb_security_group_2"
  description = "Allow inbound traffic from SSH, HTTP and HTTPS on port 22, 80 and 443 for EC2 instances"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS access"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_security_group_1.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_security_group_2"
  }
}
