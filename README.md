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

The README is built using [terraform-docs](https://github.com/segmentio/terraform-docs).

To regenerate, run this command:

```bash
$ terraform-docs markdown --header-from ./README.tmpl.md . > README.md
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment variables to be passed to the function | `map(string)` | `{}` | no |
| memory\_size | Amount of memory (in MB) to allocate to the function | `number` | `128` | no |
| name | Name for the function | `string` | n/a | yes |
| notifications\_topic\_arn | SNS topic to send error notifications | `string` | n/a | yes |
| path | Local path to a zipped artifact containing the function code | `string` | n/a | yes |
| reserved\_concurrent\_executions | Reserved concurrent executions (none by default) | `number` | `null` | no |
| role\_arn | Execution role for the function | `string` | n/a | yes |
| runtime | Language runtime for the function (https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html) | `string` | n/a | yes |
| security\_group\_ids | Security groups for the function (if run in a VPC) | `list(string)` | `[]` | no |
| subnet\_ids | Subnets for the function (if run in a VPC) | `list(string)` | `[]` | no |
| timeout | Function timeout in seconds | `number` | `15` | no |

## Outputs

| Name | Description |
|------|-------------|
| function\_arn | ARN of the created/updated Lambda function |
| function\_invoke\_arn | ARN for invoking the created Lambda function |
| function\_name | Name of the created Lambda function |
| function\_version | Version of the created/updated Lambda function |

