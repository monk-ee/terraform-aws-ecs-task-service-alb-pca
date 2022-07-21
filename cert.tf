resource "aws_route53_record" "a_record" {
  zone_id = var.zone_id
  name    = var.common_name
  type    = "A"
  alias {
    evaluate_target_health = false
    name = module.aws_alb_https.alb_dns_name
    zone_id = module.aws_alb_https.alb_zone_id
  }
  depends_on = [module.aws_alb_https]
}

resource "aws_acm_certificate" "domain_cert" {
  domain_name       = var.common_name
  certificate_authority_arn = var.certificate_authority_arn
  lifecycle {
    create_before_destroy = true
  }
  tags = module.this.tags
}
