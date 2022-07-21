module "aws_alb_https" {
  source                                          = "cloudposse/alb/aws"
  version                                         = "1.4.0"
  name                                            = format("%s-%s", var.workload, var.short_region)
  vpc_id                                          = var.vpc_id
  certificate_arn                                 = aws_acm_certificate.domain_cert.arn
  security_group_ids                              = var.non_routable_security_group_ids
  subnet_ids                                      = var.routable_subnet_ids
  internal                                        = var.internal
  http_enabled                                    = true
  http_redirect                                   = true# redirect http to https
  https_enabled                                   = true
  access_logs_enabled                             = true
  access_logs_prefix                              = var.workload
  alb_access_logs_s3_bucket_force_destroy         = true
  alb_access_logs_s3_bucket_force_destroy_enabled = true
  http2_enabled                                   = true
  idle_timeout                                    = 60 # default
  ip_address_type                                 = "ipv4"
  deregistration_delay                            = 15 # default
  health_check_path                               = var.health_check_path
  health_check_timeout                            = 10 # default
  health_check_healthy_threshold                  = 2 # default
  health_check_unhealthy_threshold                = 2 # default
  health_check_interval                           = 15 # default
  health_check_matcher                            = "200"
  health_check_port                               = "traffic-port"
  http_port                                       = 80
  https_port                                      = 443
  target_group_port                               = 80
  target_group_protocol                           = "HTTP"
  target_group_target_type                        = "ip" # could be ok
  stickiness                                      = var.stickiness
  context                                         = module.this.context
  depends_on                                      = [
    aws_acm_certificate.domain_cert
  ]
}
