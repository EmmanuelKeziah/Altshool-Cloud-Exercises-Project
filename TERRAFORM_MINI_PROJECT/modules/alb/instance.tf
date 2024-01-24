# Description: Terraform code for creating AWS instances and generating a host inventory file for Ansible.

resource "aws_instance" "instance_1" {
  ami       = var.ami
  instance_type = var.instance_type
  key_name = var.key_pair
  security_groups = [aws_security_group.alb_security_group_1.id, aws_security_group.alb_security_group_2.id]
  subnet_id = aws_subnet.public_subnet_1.id
  availability_zone = var.AZ1

   provisioner "remote-exec" {
    inline = [
      "sudo chmod -R 755 /home/vagrant/TERRAFORM_MINI_PROJECT", "sudo netstat -tuln | grep :22"
    ]
   }



  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file(var.private_key_path)
  }

  tags = {
    Name = "instance_1"
    source = "terraform"
  }
}


resource "aws_instance" "instance_2" {
  ami       = var.ami
  instance_type = var.instance_type
  key_name = var.key_pair
  security_groups = [aws_security_group.alb_security_group_1.id, aws_security_group.alb_security_group_2.id]
  subnet_id = aws_subnet.public_subnet_2.id
  availability_zone = var.AZ2

 provisioner "remote-exec" {
    inline = [
      "sudo chmod -R 755 /home/vagrant/TERRAFORM_MINI_PROJECT",
     "sudo netstat -tuln | grep :22"
    ]
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file(var.private_key_path)
  }

  tags = {
    Name = "instance_2"
    source = "terraform"
  }
}


resource "aws_instance" "instance_3" {
  ami       = var.ami
  instance_type = var.instance_type
  key_name = var.key_pair
  security_groups = [aws_security_group.alb_security_group_1.id]
  subnet_id = aws_subnet.public_subnet_1.id
  availability_zone = var.AZ1

  provisioner "remote-exec" {
    inline = [
      "sudo chmod -R 755 /home/vagrant/TERRAFORM_MINI_PROJECT", "sudo netstat -tuln | grep :22"
    ]
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file(var.private_key_path)
  }

  tags = {
    Name = "instance_3"
    source = "terraform"
  }
}

resource "aws_instance" "instance_1" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_pair
  security_groups      = [aws_security_group.alb_security_group_1.id]
  subnet_id            = aws_subnet.public_subnet_1.id
  availability_zone    = var.AZ1

  provisioner "remote-exec" {
    inline = [
      "sudo chmod -R 755 /home/vagrant/TERRAFORM_MINI_PROJECT",
      "sudo netstat -tuln | grep :22"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }

  tags = {
    Name   = "instance_1"
    source = "terraform"
  }
}

resource "aws_instance" "instance_2" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_pair
  security_groups      = [aws_security_group.alb_security_group_2.id]
  subnet_id            = aws_subnet.public_subnet_2.id
  availability_zone    = var.AZ2

  provisioner "remote-exec" {
    inline = [
      "sudo chmod -R 755 /home/vagrant/TERRAFORM_MINI_PROJECT",
      "sudo netstat -tuln | grep :22"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }

  tags = {
    Name   = "instance_2"
    source = "terraform"
  }
}

resource "aws_instance" "instance_3" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_pair
  security_groups      = [aws_security_group.alb_security_group_1.id]
  subnet_id            = aws_subnet.public_subnet_1.id
  availability_zone    = var.AZ1

  provisioner "remote-exec" {
    inline = [
      "sudo chmod -R 755 /home/vagrant/TERRAFORM_MINI_PROJECT",
      "sudo netstat -tuln | grep :22"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }

  tags = {
    Name   = "instance_3"
    source = "terraform"
  }
}

resource "local_file" "public_ip" {
  filename = "/home/vagrant/TERRAFORM_MINI_PROJECT/ansible/host-inventory"
  content  = <<EOF
  Welcome to this channel. ${aws_instance.instance_1.public_ip} says "Happy learning, hope to see you finish strong." \n \t ${aws_instance.instance_2.public_ip} says "Better is the end of a thing than the beginning." \n\t ${aws_instance.instance_3.public_ip} says "Slow and steady wins the race, just keep moving"
EOF
}



