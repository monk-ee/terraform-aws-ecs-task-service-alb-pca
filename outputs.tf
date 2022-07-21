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
