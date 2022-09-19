output "alb_arn" {
  value = aws_alb.alb.arn
}

output "blue_target_group" {
  value = aws_alb_target_group.blue_tg.arn
}

output "blue_listener_arn" {
  value = aws_lb_listener.prod_traffic.arn
}

output "test_listener_arn" {
  value = aws_lb_listener.test_traffic.arn
}

output "blue_target_group_name" {
  value = aws_alb_target_group.blue_tg.name
}

output "green_target_group_name" {
  value = aws_alb_target_group.green_tg.name
}