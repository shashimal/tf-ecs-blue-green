variable "codedeploy_service_role_arn" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_cook_service_name" {
  type = string
}

variable "alb_listener_blue_arn" {
  type = string
}
variable "alb_listener_test_arn" {
  type = string
}
variable "alb_target_group_blue_name" {
  type = string
}
variable "alb_target_group_green_name" {
  type = string
}