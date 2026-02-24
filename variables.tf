variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_app_subnets" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)
}

variable "db_subnets" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
}

variable "allowed_ssh_cidr" {
  type = list(string)
}
variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "key_name" {
  type = string
}

variable "alb_enabled" {
  type    = bool
  default = true
}
variable "db_endpoint" {
  type = string
}