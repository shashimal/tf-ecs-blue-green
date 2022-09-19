variable "codepipeline_role_arn" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "codebuild_project_name" {
  type = string
}

variable "codepipeline_artifacts_bucket" {
  type = string
}
variable "codedeploy_app_name" {
  type = string
}

variable "codedeploy_deployment_group_name" {
  type = string
}