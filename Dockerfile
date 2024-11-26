FROM php:8.2-fpm-alpine AS php

RUN apk add --no-cache unzip libpq-dev gnutls-dev autoconf build-base \
    curl-dev nginx supervisor shadow bash
RUN docker-php-ext-install pdo pdo_mysql opcache
RUN pecl install pcov && docker-php-ext-enable pcov

WORKDIR /app

COPY docker/php/php.ini $PHP_INI_DIR/
COPY docker/php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker/php/conf.d/opcache.ini $PHP_INI_DIR/conf.d/opcache.ini

RUN addgroup --system --gid 1000 customgroup
RUN adduser --system --ingroup customgroup --uid 1000 customuser

COPY docker/nginx/nginx.conf docker/nginx/fastcgi_params docker/nginx/fastcgi_fpm docker/nginx/gzip_params /etc/nginx/
RUN mkdir -p /var/lib/nginx/tmp /var/log/nginx
RUN /usr/sbin/nginx -t -c /etc/nginx/nginx.conf

RUN chown -R customuser:customgroup /var/lib/nginx /var/log/nginx
RUN chown -R customuser:customgroup /usr/local/etc/php-fpm.d

COPY docker/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

COPY --chown=customuser:customgroup . .
RUN chown -R customuser:customgroup /app
RUN chmod +w /app/public
RUN chown -R customuser:customgroup /var /run

RUN passwd -l root
RUN usermod -s /usr/sbin/nologin root

USER customuser
COPY --from=composer:2.7.6 /usr/bin/composer /usr/bin/composer

ENTRYPOINT ["docker/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]