output "messages_table_name" {
  value = module.database.table_name
}

output "lambda_role_arn" {
  value = module.iam.role_arn
}

output "post_message_lambda_arn" {
  value = module.post_message_lambda.function_arn
}

output "get_message_lambda_arn" {
  value = module.get_message_lambda.function_arn
}

output "api_base_url" {
  value = module.api.invoke_url
}
output "website_url" {
  value = "https://${module.website.cloudfront_domain}"
}