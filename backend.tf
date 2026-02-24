terraform {
  backend "s3" {
    bucket         = "himanshu-tf-state-bucket"
    key            = "three-tier/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "himanshu-tf-lock-ddb"
    encrypt        = true
  }
}