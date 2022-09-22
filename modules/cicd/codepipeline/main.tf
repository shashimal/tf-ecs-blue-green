module "codebuild" {
  source = "../codebuild"
  codebuild_project_name = var.codebuild_project_name
  codebuild_service_role_arn = var.codebuild_service_role_arn
  codebuild_environment_variables = var.codebuild_environment_variables
}