#CodePipeline IAM
data "aws_iam_policy_document" "codepipeline_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  assume_role_policy = data.aws_iam_policy_document.codepipeline_trust_policy.json
  name = "${var.project_name}-codepipeline-role"
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-policy"
  policy = templatefile("${path.module}/templates/codepipeline-policy.json.tpl", {} )
  role   = aws_iam_role.codepipeline_role.id
}

#CodeBuild IAM
data "aws_iam_policy_document" "codebuild_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  assume_role_policy = data.aws_iam_policy_document.codebuild_trust_policy.json
  name               = "${var.project_name}-codebuild-role"

}

resource "aws_iam_role_policy" "codebuild_iam_policy" {
  name   = "${var.project_name}-permisson-policy"
  policy = templatefile("${path.module}/templates/codebuild-policy.json.tpl",
    {
      aws_account_id  = var.account
      artifact_bucket = aws_s3_bucket.artifact_bucket.id
    }
  )
  role = aws_iam_role.codebuild_role.id
}

#CodeDeploy IAM
data "aws_iam_policy_document" "codedeploy_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codedeploy_role" {
  assume_role_policy  = data.aws_iam_policy_document.codedeploy_trust_policy.json
  name                = "${var.application_name}-codedeploy-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda",
    "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  ]
}
