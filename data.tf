data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "deployment_bucket_id" {
  name = "/account/DEPLOYMENT_BUCKET_ID"
}
