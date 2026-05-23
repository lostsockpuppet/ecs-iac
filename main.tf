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