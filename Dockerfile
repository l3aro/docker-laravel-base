FROM serversideup/php:8.4-fpm-nginx-alpine

USER root

RUN install-php-extensions \
    bcmath \
    exif \
    gd \
    intl \
    imagick \
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

FROM base AS dev

RUN apk add --no-cache \
    tmux \
    git \
    vim \
    screen \
    openssh \
    lazygit

# ARG USER_ID
# ARG GROUP_ID

# RUN docker-php-serversideup-set-id www-data $USER_ID:$GROUP_ID && \
#     docker-php-serversideup-set-file-permissions --owner $USER_ID:$GROUP_ID --service nginx

USER www-data

COPY --chown=www-data:www-data .docker/config/.tmux.conf /home/www-data/.tmux.conf
COPY --chown=www-data:www-data .docker/config/.vimrc /home/www-data/.vimrc

FROM base AS prod

WORKDIR /var/www/html

USER root

RUN rm -f public/hot

# COPY --chown=www-data:www-data .docker/config/http.conf /etc/nginx/site-opts.d/http.conf
# COPY --chown=www-data:www-data .docker/config/connection.conf /etc/nginx/conf.d/connection.conf
COPY --chmod=755 .docker/entrypoint.d/ /etc/entrypoint.d/

COPY --chown=www-data:www-data . /var/www/html

ENV AUTORUN_ENABLED=true
ENV PHP_OPCACHE_ENABLE=1
ENV AUTORUN_LARAVEL_MIGRATION_ISOLATION=true

USER www-data
