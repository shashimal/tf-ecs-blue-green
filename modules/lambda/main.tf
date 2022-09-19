
resource "aws_lambda_function" "lambda" {
  filename      = var.file_name
  function_name = var.function_name
  role          = var.execution_role_arn
  handler       = var.handler

  source_code_hash = filebase64sha256(var.file_name)
  runtime = var.runtime

}