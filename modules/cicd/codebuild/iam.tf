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
  name               = "${var.codebuild_project_name}-role"

}

resource "aws_iam_role_policy" "codebuild_iam_policy" {
  name   = "${var.codebuild_project_name}-permisson-policy"
  policy = templatefile("${path.module}/codebuild-policy.json.tpl",
    {
      aws_account_id  = var.account
      artifact_bucket = var.artifact_bucket
    }
  )
  role = aws_iam_role.codebuild_role.id
}