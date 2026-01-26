ARG PHP_VERSION="8.5"

FROM serversideup/php:${PHP_VERSION}-cli

COPY --from=oven/bun:1 /usr/local/bin/bun /usr/local/bin/bun

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
    && ln -s /usr/local/bin/bun /usr/local/bin/bunx \
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

COPY .docker /package/custom/
