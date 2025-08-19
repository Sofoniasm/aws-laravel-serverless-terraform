output "lambda_function_arn" {
  value = module.lambda.lambda_function_arn
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}

output "rds_cluster_endpoint" {
  value = aws_rds_cluster.laravel_db.endpoint
}
