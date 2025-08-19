variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "laravel-app"
}

variable "layer_bucket" {
  description = "S3 bucket for Lambda layer"
  type        = string
}

variable "layer_key" {
  description = "S3 key for Lambda layer zip"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
}

variable "lambda_env" {
  description = "Environment variables for Lambda"
  type        = map(string)
}
