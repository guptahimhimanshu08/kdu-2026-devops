############################
# Data Sources
############################
data "aws_region" "current" {}

############################
# REST API
############################
resource "aws_api_gateway_rest_api" "this" {
  name = var.api_name
  tags = var.tags
}

############################
# Resources
############################
resource "aws_api_gateway_resource" "message" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "message"
}

resource "aws_api_gateway_resource" "messages" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "messages"
}

############################
# POST /message
############################
resource "aws_api_gateway_method" "post_message" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.message.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_message" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = aws_api_gateway_method.post_message.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.post_lambda_arn}/invocations"
}

resource "aws_lambda_permission" "post_message" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.post_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

############################
# GET /messages
############################
resource "aws_api_gateway_method" "get_messages" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.messages.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_messages" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.messages.id
  http_method = aws_api_gateway_method.get_messages.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.get_lambda_arn}/invocations"
}

resource "aws_lambda_permission" "get_messages" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

############################
# CORS — OPTIONS /message
############################
resource "aws_api_gateway_method" "cors_message" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.message.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_message" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = aws_api_gateway_method.cors_message.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "cors_message_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = aws_api_gateway_method.cors_message.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "cors_message_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = aws_api_gateway_method.cors_message.http_method
  status_code = aws_api_gateway_method_response.cors_message_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }
}

############################
# CORS — OPTIONS /messages
############################
resource "aws_api_gateway_method" "cors_messages" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.messages.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_messages" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.messages.id
  http_method = aws_api_gateway_method.cors_messages.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "cors_messages_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.messages.id
  http_method = aws_api_gateway_method.cors_messages.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "cors_messages_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.messages.id
  http_method = aws_api_gateway_method.cors_messages.http_method
  status_code = aws_api_gateway_method_response.cors_messages_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }
}

############################
# Deployment & Stage
############################
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [
    aws_api_gateway_integration.post_message,
    aws_api_gateway_integration.get_messages,
    aws_api_gateway_integration.cors_message,
    aws_api_gateway_integration.cors_messages
  ]
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
}