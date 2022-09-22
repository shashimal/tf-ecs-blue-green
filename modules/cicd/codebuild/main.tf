resource "aws_codebuild_project" "codebuild_project" {
  name         = var.codebuild_project_name
  description = var.codebuild_project_description
  service_role = var.codebuild_service_role_arn
  artifacts {
    type = var.codebuild_artifact_type
  }
  environment {
    compute_type = var.codebuild_compute_type
    image        = var.codebuild_image
    type         = var.codebuild_environment_type

    dynamic "environment_variable" {

      for_each = var.codebuild_environment_variables
      content {
        name  = environment_variable.value.name
        type  = environment_variable.value.type
        value = environment_variable.value.value
      }
    }

  }
  source {
    type = var.codebuild_source_type
  }
}