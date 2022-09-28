resource "aws_api_gateway_domain_name" "this" {
  domain_name              = "api.${var.api_gateway_custom_domain}"
  regional_certificate_arn = var.api_gateway_custom_domain_certificate_arn
  security_policy          = "TLS_1_2"
  tags                     = var.tags

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Get HostedZone details for Domain name
data "aws_route53_zone" "datalake" {
  name         = var.api_gateway_custom_domain
  private_zone = false
}

# Register Custom Domain name in Route53
resource "aws_route53_record" "apigateway" {
  name    = aws_api_gateway_domain_name.this.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.datalake.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.this.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.this.regional_zone_id
  }
}
