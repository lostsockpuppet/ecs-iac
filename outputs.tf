output "s3_app_ecr_repository_url" {
  description = "ECR repository URL for the S3 Flask app"
  value       = aws_ecr_repository.s3_app.repository_url
}

output "sqs_app_ecr_repository_url" {
  description = "ECR repository URL for the SQS Flask app"
  value       = aws_ecr_repository.sqs_app.repository_url
}

output "s3_bucket_name" {
  description = "S3 bucket name used by the S3 Flask app"
  value       = aws_s3_bucket.upload_bucket.bucket
}

output "sqs_queue_url" {
  description = "SQS queue URL used by the SQS Flask app"
  value       = aws_sqs_queue.message_queue.url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "default_vpc_id" {
  description = "Default VPC ID"
  value       = data.aws_vpc.default.id
}

output "default_subnet_ids" {
  description = "Default subnet IDs"
  value       = data.aws_subnets.default.ids
}
output "ecs_task_execution_role_arn" {
  description = "ECS task execution role ARN"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "s3_app_task_role_arn" {
  description = "Task role ARN for the S3 Flask app"
  value       = aws_iam_role.s3_app_task_role.arn
}

output "sqs_app_task_role_arn" {
  description = "Task role ARN for the SQS Flask app"
  value       = aws_iam_role.sqs_app_task_role.arn
}

output "s3_app_log_group_name" {
  description = "CloudWatch log group for the S3 Flask app"
  value       = aws_cloudwatch_log_group.s3_app.name
}

output "sqs_app_log_group_name" {
  description = "CloudWatch log group for the SQS Flask app"
  value       = aws_cloudwatch_log_group.sqs_app.name
}