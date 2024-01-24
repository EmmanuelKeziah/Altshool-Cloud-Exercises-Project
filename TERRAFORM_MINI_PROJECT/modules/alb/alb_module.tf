#Description: This file contains the code to create an application load balancer and its dependencies.


# Create application load balancer and an specify its dependencies on the application load balancer
resource "aws_lb" "app-load-balancer" {
  name = "${var.lb_name}-alb"
  internal = "false"
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_security_group_1.id, aws_security_group.alb_security_group_2.id]
  subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  enable_deletion_protection = false
  depends_on = [ aws_instance.instance_1, aws_instance.instance_2, aws_instance.instance_3]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# Create target group for the application load balancer
resource "aws_lb_target_group" "alb-tg" {
  name = "${var.project_name}-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id
  depends_on = [ aws_instance.instance_1, aws_instance.instance_2, aws_instance.instance_3]

  health_check {
    enabled = true
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 10
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    matcher = 200
  }
}

# Create a listener on port 80 with forward action
resource "aws_lb_listener" "alb_http_listener"{
  load_balancer_arn = aws_lb.app-load-balancer.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.alb-tg.arn
    type = "forward"
  }
}

#  Define a listener rule for the Application Load Balancer and forward incoming requests with a path pattern of "/" to a target group.
resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_lb_listener.alb_http_listener.arn
  priority = 1

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }

  condition {
    path_pattern {
        values = ["/"]
    }
  }
}

# Attach the target group to the first instance
resource "aws_lb_target_group_attachment" "alb-tg-attachment-1" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id = aws_instance.instance_1.id
  port = 80
}

# Attach the target group to the second instance
resource "aws_lb_target_group_attachment" "alb-tg-attachment-2" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id = aws_instance.instance_2.id
  port = 80
}

# Attach the target group to the third instance
resource "aws_lb_target_group_attachment" "alb-tg-attachment-3" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id = aws_instance.instance_3.id
  port = 80
}

