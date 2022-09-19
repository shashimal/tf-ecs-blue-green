variable "cluster_name" {
  type = string
}

variable "alb" {
  type = string
}

variable "cook_target_group" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "cook_security_group_id" {
  type = string
}

variable "task_role_arn" {
  type = string
}