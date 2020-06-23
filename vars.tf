variable "environment" {
  default     = {}
  description = "Environment variables to be passed to the function"
  type        = map(string)
}

variable "handler" {
  description = "Name of the handler function inside the artifact (https://docs.aws.amazon.com/lambda/latest/dg/configuration-console.html)"
  type        = string
}

variable "layers" {
  description = "List of Lambda Layer ARNs to apply to the function"
  type        = list(string)
  default     = []
}

variable "log_retention_in_days" {
  description = "Number of days to keep function logs in Cloudwatch"
  type        = number
  default     = 7
}

variable "memory_size" {
  description = "Amount of memory (in MB) to allocate to the function"
  type        = number
  default     = 128
}

variable "name" {
  description = "Name for the function"
  type        = string
}

variable "notifications_topic_arn" {
  description = "SNS topic to send error notifications"
  type        = string
}

variable "path" {
  description = "Local path to a zipped artifact containing the function code"
  type        = string
}

variable "reserved_concurrent_executions" {
  type        = number
  description = "Reserved concurrent executions (none by default)"
  default     = null
}

variable "role_name" {
  description = "Name of the execution role for the function. It does not need to include logging/networking permissions - those policies will be added automatically."
  type        = string
}

variable "runtime" {
  type        = string
  description = "Language runtime for the function (https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for the function (if run in a VPC)"
  default     = []
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for the function (if run in a VPC)"
  default     = []
}

variable "timeout" {
  type        = number
  description = "Function timeout in seconds"
  default     = 15
}
