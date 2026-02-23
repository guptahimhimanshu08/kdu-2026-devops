variable "project_name" {
  description = "Project name for tagging and naming"
  type        = string
  default     = "assignment-2-serverless"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "Himanshu"
}