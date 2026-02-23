variable "bucket_name" {
  description = "S3 bucket name for website"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}