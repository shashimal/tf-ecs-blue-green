locals {
  source_repository_types = {
    github = {
      provider      = "CodeStarSourceConnection"
      configuration = {
        ConnectionArn    = var.codestar_connection
        FullRepositoryId = var.repository_name
        BranchName       = var.branch_name
      }

    }
    codecommit = {
      provider      = "CodeCommit"
      configuration = {
        RepositoryName = var.repository_name
        BranchName     = var.branch_name
      }
    }
  }

  source_configuration = lookup(local.source_repository_types, var.source_repository_type, "")
}

resource "aws_s3_bucket" "artifact_bucket" {
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_codepipeline" "pipeline" {
  name     = var.pipeline_name
  role_arn = var.pipeline_role_arn != ""? var.pipeline_role_arn : aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = aws_s3_bucket.artifact_bucket.id
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      category         = "Source"
      name             = "Source"
      owner            = "AWS"
      provider         = local.source_configuration["provider"]
      version          = "1"
      output_artifacts = ["SourceArti"]
      configuration    = local.source_configuration["configuration"]
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
        ProjectName = aws_codebuild_project.codebuild_project.name
      }
    }
  }
  dynamic "stage" {

    for_each = var.approval_required ? [1] : []
    content {
      name = "Approve"
      action {
        name     = "Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"
        configuration = {
          NotificationArn    = var.approval_sns_topic_arn != "" ? var.approval_sns_topic_arn : element(aws_sns_topic.pipeline_approval.*.arn, 0)
          CustomData         = var.approval_custom_data
          ExternalEntityLink = var.approval_external_entity_link
        }
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
      DeploymentGroupName            = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
      ApplicationName                = aws_codedeploy_app.app.name
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