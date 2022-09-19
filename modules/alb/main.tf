resource "aws_alb" "alb" {
  internal           = false
  load_balancer_type = "application"
  name               = var.app_name
  security_groups    = var.alb_security_groups
  subnets            = var.public_subnets
}

resource "aws_lb_listener" "prod_traffic" {
  port = 80
  load_balancer_arn = aws_alb.alb.arn

  default_action {
    target_group_arn = aws_alb_target_group.blue_tg.arn
    type = "forward"
  }
  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}

resource "aws_lb_listener" "test_traffic" {
  port = 8082
  load_balancer_arn = aws_alb.alb.arn

  default_action {
    target_group_arn = aws_alb_target_group.blue_tg.arn
    type = "forward"
  }
  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}

resource "aws_alb_target_group" "blue_tg" {
  name = "ecs-blue-tg"
  port = "80"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_target_group" "green_tg" {
  name = "ecs-green-tg"
  port = "80"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"

  }
}