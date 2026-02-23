output "api_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.this.execution_arn
}

output "invoke_url" {
  value = aws_api_gateway_stage.prod.invoke_url
}