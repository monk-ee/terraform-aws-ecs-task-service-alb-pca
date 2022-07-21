region             = "us-east-2"
short_region       = "usea1"
availability_zones = ["us-east-2a", "us-east-2b"]
namespace          = "eg"
stage              = "test"
name               = "alb"
vpc_cidr_block     = "172.16.0.0/16"
workload           = "default"

# Container Information
container_registry    = ""
container_tag         = "latest"
container_cpu         = 256
container_memory      = 512
container_port        = 80
host_port             = 80
environment_variables = {
  ENVIRONMENT = "dev"
}
log_configuration = {
  logDriver = "awslogs"
  options   = {
    "awslogs-create-group"  = "true"
    "awslogs-group"         = "ecs-logs"
    "awslogs-region"        = "${var.region}"
    "awslogs-stream-prefix" = "container-${var.environment}"
  }
  secretOptions = null
}
container_insights = "enabled"

#ECS Configuration
default_capacity_provider  = "FARGATE"
capacity_providers = ["FARGATE_SPOT", "FARGATE"]
service_replicas   = 1
max_capacity    = 1
min_capacity    = 1
cluster_id = ""
cluster_name = ""
cloudwatch_arn   = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
routable_security_group_ids  = []
non_routable_security_group_ids  = []
non_routable_subnet_ids = []
routable_subnet_ids  = []
common_name = "www.test.local"
zone_id = "#####"
ssl_policy   = "ELBSecurityPolicy-2016-08"
certificate_authority_arn    = null
stickiness = {
  cookie_duration = 60
  enabled         = true
}
health_check_path   = "/"
internal = true

# KMS Keys
ecr_kms_key_arn  = "arn:aws:kms:::alias/aws/ecr"
secretsmanager_kms_key_arn   = "arn:aws:kms:::alias/aws/secretsmanager"

# IAM Resource Constraints
secretsmanager_resource_constraints   = ["*"]
s3_resource_constraints  = ["*"]
sqs_resource_constraints    = ["*"]
ecr_resource_constraints   = ["*"]
