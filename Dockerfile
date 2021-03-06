FROM alpine:3.13.3 as base
MAINTAINER ROSSMANN HUNGARY

RUN apk add --update --no-cache \
    supervisor \
    tzdata \
    curl \
    nginx \
    php8 \
    php8-fpm \
    php8-bcmath \
    php8-common \
    php8-phar \
    php8-pcntl \
    php8-posix \
    php8-opcache \
    php8-exif \
    php8-fileinfo \
    php8-xml \
    php8-json \
    php8-dom \
    php8-xml \
    php8-xmlreader \
    php8-xmlwriter \
    php8-tokenizer \
    php8-simplexml \
    php8-curl \
    php8-mbstring \
    php8-iconv \
    php8-openssl \
    php8-gd \
    php8-pecl-redis \
    php8-pdo \
    php8-pdo_pgsql \
    php8-pdo_mysql \
    php8-zip \
    php8-ftp \
    php8-soap \
    php8-dom \
    php8-simplexml \
    postgresql-client \
  && rm -rf /var/cache/apk/* \
  && curl -o /usr/local/bin/composer https://getcomposer.org/composer-stable.phar \
  && chmod ugo+rx /usr/local/bin/composer \
  # PHP error log symlink
  && ln -sf /dev/stdout /var/log/php_error.log \
  && ln -s /usr/bin/php8 /usr/bin/php \
  && ln -s /usr/sbin/php-fpm8 /usr/sbin/php-fpm \
  && adduser -S www-data -G www-data \
  # Docroot
  && mkdir -p /var/www/rossmann \
  && rm -rf /var/www/rossmann/* \
  && chown -R www-data:www-data /var/www/rossmann \
  && chown -R www-data:www-data /var/log/php_error.log \
  && chmod +x /var/lib/nginx -R \
  && mkdir /var/tmp/nginx \
  && chown -R www-data:www-data /var/tmp/nginx

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/php-fpm.d/www.conf /etc/php8/php-fpm.d/www.conf

RUN mkdir -p /var/www/rossmann/
COPY . /var/www/rossmann/

RUN touch /var/log/app.log && chmod og+w /var/log/app.log

RUN sh -c "wget http://getcomposer.org/composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer"
RUN cd /var/www/rossmann/ && \
    /usr/local/bin/composer install --no-dev

RUN chown -R www-data: /var/www/rossmann/
RUN chmod -R 777 /var/www/rossmann/storage

CMD sh /var/www/rossmann/docker/startup.sh
