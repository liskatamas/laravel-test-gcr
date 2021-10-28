#!/bin/sh

sed -i "s,LISTEN_PORT,$PORT,g" /etc/nginx/nginx.conf

php-fpm -D

while ! nc -w 1 -z 127.0.0.1 9000; do sleep 0.1; done;

if [ ! -z "$LARAVEL_INIT_ENABLED" ] && [ "$LARAVEL_INIT_ENABLED" == "1" ]; then
  echo -e "\nInitialize Laravel\n"
  php artisan config:cache
  php artisan event:cache
  php artisan view:cache
fi

if [ ! -z "$LARAVEL_DB_MIGRATION_ENABLED" ] && [ "$LARAVEL_DB_MIGRATION_ENABLED" == "1" ]; then
  echo -e "\nRun database migration\n"
  php artisan migrate --force
  php artisan elastic:migrate
fi

if [ ! -z "$LARAVEL_DB_SEEDER_ENABLED" ] && [ "$LARAVEL_DB_SEEDER_ENABLED" == "1" ]; then
  echo -e "\nRun database seeder\n"
  php artisan db:seed --force
fi

if [ ! -z "$PORT" ]; then
  echo -e "\nSet Nginx listen port (${PORT})\n"
  sed -i "s/80/${PORT}/g" /etc/nginx/conf.d/default.conf
fi

nginx
