# terraform-lambda-function
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
