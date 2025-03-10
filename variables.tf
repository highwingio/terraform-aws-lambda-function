variable "allowed_triggers" {
  type    = map(any)
  default = {}
}

variable "engine_name" {
  type = string
}

variable "function_name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "ecr_address" {
  type = string
}

variable "ecr_arn" {
  type = string
}

variable "environment_variables" {
  type    = map(any)
  default = {}
}

variable "event_source_mapping" {
  description = "Map of event source mappings"
  type        = map(any)
  default     = {}
}

variable "handler" {
  type    = string
  default = null
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "memory_size" {
  type    = number
  default = 1024
}

variable "policy_statements" {
  type    = map(any)
  default = {}
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "timeout" {
  type    = string
  default = "60"
}
