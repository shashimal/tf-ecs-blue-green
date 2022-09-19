data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecs_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_trust_policy.json
  name = "cook-ecs-task-role"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_role.name
}

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
  name = "codepipeline-role"
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-policy"
  policy = templatefile("${path.root}/templates/codepipeline-policy.json.tpl", {} )
  role   = aws_iam_role.codepipeline_role.id
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  assume_role_policy = data.aws_iam_policy_document.codebuild.json
  name               = "cook-service-codebuild"

}

resource "aws_iam_role_policy" "codebuild" {
  name   = "CodeBuildBase"
  policy = templatefile("${path.root}/templates/codebuild-policy.json.tpl",
    {
      aws_account_id      = data.aws_caller_identity.current.account_id
      codepipeline-bucket = var.codepipeline_artifacts_bucket
    }
  )
  role  = aws_iam_role.codebuild.id
}

data "aws_iam_policy_document" "codedeploy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codedeploy" {
  assume_role_policy = data.aws_iam_policy_document.codedeploy.json
  name               = "cook-service-codedeploy"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda", "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"]
}

#resource "aws_iam_role_policy_attachment" "codedeploy" {
#  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
#  role       = aws_iam_role.codedeploy.name
#}


data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "lambda_cli-hook_role" {
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json
  name = "lambda-cli-hook-role"
}

resource "aws_iam_role_policy" "lambda_cli-hook_role_policy" {
  name   = "lambda-cli-hook-role-policy"
  policy = templatefile("${path.root}/templates/lambda-execution-policy.json.tpl",{}
  )
  role  = aws_iam_role.lambda_cli-hook_role.id
}


