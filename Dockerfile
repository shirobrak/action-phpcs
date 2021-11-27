FROM php:alpine3.14

RUN apk --no-cache add jq git

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV COMPOSER_HOME=/root/.composer

ENV COMPOSER_ALLOW_SUPERUSER 1

ENV COMPOSER_NO_INTERACTION 1

RUN composer global require --dev \
    "squizlabs/php_codesniffer" \
    "dealerdirect/phpcodesniffer-composer-installer" \
    "object-calisthenics/phpcs-calisthenics-rules" \
    "phpcompatibility/php-compatibility" \
    "wp-coding-standards/wpcs"

ENV PATH $PATH:$COMPOSER_HOME/vendor/bin

ENV REVIEWDOG_VERSION=v0.13.0

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]