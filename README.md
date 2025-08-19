# aws-laravel-serverless-terraform

## Overview
A complete infrastructure-as-code solution for deploying Laravel applications serverlessly on AWS using Lambda (Bref), API Gateway, Aurora Serverless, S3, and Route 53. Includes automated CI/CD with GitLab, secure environment management, and scalable, cost-effective architecture.

## Features
- Serverless Laravel app on AWS Lambda (Bref)
- API Gateway for HTTP routing
- Aurora Serverless (RDS) for database
- S3 for file storage and Lambda layers
- Route 53 for DNS management
- Secrets Manager for environment variables
- Automated CI/CD with GitLab
- Security best practices (IAM, VPC, backups)

## Project Structure
```
AWS Project/
├── laravel-app/           # Laravel application (with Bref)
│   └── README-bref-lambda.md
├── terraform/             # Terraform IaC files
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── route53.tf
│   ├── apigateway-domain.tf
│   ├── ci-cd-migrations.tf
│   └── gitlab-ci.yml
└── README.md              # Project documentation
```

## Getting Started
### 1. Clone the Repo
```
git clone https://github.com/Sofoniasm/aws-laravel-serverless-terraform.git
```

### 2. Laravel + Bref Setup
See `laravel-app/README-bref-lambda.md` for step-by-step instructions.

### 3. Terraform Setup
- Configure variables in `terraform/variables.tf` and `terraform.tfvars`.
- Upload Bref layer zip to S3 and set bucket/key.
- (Optional) Set up ACM certificate for custom domain.

### 4. Deploy Infrastructure
```
cd terraform
terraform init
terraform apply -auto-approve
```

### 5. CI/CD Pipeline
- GitLab pipeline (`gitlab-ci.yml`) automates validation, planning, and applying Terraform.
- Add Composer install and migrations to pipeline for Laravel app.

### 6. Custom Domain
- Use Route 53 and ACM to map your domain to API Gateway.
- See `apigateway-domain.tf` for resources.

### 7. Usage
- Access your Laravel app via the API Gateway URL or custom domain.
- All Laravel routes work as usual; use S3 for file uploads and RDS for DB.

## Security & Best Practices
- IAM roles restrict access
- No direct file writes on Lambda
- Weekly backups for RDS
- Environment variables managed via Secrets Manager
- Branch protection in GitLab (manual setup)

## License
MIT
