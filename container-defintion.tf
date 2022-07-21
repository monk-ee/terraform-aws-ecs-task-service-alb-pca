module "container_definition" {
  source          = "cloudposse/ecs-container-definition/aws"
  version         = "0.58.1"
  container_name  = module.this.id
  container_image = format("%s:%s", var.container_registry, var.container_tag)
  port_mappings   = [
    {
      containerPort = var.container_port,
      hostPort      = var.host_port,
      protocol      = "tcp"
    }
  ]
  log_configuration = var.log_configuration
  map_environment   = var.environment_variables
  context           = module.this.context
}
