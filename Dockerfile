FROM serversideup/php:8.4-fpm-nginx-alpine

USER root

RUN install-php-extensions \
    bcmath \
    exif \
    gd \
    intl \
    imagick \
    swoole \
    && apk upgrade \
    && apk add --update --no-cache \
    bash \
    jpegoptim optipng pngquant gifsicle libavif \
    nodejs \
    npm \
    && npm install -g pnpm \
    && npm install -g svgo \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN mkdir -p \
    storage/framework/sessions \
    storage/framework/views \
    storage/framework/cache \
    storage/framework/testing \
    storage/logs \
    storage/app \
    bootstrap/cache && chmod -R a+rw storage \
    && chown -R www-data:www-data storage

ENV ENV="/home/www-data/.bashrc"

COPY --chown=www-data:www-data .docker/config/alias.sh /home/www-data/bash-alias.sh
COPY --chown=www-data:www-data .docker/config/livewire.conf /etc/nginx/server-opts.d/livewire.conf

RUN cat /home/www-data/bash-alias.sh >> /home/www-data/.bashrc \
    && source /home/www-data/.bashrc
