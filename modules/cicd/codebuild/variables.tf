variable "codebuild_project_name" {
  type        = string
  description = "Codebuild project name"
}

variable "codebuild_project_description" {
  type = string
  description = "Codebuild project description"
  default = ""
}

variable "codebuild_service_role_arn" {
  type        = string
  description = "Codebuild service role arn"
}

variable "codebuild_artifact_type" {
  type        = string
  description = " Build output artifact's type"
  default     = "CODEPIPELINE"
}

variable "codebuild_compute_type" {
  type = string
  description = "Information about the compute resources the build project"
  default = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_image" {
  type = string
  description = "Docker image to use for this build project"
  default = "aws/codebuild/standard:2.0"
}

variable "codebuild_environment_type" {
  type = string
  description = "Type of build environment to use for related build"
  default = "LINUX_CONTAINER"
}

variable "codebuild_source_type" {
  type = string
  description = "Type of repository that contains the source code to be built"
  default = "CODEPIPELINE"
}

variable "codebuild_environment_variables" {
  type = list(object({
    name = string
    type = string
    value = string
  }))
  description = "Environment variables"
  default = []
}