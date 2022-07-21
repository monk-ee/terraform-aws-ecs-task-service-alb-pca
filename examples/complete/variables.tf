# Common Configuration
variable "region" {
  type        = string
  description = "AWS Region for resources and services"
  default     = null
}

variable "short_region" {
  type        = string
  description = "AWS Region for resources and services"
  default     = null
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "workload" {
  type = string
  description = "Workload name differentiator."
  default = "default"
}

# Container Information
variable "container_registry" {
  type = string
  description = "The registry and container name"
  default = null
}

variable "container_tag" {
  type = string
  description = "The container tag to deploy (DO NOT USE LATEST, I'M WARNING YOU)"
  default = "latest"
}

variable "container_cpu" {
  type = number
  description = "The container CPU"
  default = 256
}

variable "container_memory" {
  type = number
  description = "The container memory"
  default = 512
}

variable "container_port" {
  type = number
  description = "The container port"
  default = 80
}

variable "host_port" {
  type = number
  description = "The host port"
  default = 80
}

variable environment_variables {
  type = map(string)
  description = "Map of env vars to push into container"
  default = null
}

variable log_configuration {
  type = any
  description = "Log configuration"
  default = null
}

variable "container_insights" {
  type = string
  description = "Turn on container insights for cloud watch - does incur a cost"
  default = "enabled"
}

#ECS Configuration
variable "default_capacity_provider" {
  type = string
  description = "Default capacity provider for fargate - option for spot and cost recovery here"
  default = "FARGATE"
}

variable "capacity_providers" {
  type = list(string)
  default = ["FARGATE_SPOT", "FARGATE"]
}

variable "service_replicas" {
  type = number
  description = "Desired count of service replicas"
  default = 1
}

variable "max_capacity" {
  type = number
  description = "Maximum Appscaling capacity"
  default = 1
}

variable "min_capacity" {
  type = number
  description = "Minimum Appscaling capacity"
  default = 1
}

variable "cluster_id" {
  type = string
  description = "The ID of the ECS cluster to deploy into"
}

variable "cluster_name" {
  type =  string
  description = "The name of the ECS cluster to deploy into"
}

variable "cloudwatch_arn" {
  type = string
  description = "A very angry managed cloud watch policy - seems excessive"
  default = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Networking and Security
variable "routable_security_group_ids" {
  type = list(string)
  description = "The public security for ECS deployments"
  default = []
}

variable "non_routable_security_group_ids" {
  type = list(string)
  description = "The private security for ECS deployments"
  default = []
}

variable "non_routable_subnet_ids" {
  type = list(string)
  description = "The non routable subnets for ECS deployments"
  default = []
}

variable "routable_subnet_ids" {
  type = list(string)
  description = "routable_subnet_ids"
  default = []
}

#ALB, DNS and Certificate Configuration
variable "common_name" {
  type = string
  description = "The parent domain suffix for the certificate"
  default = null
}

variable "zone_id" {
  type = string
  description = "The domain zone id"
  default = null
}

variable "ssl_policy" {
  type = string
  description = ""
  default = "ELBSecurityPolicy-2016-08"
}

variable "certificate_authority_arn" {
  type = string
  description = ""
  default = null
}

variable "stickiness" {
  type = object({
    cookie_duration = number
    enabled         = bool
  })
  description = "Target group sticky configuration"
  default     = null
}

variable "health_check_path" {
  type = string
  description = "Health Check Path"
  default = "/"
}

variable "internal" {
  type = bool
  description = "Type of ALB"
  default = true
}

# KMS Keys
variable "ecr_kms_key_arn" {
  type = string
  description = "KMS Key ARN for ECR"
  default = "arn:aws:kms:::alias/aws/ecr"
}

variable "secretsmanager_kms_key_arn" {
  type = string
  description = "KMS Key ARN for Secrets Manager"
  default = "arn:aws:kms:::alias/aws/secretsmanager"
}

# IAM Resource Constraints
variable "secretsmanager_resource_constraints" {
  type = list(string)
  description = "Constraints for Secrets Manager access from ECR"
  default = ["*"]
}

variable "s3_resource_constraints" {
  type = list(string)
  description = "Constraints for S3 access from ECR"
  default = ["*"]
}

variable "sqs_resource_constraints" {
  type = list(string)
  description = "Constraints for SQS access from ECR"
  default = ["*"]
}

variable "ecr_resource_constraints" {
  type = list(string)
  description = "Constraints for Token Access to ECR"
  default = ["*"]
}
