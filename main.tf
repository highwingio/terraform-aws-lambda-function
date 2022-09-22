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
  deploy_artifact_key  = "deploy.zip"
  deployment_bucket_id = coalesce(var.deployment_bucket_id, data.aws_ssm_parameter.deployment_bucket_id.value)
  source_hash          = coalesce(var.git_sha, filebase64sha256(var.path))
  role_arn             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.role_name}"
}

# Configure default role permissions
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = var.role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_networking" {
  role       = var.role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_xray" {
  role       = var.role_name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_insights" {
  role       = var.role_name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

# S3 object to hold the deployed artifact
resource "aws_s3_bucket_object" "lambda_deploy_object" {
  for_each    = var.image_uri == null ? {1 = 1} : {}
  bucket      = local.deployment_bucket_id
  key         = "${var.name}/${local.deploy_artifact_key}"
  source      = var.path
  source_hash = md5(local.source_hash)
  tags = merge(var.tags, {
    GitSHA = var.git_sha
  })
}

# The Lambda function itself
resource "aws_lambda_function" "lambda" {
  function_name = var.name
  description   = var.description
  handler       = var.handler
  layers = var.image_uri == null ? concat(
    var.layer_arns,
    ["arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:14"] # ARN for us-east-1
  ) : null
  memory_size                    = var.memory_size
  publish                        = true
  reserved_concurrent_executions = var.reserved_concurrent_executions
  role                           = local.role_arn
  runtime                        = var.runtime
  s3_bucket                      = var.image_uri == null ? local.deployment_bucket_id : null
  s3_key                         = var.image_uri == null ? aws_s3_bucket_object.lambda_deploy_object[0].key : null
  s3_object_version              = var.image_uri == null ? aws_s3_bucket_object.lambda_deploy_object[0].version_id : null
  image_uri                      = var.image_uri
  tags                           = var.tags
  timeout                        = var.timeout

  dynamic "vpc_config" {
    for_each = length(var.subnet_ids) > 0 ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  dynamic "environment" {
    for_each = length(var.environment) > 0 ? [1] : []
    content {
      variables = var.environment
    }
  }

  tracing_config {
    mode = "Active"
  }

  lifecycle {
    precondition {
      condition     = (var.image_uri != null && var.path == null) || (var.image_uri == null && var.path != null)
      error_message = "Cannot specify image_uri AND path"
    }
    precondition {
      condition     = (var.image_uri != null && var.handler == null) || (var.image_uri == null && var.handler != null)
      error_message = "Cannot specify image_uri AND handler"
    }
    precondition {
      condition     = (var.image_uri != null && length(var.layer_arns) == 0) || (var.image_uri == null)
      error_message = "Cannot specify image_uri AND layer_arns"
    }
    precondition {
      condition     = (var.image_uri != null && var.path == null) || (var.image_uri == null && var.path != null)
      error_message = "Cannot specify image_uri AND path"
    }
    precondition {
      condition     = (var.image_uri != null && var.runtime == null) || (var.image_uri == null && var.path != null)
      error_message = "Cannot specify image_uri AND runtime"
    }
  }

}

# An alarm to notify of function errors
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_actions       = [var.notifications_topic_arn]
  alarm_description   = "This metric monitors the error rate on the ${var.name} lambda"
  alarm_name          = "${var.name} - High Error Rate"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  threshold           = var.error_rate_alarm_threshold
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "error_rate"
    expression  = "errors/invocations*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "errors"

    metric {
      metric_name = "Errors"
      namespace   = "AWS/Lambda"
      period      = "600"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        FunctionName = aws_lambda_function.lambda.function_name
      }
    }
  }

  metric_query {
    id = "invocations"

    metric {
      metric_name = "Invocations"
      namespace   = "AWS/Lambda"
      period      = "600"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        FunctionName = aws_lambda_function.lambda.function_name
      }
    }
  }

  tags = var.tags
}

# Configure logging in Cloudwatch
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention_in_days
  tags              = var.tags
}
