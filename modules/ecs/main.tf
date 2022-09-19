resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "cook" {
  container_definitions = templatefile("${path.root}/templates/container_definitions.json.tpl", {})
  family                = "ecs-cook"
  cpu = "256"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  task_role_arn = var.task_role_arn
  execution_role_arn = var.task_role_arn
}

resource "aws_ecs_service" "cook" {
  name = "cook-service"
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.cook.arn
  desired_count = 1
  enable_ecs_managed_tags           = "true"
  health_check_grace_period_seconds = "60"
  launch_type                       = "FARGATE"
  propagate_tags                    = "SERVICE"
  platform_version                  = "1.4.0"

 deployment_controller {
   type = "CODE_DEPLOY"
 }
  load_balancer {
    target_group_arn = var.cook_target_group
    container_name = "cook"
    container_port = 80
  }

  network_configuration {
    security_groups = [var.cook_security_group_id]
    subnets = var.public_subnets
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer
    ]
  }
}