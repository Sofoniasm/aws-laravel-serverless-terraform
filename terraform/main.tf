terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

module "lambda" {
  source = "terraform-aws-modules/lambda/aws"
  function_name = var.lambda_function_name
  handler       = "public/index.php"
  runtime       = "provided.al2"
  source_path   = "../laravel-app"
  layers        = [module.bref_layer.layer_arn]
  environment_variables = var.lambda_env
}

module "bref_layer" {
  source = "terraform-aws-modules/lambda/aws//modules/layer"
  layer_name = "bref-php-80"
  compatible_runtimes = ["provided.al2"]
  s3_bucket = var.layer_bucket
  s3_key    = var.layer_key
}

resource "aws_api_gateway_rest_api" "laravel_api" {
  name        = "LaravelAPI"
  description = "API Gateway for Laravel on Lambda"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.laravel_api.id
  parent_id   = aws_api_gateway_rest_api.laravel_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.laravel_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.laravel_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "POST"
  type        = "AWS_PROXY"
  uri         = module.lambda.lambda_function_invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.laravel_api.id
  stage_name  = "prod"
}

resource "aws_s3_bucket" "layer_bucket" {
  bucket = var.layer_bucket
}

resource "aws_rds_cluster" "laravel_db" {
  cluster_identifier      = "laravel-db"
  engine                 = "aurora-mysql"
  engine_mode            = "serverless"
  master_username        = var.db_username
  master_password        = var.db_password
  backup_retention_period = 7
  scaling_configuration {
    auto_pause   = true
    min_capacity = 2
    max_capacity = 8
  }
}

resource "aws_secretsmanager_secret" "env_vars" {
  name = "laravel-env-vars"
}

resource "aws_secretsmanager_secret_version" "env_vars_version" {
  secret_id     = aws_secretsmanager_secret.env_vars.id
  secret_string = jsonencode(var.lambda_env)
}

variable "aws_region" {}
variable "lambda_function_name" {}
variable "layer_bucket" {}
variable "layer_key" {}
variable "db_username" {}
variable "db_password" {}
variable "lambda_env" { type = map(string) }
