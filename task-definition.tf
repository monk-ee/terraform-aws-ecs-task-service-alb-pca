# ====================== PROCESSOR ==========================
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = format("%s-family-%s-%s", var.workload, var.short_region, module.this.stage)
  requires_compatibilities = [var.default_capacity_provider]
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  #When networkMode=awsvpc, the host ports and container ports in port mappings must match.
  container_definitions    = module.container_definition.json_map_encoded_list
  execution_role_arn       = aws_iam_role.ecs_task_executor.arn
  task_role_arn            = aws_iam_role.ecs_task_runner.arn
  context                  = module.this.context
}
