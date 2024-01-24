# Define the output to be displayed in the DNS server

output "app-load-balancer_dns_name" {
  value = aws_lb.app-load-balancer.dns_name
}

