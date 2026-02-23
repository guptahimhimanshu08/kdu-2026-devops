module "database" {
  source = "./modules/database"

  table_name = "${var.project_name}-messages"
  tags       = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  role_name           = "${var.project_name}-lambda-role"
  dynamodb_table_arn  = module.database.table_arn
  tags                = local.common_tags
}

module "post_message_lambda" {
  source = "./modules/lambda"

  function_name = "himanshu-post-message"
  handler       = "index.handler"
  role_arn      = module.iam.role_arn
  source_path   = "./lambda/postMessage"

  environment_variables = {
    TABLE_NAME = module.database.table_name
  }

  tags = local.common_tags
}

module "get_message_lambda" {
  source = "./modules/lambda"

  function_name = "himanshu-get-message"
  handler       = "index.handler"
  role_arn      = module.iam.role_arn
  source_path   = "./lambda/getMessage"

  environment_variables = {
    TABLE_NAME = module.database.table_name
  }

  tags = local.common_tags
}

module "api" {
  source = "./modules/api"

  api_name        = "himanshu-serverless-api"
  get_lambda_arn  = module.get_message_lambda.function_arn
  post_lambda_arn = module.post_message_lambda.function_arn
  tags            = local.common_tags
}

module "website" {
  source = "./modules/website"

  bucket_name = "himanshu-serverless-website-${var.environment}"
  tags        = local.common_tags
}