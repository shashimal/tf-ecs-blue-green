resource "aws_codepipeline" "codepipeline" {
  name     = "cook-service"
  role_arn = var.codepipeline_role_arn
  artifact_store {
    location = var.codepipeline_artifacts_bucket
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      category         = "Source"
      name             = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArti"]
      configuration    = {
        RepositoryName = var.repository_name
        BranchName     = "master"
        PollForSourceChanges = false
      }
    }
  }
  stage {
    name = "Build"
    action {
      category         = "Build"
      name             = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArti"]
      output_artifacts = ["BuildArti"]
      configuration    = {
        ProjectName = var.codebuild_project_name
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["BuildArti"]
      version         = "1"
      configuration   = {
        DeploymentGroupName            = var.codedeploy_deployment_group_name
        ApplicationName                = var.codedeploy_app_name
        AppSpecTemplateArtifact        = "BuildArti"
        AppSpecTemplatePath            = "appspec.yaml"
        TaskDefinitionTemplateArtifact = "BuildArti"
        TaskDefinitionTemplatePath     = "taskdef.json"
        Image1ArtifactName             = "BuildArti"
        Image1ContainerName            = "IMAGE1_NAME"

      }
    }
  }
}
