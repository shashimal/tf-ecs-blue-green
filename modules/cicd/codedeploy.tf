resource "aws_codedeploy_app" "app" {
  name             = var.application_name
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  deployment_group_name = "${var.application_name}-deployment-group"
  app_name              = aws_codedeploy_app.app.name
  service_role_arn      = var.deploy_service_role_arn != "" ? var.deploy_service_role_arn : aws_iam_role.codedeploy_role.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.termination_wait_time_in_minutes
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_prod_listener_arn]
      }
      test_traffic_route {
        listener_arns = [var.alb_test_listener_arn]
      }
      target_group {
        name = var.alb_target_group_one
      }
      target_group {
        name = var.alb_target_group_second
      }
    }
  }
}