resource "aws_api_gateway_rest_api" "lambda" {
  name        = "${var.name}-api"
  description = "API for AWS Lambda"
  tags        = var.tags
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  disable_execute_api_endpoint = true
}

resource "aws_api_gateway_method" "lambda" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_rest_api.lambda.root_resource_id
  rest_api_id   = aws_api_gateway_rest_api.lambda.id
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.lambda.id
  resource_id             = aws_api_gateway_rest_api.lambda.root_resource_id
  http_method             = aws_api_gateway_method.lambda.http_method
  integration_http_method = "POST" #  Lambda function can only be invoked via POST
  type                    = "AWS"
  uri                     = aws_lambda_function.this.invoke_arn
  content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.lambda.id
  resource_id = aws_api_gateway_rest_api.lambda.root_resource_id
  http_method = aws_api_gateway_method.lambda.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.lambda.id
  resource_id = aws_api_gateway_rest_api.lambda.root_resource_id
  http_method = aws_api_gateway_method.lambda.http_method
  status_code = aws_api_gateway_method_response.lambda.status_code
  depends_on  = [aws_api_gateway_integration.lambda]
}


resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.lambda.execution_arn}/*"
}

resource "aws_api_gateway_deployment" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.lambda.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.lambda.id,
      aws_api_gateway_integration.lambda.id,
      aws_api_gateway_method_response.lambda,
      aws_api_gateway_integration_response.lambda,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "lambda" {
  deployment_id = aws_api_gateway_deployment.lambda.id
  rest_api_id   = aws_api_gateway_rest_api.lambda.id
  stage_name    = "run" # Any Name you wish
  tags          = var.tags
}

resource "aws_api_gateway_base_path_mapping" "lambda" {
  domain_name = aws_api_gateway_domain_name.this.domain_name
  api_id      = aws_api_gateway_rest_api.lambda.id
  stage_name  = aws_api_gateway_stage.lambda.stage_name
  base_path   = null # null means root of api domain name
}
