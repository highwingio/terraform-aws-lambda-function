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
  key    = var.deploy_artifact_key
  source = var.path
  etag   = filemd5(var.path)
}

# The Lambda function itself
resource "aws_lambda_function" "lambda" {
  function_name                  = var.name
  handler                        = "lambda.handler"
  memory_size                    = 256
  publish                        = true
  reserved_concurrent_executions = var.reserved_concurrent_executions
  role                           = var.role_arn
  runtime                        = "ruby2.5"
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
