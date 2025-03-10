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
  description = coalesce(var.description, "Highwing Engine - ${title(var.engine_name)}")
  handler     = coalesce(var.handler, "engines/${var.engine_name}/lambda.handler")

  environment = data.aws_ssm_parameter.account_name.value
  environment_variables = (
    startswith(local.environment, "production")
    ? var.environment_variables
    : merge(var.environment_variables, {
      DEV_MODE_ENABLED = true
    })
  )
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.6"

  function_name = var.function_name
  description   = local.description
  handler       = local.handler
  memory_size   = var.memory_size
  publish       = true
  timeout       = var.timeout

  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = var.security_group_ids

  attach_cloudwatch_logs_policy = true
  attach_dead_letter_policy     = true
  attach_network_policy         = true
  attach_tracing_policy         = true

  allowed_triggers = var.allowed_triggers

  number_of_policies = 2
  policies = [
    "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
  ]
  attach_policies = true

  attach_policy_statements = length(var.policy_statements) > 0 ? true : false
  policy_statements = merge(var.policy_statements, {
    ecr = {
      effect = "Allow"
      actions = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]
      resources = [var.ecr_arn]
    }
  })

  cloudwatch_logs_retention_in_days = 1096
  dead_letter_target_arn            = data.aws_sns_topic.notifications.arn
  kms_key_arn                       = data.aws_ssm_parameter.kms_key_arn.value
  tracing_mode                      = "Active"

  create_package = false
  image_uri      = "${var.ecr_address}:lambda_${var.image_tag}"
  package_type   = "Image"
  architectures  = ["x86_64"]

  event_source_mapping = var.event_source_mapping

  environment_variables = merge(local.environment_variables, {
    DD_SERVICE = replace(var.function_name, "-", "_")
  })
}

