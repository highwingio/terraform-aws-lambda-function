variable "deploy_artifact_key" {
  default = "deploy.zip"
  type    = string
}

variable "environment" {
  default     = {}
  description = "Environment variables to be passed to the function"
  type        = map(string)
}

variable "name" {
  description = "Name of the function"
  type        = string
}

variable "notifications_topic_arn" {
  type = string
}

variable "path" {
  description = "Path to the built artifact"
  type        = string
}

variable "reserved_concurrent_executions" {
  type    = number
  default = null
}

variable "role_arn" {
  type = string
}

variable "runtime" {
  type = string
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for the function to run in"
  default     = []
}

variable "subnet_ids" {
  type        = list(string)
  description = "VPC subnets for the function to run in"
  default     = []
}

variable "timeout" {
  type    = number
  default = 15
}
