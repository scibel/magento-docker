FROM richarvey/nginx-php-fpm:1.3.10

ENV REMOVE_FILES=0
ENV SKIP_COMPOSER=1
ENV SKIP_CHOWN=1

ENV ENABLE_XDEBUG=1
ENV ERRORS=1
ENV PHP_ERRORS_STDERR=1

COPY config/certificates /usr/local/share/ca-certificates
RUN update-ca-certificates

RUN apk add --update autoconf g++ libtool make pcre-dev

RUN docker-php-ext-configure bcmath \
    && docker-php-ext-install bcmath

RUN apk add imagemagick-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN apk del autoconf g++ libtool make pcre-dev

ADD config/php/mail.ini /usr/local/etc/php/conf.d/mail.ini

# Certificates are imported for installation purpose only.
# In order to keep this image generic, ca-certificates directory
# should be replaced using volumes.
RUN rm /usr/local/share/ca-certificates/*

ADD script/dev-start.sh /dev-start.sh

CMD ["/dev-start.sh"]
