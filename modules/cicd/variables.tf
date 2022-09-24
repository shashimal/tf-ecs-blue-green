variable "account" {
  type = string
  description = "AWS account"
}

variable "pipeline_name" {
  type = string
}
variable "pipeline_role_arn" {
  type = string
  default = ""
}

#Source

variable "codestar_connection" {
  default = ""
}
variable "repository_name" {
  type = string
}
variable "branch_name" {
  type = string
}
variable "source_repository_type" {
  type = string
}

#CodeBuild
variable "project_name" {
  type        = string
  description = "Codebuild project name"
}

variable "project_description" {
  type = string
  description = "Codebuild project description"
  default = ""
}

variable "build_service_role_arn" {
  type        = string
  description = "Codebuild service role arn"
  default = ""
}

variable "artifact_type" {
  type        = string
  description = " Build output artifact's type"
  default     = "CODEPIPELINE"
}

variable "compute_type" {
  type = string
  description = "Information about the compute resources the build project"
  default = "BUILD_GENERAL1_SMALL"
}

variable "image" {
  type = string
  description = "Docker image to use for this build project"
  default = "aws/codebuild/standard:2.0"
}

variable "environment_type" {
  type = string
  description = "Type of build environment to use for related build"
  default = "LINUX_CONTAINER"
}

variable "source_type" {
  type = string
  description = "Type of repository that contains the source code to be built"
  default = "CODEPIPELINE"
}

variable "build_environment_variables" {
  type = list(object({
    name = string
    type = string
    value = string
  }))
  description = "Environment variables"
  default = []
}

variable "privileged_mode" {
  type = bool
  description = "Whether to enable running the Docker daemon inside a Docker container."
  default = true
}

variable "credentials_type" {
  type = string
  description = "Type of credentials AWS CodeBuild uses to pull images in your build"
  default = "CODEBUILD"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags"
}

#CodeDeploy
variable "application_name" {
  type = string
  description = "Codedeploy application name"
}

variable "deploy_service_role_arn" {
  type = string
  description = "The service role ARN that allows deployments"
  default = ""
}

variable "termination_wait_time_in_minutes" {
  type = string
  description = "The number of minutes to wait after a successful blue/green deployment before terminating instances from the original environment"
  default = 60
}

variable "ecs_cluster_name" {
  type = string
  description = "ECS cluster name"
}

variable "ecs_service_name" {
  type = string
  description = "ECS service name"
}

variable "alb_prod_listener_arn" {
  type = string
  description = "ALB prod listener"
}

variable "alb_test_listener_arn" {
  type = string
  description = "ALB test listener"
}

variable "alb_target_group_one" {
  type = string
}

variable "alb_target_group_second" {
  type = string
}