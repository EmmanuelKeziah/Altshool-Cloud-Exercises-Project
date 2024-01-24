# Get details of hosted zone and create a record set in route 53
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name

 tags = {
    Name = "terraform.${var.domain_name}"
  }
}

# Create A-record
resource "aws_route53_record" "site_domain" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  type = "A"
  name = "terraform.${var.domain_name}"

  alias {
    name = aws_lb.app-load-balancer.dns_name
    zone_id = aws_lb.app-load-balancer.zone_id
    evaluate_target_health = true
  }
}
