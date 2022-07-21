provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.28.1"
  cidr_block = var.vpc_cidr_block
  context    = module.this.context
}

module "subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "0.39.8"
  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false
  context              = module.this.context
}

module "ecs_task_service" {
  source       = "../.."
  short_region = var.short_region
  name         = format("%s-%s", var.workload, var.short_region)
  ecs_cluster_arn    = var.cluster_id
  vpc_id             = module.vpc.vpc_id
  container_registry = var.container_registry
  container_tag      = var.container_tag
  container_cpu      = var.container_cpu
  container_memory   = var.container_memory
  container_port     = var.container_port
  host_port          = var.host_port
  log_configuration  = var.log_configuration
  environment_variables = var.environment_variables
  container_insights         = var.container_insights
  default_capacity_provider  = var.default_capacity_provider
  capacity_providers         = var.capacity_providers
  service_replicas           = var.service_replicas
  max_capacity               = var.max_capacity
  min_capacity               = var.min_capacity
  non_routable_security_group_ids = var.non_routable_security_group_ids
  non_routable_subnet_ids    = var.non_routable_subnet_ids
  routable_subnet_ids        = var.routable_subnet_ids
  cluster_id                 = var.cluster_id
  cluster_name               = var.cluster_name
  cloudwatch_arn             = var.cluster_name
  certificate_authority_arn  = var.certificate_authority_arn
  zone_id                    = var.zone_id
  common_name                = var.common_name
  context = module.this.context
}
