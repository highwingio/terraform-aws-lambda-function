data "aws_region" "current" {}

data "aws_ssm_parameter" "account_name" {
  name = "/account/name"
}

data "aws_sns_topic" "notifications" {
  name = "account-notifications"
}

data "aws_ssm_parameter" "deployment_bucket_id" {
  name = "/account/DEPLOYMENT_BUCKET_ID"
}

data "aws_ssm_parameter" "kms_key_arn" {
  name = "/account/KMS_KEY_ARN"
}

data "aws_ssm_parameter" "global_account_id" {
  name = "/global/account_id"
}
