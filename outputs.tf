output "invoke_url_default" {
  value = aws_api_gateway_stage.lambda.invoke_url
}

output "invoke_url_custom" {
  value = "https://${aws_api_gateway_domain_name.this.domain_name}"
}
