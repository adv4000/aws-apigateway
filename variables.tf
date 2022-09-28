variable "api_gateway_custom_domain" {
  description = "Domain Name for API Gateway to use"
  default     = "astahov.net"
}

variable "api_gateway_custom_domain_certificate_arn" {
  description = "Certificate ARN which cover [api_gateway_custom_domain]"
  default     = "arn:aws:acm:us-west-2:11111111111:certificate/222222-44444-55555-667-45653333"
}

variable "tags" {
  description = "Tags to apply to Resources"
  default = {
    Owner   = "Denis Astahov"
    Company = "ADV-IT"
  }
}

variable "name" {
  description = "Name to use for Resources"
  default     = "Serverless-APIGateway-Lambda"
}
