resource "null_resource" "composer_migrate" {
  provisioner "local-exec" {
    command = "cd ../laravel-app && composer install && php artisan migrate --force"
  }
  triggers = {
    app_version = sha1(filebase64("../laravel-app/composer.lock"))
  }
}
