#output "queue_list" {
#  value = [for v in module.queue: v.sqs_queue_arn]
#}

data "aws_caller_identity" "current" {}
