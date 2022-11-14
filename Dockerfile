FROM php:alpine3.14

RUN apk --no-cache add jq git

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV COMPOSER_HOME=/root/.composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_NO_INTERACTION 1

# Allow running plugins for this specific package
# See https://github.com/PHPCSStandards/composer-installer#usage
RUN composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true

# Install phpcs
RUN composer global require --dev \
    "squizlabs/php_codesniffer" \
    "dealerdirect/phpcodesniffer-composer-installer" \
    "object-calisthenics/phpcs-calisthenics-rules" \
    "phpcompatibility/php-compatibility" \
    "wp-coding-standards/wpcs"

ENV PATH $PATH:$COMPOSER_HOME/vendor/bin

# Install reviewdog
ENV REVIEWDOG_VERSION=v0.13.1
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
