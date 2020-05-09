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
| deploy\_artifact\_key | n/a | `string` | `"deploy.zip"` | no |
| environment | Environment variables to be passed to the function | `map(string)` | `{}` | no |
| name | Name of the function | `string` | n/a | yes |
| notifications\_topic\_arn | n/a | `string` | n/a | yes |
| path | Path to the built artifact | `string` | n/a | yes |
| reserved\_concurrent\_executions | n/a | `number` | `null` | no |
| role\_arn | n/a | `string` | n/a | yes |
| runtime | n/a | `string` | n/a | yes |
| security\_group\_ids | Security groups for the function to run in | `list(string)` | `[]` | no |
| subnet\_ids | VPC subnets for the function to run in | `list(string)` | `[]` | no |
| timeout | n/a | `number` | `15` | no |

## Outputs

| Name | Description |
|------|-------------|
| function\_arn | n/a |
| function\_invoke\_arn | n/a |
| function\_name | n/a |
| function\_version | n/a |

