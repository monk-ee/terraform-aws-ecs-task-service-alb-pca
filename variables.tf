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

variable "container_registry" {
  type = string
  description = "The registry and container name"
  default = "FARGATE"
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
  type = string
  description = "The container memory"
  default = 512
}

variable "container_port" {
  type = string
  description = "The container port"
  default = 80
}

variable "host_port" {
  type = string
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

variable "vpc_id" {
  type = string
  description = "Deployment VPC ID"
  default = ""
}

variable "private_security_group_ids" {
  type = list(string)
  description = "The private security for ECS deployments"
}

variable "non_routable_subnet_ids" {
  type = list(string)
  description = "The non routable subnets for ECS deployments"
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

variable "workload" {
  type = string
  description = "Workload name differentiator."
  default = "default"
}

variable "common_name" {
  type = string
  description = "The parent domain suffix for the certificate"
}

variable "zone_id" {
  type = string
  description = "The domain zone id"
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

variable "routable_subnet_ids" {
  type = list(string)
  description = "routable_subnet_ids"
  default = null
}
