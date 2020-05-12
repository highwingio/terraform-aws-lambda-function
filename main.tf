/**
 * # terraform-aws-lambda-function
 * Terraform module for a Lambda function with a standard configuration
 *
 * ## Usage
 *
 * ```hcl
 * module "my_lambda" {
 *   source             = "github.com/highwingio/terraform-aws-lambda-function?ref=master"
 *   # Other arguments here...
 * }
 * ```
 *
 * ## Updating the README
 *
 * This repo uses [terraform-docs](https://github.com/segmentio/terraform-docs) to autogenerate its README.
 *
 * To regenerate, run this command:
 *
 * ```bash
 * $ terraform-docs markdown table . > README.md
 * ```
 */

locals {
  deploy_artifact_key = "deploy.zip"
}

# Configure default role permissions
data "aws_iam_role" "lambda_execution_role" {
  name = var.role_name
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = data.aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_networking" {
  role       = data.aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# S3 bucket for deploying Lambda artifacts
# Not always required but it's more consistent for deploying larger files
resource "aws_s3_bucket" "lambda_deploy" {
  acl           = "private"
  bucket_prefix = "lambda-deploy"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# S3 object to hold the deployed artifact
resource "aws_s3_bucket_object" "lambda_deploy_object" {
  bucket = aws_s3_bucket.lambda_deploy.id
  key    = local.deploy_artifact_key
  source = var.path
  etag   = filemd5(var.path)
}

# The Lambda function itself
resource "aws_lambda_function" "lambda" {
  function_name                  = var.name
  handler                        = var.handler
  memory_size                    = var.memory_size
  publish                        = true
  reserved_concurrent_executions = var.reserved_concurrent_executions
  role                           = data.aws_iam_role.lambda_execution_role.arn
  runtime                        = var.runtime
  s3_bucket                      = aws_s3_bucket.lambda_deploy.id
  s3_key                         = aws_s3_bucket_object.lambda_deploy_object.key
  s3_object_version              = aws_s3_bucket_object.lambda_deploy_object.version_id
  source_code_hash               = filebase64sha256(var.path)
  timeout                        = var.timeout

  dynamic "vpc_config" {
    for_each = length(var.subnet_ids) > 0 ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  environment {
    variables = var.environment
  }

  tracing_config {
    mode = "Active"
  }
}

# An alarm to notify of function errors
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.name} - High Error Rate"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
  unit                = "Count"

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }

  alarm_description = "This metric monitors errors on the ${var.name} lambda"
  alarm_actions     = [var.notifications_topic_arn]
  ok_actions        = [var.notifications_topic_arn]
}

# Configure logging in Cloudwatch
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention_in_days
}
