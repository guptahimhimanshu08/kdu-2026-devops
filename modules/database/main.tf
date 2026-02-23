resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "messageId"

  attribute {
    name = "messageId"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags = var.tags
}