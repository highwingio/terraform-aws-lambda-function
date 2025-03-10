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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | 7.2.6 |

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_sns_topic.notifications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sns_topic) | data source |
| [aws_ssm_parameter.account_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.deployment_bucket_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.global_account_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.kms_key_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_triggers"></a> [allowed\_triggers](#input\_allowed\_triggers) | n/a | `map(any)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_ecr_address"></a> [ecr\_address](#input\_ecr\_address) | n/a | `string` | n/a | yes |
| <a name="input_ecr_arn"></a> [ecr\_arn](#input\_ecr\_arn) | n/a | `string` | n/a | yes |
| <a name="input_engine_name"></a> [engine\_name](#input\_engine\_name) | n/a | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | n/a | `map(any)` | `{}` | no |
| <a name="input_event_source_mapping"></a> [event\_source\_mapping](#input\_event\_source\_mapping) | Map of event source mappings | `map(any)` | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | n/a | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | n/a | `string` | `null` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | n/a | `string` | `"latest"` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | n/a | `number` | `1024` | no |
| <a name="input_policy_statements"></a> [policy\_statements](#input\_policy\_statements) | n/a | `map(any)` | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | n/a | `string` | `"60"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | n/a |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | n/a |
| <a name="output_function_version"></a> [function\_version](#output\_function\_version) | n/a |
| <a name="output_lambda_role_arn"></a> [lambda\_role\_arn](#output\_lambda\_role\_arn) | n/a |
| <a name="output_lambda_role_name"></a> [lambda\_role\_name](#output\_lambda\_role\_name) | n/a |
| <a name="output_qualified_function_arn"></a> [qualified\_function\_arn](#output\_qualified\_function\_arn) | n/a |
