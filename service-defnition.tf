# ====================== SERVICE ==========================
resource "aws_ecs_service" "ecs_service" {
  depends_on = [
    aws_ecs_task_definition.ecs_task_definition, module.aws_alb_https
  ]
  #aws_iam_role_policy
  name            = format("service-%s-%s", var.workload, var.short_region)
  cluster         = var.cluster_id
  launch_type     = var.default_capacity_provider
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.service_replicas

  load_balancer {
    container_name   = module.this.id
    container_port   = var.container_port
    target_group_arn = module.aws_alb_https.default_target_group_arn
  }

  network_configuration {
    security_groups = var.non_routable_security_group_ids
    subnets         = var.non_routable_subnet_ids
  }

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }
  context = module.this.context
}
