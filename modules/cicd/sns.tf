resource "aws_sns_topic" "pipeline_approval" {
  count  =var.approval_sns_topic_arn == "" ? 1: 0
  name = var.approval_sns_topic_name

}