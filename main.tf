data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_ecr_repository" "s3_app" {
  name = "${var.project_name}-s3-app"
}

resource "aws_ecr_repository" "sqs_app" {
  name = "${var.project_name}-sqs-app"
}

resource "aws_s3_bucket" "upload_bucket" {
  bucket = "${var.project_name}-uploads-${data.aws_caller_identity.current.account_id}"
}

resource "aws_sqs_queue" "message_queue" {
  name = "${var.project_name}-queue"
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
}
resource "aws_cloudwatch_log_group" "s3_app" {
  name              = "/ecs/${var.project_name}-s3-app"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "sqs_app" {
  name              = "/ecs/${var.project_name}-sqs-app"
  retention_in_days = 7
}
data "aws_iam_policy_document" "ecs_task_execution_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.project_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role" "s3_app_task_role" {
  name               = "${var.project_name}-s3-app-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role.json
}

data "aws_iam_policy_document" "s3_app_policy" {
  statement {
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.upload_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_app_policy" {
  name   = "${var.project_name}-s3-app-policy"
  policy = data.aws_iam_policy_document.s3_app_policy.json
}

resource "aws_iam_role_policy_attachment" "s3_app_policy_attachment" {
  role       = aws_iam_role.s3_app_task_role.name
  policy_arn = aws_iam_policy.s3_app_policy.arn
}
resource "aws_iam_role" "sqs_app_task_role" {
  name               = "${var.project_name}-sqs-app-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role.json
}

data "aws_iam_policy_document" "sqs_app_policy" {
  statement {
    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.message_queue.arn
    ]
  }
}

resource "aws_iam_policy" "sqs_app_policy" {
  name   = "${var.project_name}-sqs-app-policy"
  policy = data.aws_iam_policy_document.sqs_app_policy.json
}

resource "aws_iam_role_policy_attachment" "sqs_app_policy_attachment" {
  role       = aws_iam_role.sqs_app_task_role.name
  policy_arn = aws_iam_policy.sqs_app_policy.arn
}