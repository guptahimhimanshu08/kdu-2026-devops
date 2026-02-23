variable "role_name" {
  description = "IAM role name for Lambda"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN of DynamoDB table Lambda can access"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}