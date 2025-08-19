# Deploying Laravel on AWS Lambda with Bref & API Gateway

## Prerequisites
- Composer
- AWS CLI
- Terraform
- Bref layer zip uploaded to S3

## Steps

### 1. Create Laravel Project
```
composer create-project --prefer-dist laravel/laravel .
```

### 2. Install Bref
```
composer require bref/bref
```

### 3. Configure Lambda Handler
- Ensure `public/index.php` is the entry point.
- Add Bref runtime to `composer.json` scripts if needed.

### 4. Environment Variables
- Store sensitive variables in AWS Secrets Manager.
- Use Terraform to inject them into Lambda.

### 5. Database
- Use RDS Aurora Serverless endpoint from Terraform output.
- Set DB credentials in `.env` or via Secrets Manager.

### 6. File Storage
- Use AWS S3 for file uploads/storage.
- Configure Laravel filesystem to use S3 driver.

### 7. Deploy with Terraform
```
cd ../terraform
terraform init
terraform apply -auto-approve
```

### 8. Access Your App
- Use the API Gateway URL from Terraform output.
- Point your domain to API Gateway using Route 53.

### 9. Composer/Migration on Deployment
- Run `composer install` and `php artisan migrate` locally before packaging/deploying.
- Or automate in CI/CD pipeline.

### 10. Updating Code
- Push changes to GitLab.
- CI/CD pipeline will deploy via Terraform.

## Notes
- Lambda is stateless: use S3 for files, RDS for DB.
- Use environment variables for secrets/config.
- Monitor logs via AWS CloudWatch.
