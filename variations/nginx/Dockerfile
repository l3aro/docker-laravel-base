ARG PHP_VERSION="8.5"

FROM serversideup/php:${PHP_VERSION}-fpm-nginx

USER root

RUN install-php-extensions \
    bcmath \
    exif \
    gd \
    intl \
    imagick \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    jpegoptim optipng pngquant gifsicle libavif-bin \
    nodejs \
    npm \
    && npm install -g pnpm \
    && npm install -g svgo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p \
    storage/framework/sessions \
    storage/framework/views \
    storage/framework/cache \
    storage/framework/testing \
    storage/logs \
    storage/app \
    bootstrap/cache && chmod -R a+rw storage \
    && chown -R www-data:www-data storage

ENV ENV="/var/www/.bashrc"

COPY .docker /package/custom/

RUN cp /package/custom/config/alias.sh /var/www/bash-alias.sh
RUN chown www-data:www-data /var/www/bash-alias.sh

RUN cp /package/custom/config/livewire.conf /etc/nginx/server-opts.d/livewire.conf
RUN chown www-data:www-data /etc/nginx/server-opts.d/livewire.conf

RUN cat /var/www/bash-alias.sh >> /var/www/.bashrc \
    && bash -lc "source /var/www/.bashrc"

RUN usermod -s /bin/bash www-data
