resource "aws_api_gateway_domain_name" "custom" {
  domain_name = var.api_custom_domain
  regional_certificate_arn = var.certificate_arn
}

resource "aws_api_gateway_base_path_mapping" "custom" {
  api_id      = aws_api_gateway_rest_api.laravel_api.id
  stage_name  = aws_api_gateway_deployment.api_deployment.stage_name
  domain_name = aws_api_gateway_domain_name.custom.domain_name
}

resource "aws_route53_record" "custom_api" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.api_custom_domain
  type    = "A"
  alias {
    name                   = aws_api_gateway_domain_name.custom.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.custom.regional_zone_id
    evaluate_target_health = false
  }
}

variable "api_custom_domain" {
  description = "Custom domain for API Gateway"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for the custom domain"
  type        = string
}
