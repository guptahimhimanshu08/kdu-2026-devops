variable "vpc_id" {
  description = "VPC ID where security groups are created"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev/prod)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH into the bastion host"
  type        = list(string)
}