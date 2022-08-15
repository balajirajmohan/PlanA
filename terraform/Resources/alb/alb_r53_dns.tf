resource "aws_route53_record" "alb" {
  zone_id = var.zone_id
  name = var.dns_name
  type = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.load_balancer_zone_id
    evaluate_target_health = false
  }
}