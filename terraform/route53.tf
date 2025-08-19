resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_api_gateway_deployment.api_deployment.invoke_url
    zone_id                = aws_api_gateway_deployment.api_deployment.rest_api_id
    evaluate_target_health = false
  }
}

variable "domain_name" {
  description = "The domain name for Route 53"
  type        = string
}
