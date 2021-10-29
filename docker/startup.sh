#!/bin/sh

sed -i "s,LISTEN_PORT,$PORT,g" /etc/nginx/nginx.conf

php-fpm -D

while ! nc -w 1 -z 127.0.0.1 9000; do sleep 0.1; done;

ARTISAN=/var/www/rossmann/artisan

if [ ! -z "$LARAVEL_INIT_ENABLED" ] && [ "$LARAVEL_INIT_ENABLED" == "1" ]; then
  echo -e "\nInitialize Laravel\n"
  php $ARTISAN config:cache
  php $ARTISAN event:cache
  php $ARTISAN view:cache
fi

if [ ! -z "$LARAVEL_DB_MIGRATION_ENABLED" ] && [ "$LARAVEL_DB_MIGRATION_ENABLED" == "1" ]; then
  echo -e "\nRun database migration\n"
  php $ARTISAN migrate --force
fi

if [ ! -z "$LARAVEL_DB_SEEDER_ENABLED" ] && [ "$LARAVEL_DB_SEEDER_ENABLED" == "1" ]; then
  echo -e "\nRun database seeder\n"
  php $ARTISAN db:seed --force
fi

if [ ! -z "$PORT" ]; then
  echo -e "\nSet Nginx listen port (${PORT})\n"
  sed -i "s/80/${PORT}/g" /etc/nginx/conf.d/default.conf
fi

nginx
