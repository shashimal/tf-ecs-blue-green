#Codebuild
variable "codebuild_project_name" {
  type = string
}

variable "codebuild_service_role_arn" {
  type = string
}

variable "codebuild_environment_variables" {
  type = list(object({
    name = string
    type = string
    value = string
  }))
  default = []
}