output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild.arn
}

output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy.arn
}

output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_cli-hook_role.arn
}