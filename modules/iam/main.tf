resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

# CloudWatch Logs permissions (basic Lambda requirement)
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom DynamoDB policy (least privilege)
resource "aws_iam_policy" "dynamodb_access" {
  name = "${var.role_name}-dynamodb-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:PutItem",
        "dynamodb:Scan"
      ]
      Resource = var.dynamodb_table_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}