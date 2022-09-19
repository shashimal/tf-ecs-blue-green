resource "aws_codebuild_project" "cook_build_project" {
  name         = "cook-build-project"
  service_role = var.service_role_arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:1.0"
    type         = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"
  }
  source {
    type = "CODEPIPELINE"
  }
}