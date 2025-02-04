FROM alpine:3.9

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/phpearth/docker-php.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="PHP.earth" \
      org.label-schema.name="docker-php" \
      org.label-schema.description="Docker For PHP Developers - Docker image with PHP 7.1, OpenLiteSpeed, and Alpine" \
      org.label-schema.url="https://github.com/phpearth/docker-php"

# PHP_INI_DIR to be symmetrical with official php docker image
ENV PHP_INI_DIR /etc/php/7.1

# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

# Persistent runtime dependencies
ARG DEPS="\
        curl \
        ca-certificates \
        runit \
        php7.1 \
        php7.1-phar \
        php7.1-bcmath \
        php7.1-calendar \
        php7.1-mbstring \
        php7.1-exif \
        php7.1-ftp \
        php7.1-openssl \
        php7.1-zip \
        php7.1-sysvsem \
        php7.1-sysvshm \
        php7.1-sysvmsg \
        php7.1-shmop \
        php7.1-sockets \
        php7.1-zlib \
        php7.1-bz2 \
        php7.1-curl \
        php7.1-simplexml \
        php7.1-xml \
        php7.1-opcache \
        php7.1-dom \
        php7.1-xmlreader \
        php7.1-xmlwriter \
        php7.1-tokenizer \
        php7.1-ctype \
        php7.1-session \
        php7.1-fileinfo \
        php7.1-iconv \
        php7.1-json \
        php7.1-gd \
        php7.1-intl \
        php7.1-pdo \
        php7.1-mysqli \
        php7.1-soap \
        php7.1-posix \
        php7.1-litespeed \
        litespeed \
"

# PHP.earth Alpine repository for better developer experience
ADD https://repos.php.earth/alpine/phpearth.rsa.pub /etc/apk/keys/phpearth.rsa.pub

RUN set -x \
    && echo "https://repos.php.earth/alpine/v3.9" >> /etc/apk/repositories \
    && apk add --no-cache $DEPS \
    && ln -sf /dev/stdout /var/lib/litespeed/logs/access.log \
    && ln -sf /dev/stderr /var/lib/litespeed/logs/error.log

COPY tags/litespeed /

EXPOSE 8088 7080

CMD ["/sbin/runit-wrapper"]
