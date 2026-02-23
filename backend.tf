terraform {
  backend "s3" {
    bucket         = "himanshu-tf-state-bucket-ap-southeast-1"
    key            = "assignment-2/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}