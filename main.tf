# ====================== APP Scaling ==========================
resource "aws_appautoscaling_target" "ecs_appscaling_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = format("service/%s/%s", var.cluster_name, aws_ecs_service.ecs_service.name)
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
