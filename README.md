# terraform-aws-lambda-function
Terraform module for a Lambda function with a standard configuration

## Usage

```hcl
module "my_lambda" {
  source             = "github.com/highwingio/terraform-aws-lambda-function?ref=master"
  # Other arguments here...
}
```

## Updating the README

This repo uses [terraform-docs](https://github.com/segmentio/terraform-docs) to autogenerate its README.

To regenerate, run this command:

```bash
$ terraform-docs markdown table . > README.md
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.lambda_errors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_networking](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_xray](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_s3_bucket.lambda_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.lambda_deploy_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_policy.lambda_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.lambda_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.lambda_deploy_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the Lambda Function | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variables to be passed to the function | `map(string)` | `{}` | no |
| <a name="input_error_rate_alarm_threshold"></a> [error\_rate\_alarm\_threshold](#input\_error\_rate\_alarm\_threshold) | Error rate (in percent, 1-100) at which to trigger an alarm notification | `number` | `25` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Name of the handler function inside the artifact (https://docs.aws.amazon.com/lambda/latest/dg/configuration-console.html) | `string` | n/a | yes |
| <a name="input_layer_arns"></a> [layer\_arns](#input\_layer\_arns) | List of ARNs for layers to use with the function | `list(string)` | `[]` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Number of days to keep function logs in Cloudwatch | `number` | `365` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory (in MB) to allocate to the function | `number` | `128` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the function | `string` | n/a | yes |
| <a name="input_notifications_topic_arn"></a> [notifications\_topic\_arn](#input\_notifications\_topic\_arn) | SNS topic to send error notifications | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | Local path to a zipped artifact containing the function code | `string` | n/a | yes |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Reserved concurrent executions (none by default) | `number` | `null` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the execution role for the function. It does not need to include logging/networking permissions - those policies will be added automatically. | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Language runtime for the function (https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html) | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security groups for the function (if run in a VPC) | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnets for the function (if run in a VPC) | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to created resources | `map(any)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Function timeout in seconds | `number` | `15` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | ARN of the created/updated Lambda function |
| <a name="output_function_invoke_arn"></a> [function\_invoke\_arn](#output\_function\_invoke\_arn) | ARN for invoking the created Lambda function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the created Lambda function |
| <a name="output_function_version"></a> [function\_version](#output\_function\_version) | Version of the created/updated Lambda function |
