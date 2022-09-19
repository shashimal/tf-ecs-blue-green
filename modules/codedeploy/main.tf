resource "aws_codedeploy_app" "codedeploy_app" {
  name             = "cook-service"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "codedeploy_app_group" {
  app_name               = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name  = "cook-service-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = var.codedeploy_service_role_arn

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
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_cook_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_listener_blue_arn]
      }
      test_traffic_route {
        listener_arns = [var.alb_listener_test_arn]
      }
      target_group {
        name = var.alb_target_group_blue_name
      }
      target_group {
        name = var.alb_target_group_green_name
      }
    }
  }


}