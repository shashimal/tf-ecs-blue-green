resource "aws_codebuild_project" "codebuild_project" {
  name         = var.project_name
  description  = var.project_description
  service_role = var.build_service_role_arn != ""? var.build_service_role_arn : aws_iam_role.codebuild_role.arn

  artifacts {
    type = var.artifact_type
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = var.environment_type
    image_pull_credentials_type = var.credentials_type
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {

      for_each = var.build_environment_variables
      content {
        name  = environment_variable.value.name
        type  = environment_variable.value.type
        value = environment_variable.value.value
      }
    }

  }

  source {
    type = var.source_type
  }
}