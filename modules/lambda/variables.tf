variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "handler" {
  description = "Lambda handler"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.10"
}

variable "role_arn" {
  description = "IAM role ARN for Lambda"
  type        = string
}

variable "source_path" {
  description = "Path to lambda source code directory"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for Lambda"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}