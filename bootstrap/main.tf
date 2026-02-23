resource "aws_s3_bucket" "terraform_state" {
  bucket = "himanshu-tf-state-bucket-ap-southeast-1"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Project = "Assignment-2"
    Purpose = "TerraformState"
    Owner   = "Himanshu"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Project = "Assignment-2"
    Purpose = "TerraformLock"
  }
}