output "ecs_task_arn" {
  value       = aws_ecs_task_definition.ecs_task_definition.arn
  description = "ARN of task definition"
}

output "ecs_task_revision" {
  value       = aws_ecs_task_definition.ecs_task_definition.revision
  description = "Revision of task definition"
}

output "ecs_service_arn" {
  value       = aws_ecs_service.ecs_service.id
  description = "ARN of ecs service"
}

output "ecs_service_desired_count" {
  value       = aws_ecs_service.ecs_service.desired_count
  description = "Desired Count of ecs service"
}

output "name" {
  value       = module.ecs_task_service.name
  description = "The name of the record."
}

output "fqdn" {
  value       = module.ecs_task_service.fqdn
  description = "FQDN built using the zone domain and name."
}

output "id" {
  value       = module.ecs_task_service.id
  description = "The ARN of the certificate"
}

output "arn" {
  value       = module.ecs_task_service.arn
  description = "The ARN of the certificate"
}

output "domain_name" {
  value       = module.ecs_task_service.domain_name
  description = "The domain name for which the certificate is issued"
}

output "status" {
  value       = module.ecs_task_service.status
  description = "Status of the certificate."
}
