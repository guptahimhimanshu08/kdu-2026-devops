variable "api_name" {
  description = "API Gateway name"
  type        = string
}

variable "get_lambda_arn" {
  description = "ARN of getMessage Lambda"
  type        = string
}

variable "post_lambda_arn" {
  description = "ARN of postMessage Lambda"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}