
FROM php:7.0-apache
MAINTAINER Ivan Berezhnov <ivan.berezhnov@icloud.com>

RUN a2enmod rewrite

# Install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev curl nano \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql zip

RUN docker-php-ext-install json
RUN docker-php-ext-enable json

# Enable and configure xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Set recommended PHP.ini settings
# See https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Enable Remote xdebug
RUN echo xdebug.remote_autostart=true >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.remote_mode=req >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.remote_handler=dbgp >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.remote_connect_back=1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.remote_port=9000 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo xdebug.remote_host=127.0.0.1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.idekey=PHPSTORM >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.remote_enable=1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.profiler_append=0 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.profiler_enable=0 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.profiler_enable_trigger=1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.profiler_output_dir=/var/debug >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.profiler_output_name=cachegrind.out.%s.%u >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.var_display_max_data=-1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.var_display_max_children=-1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo xdebug.var_display_max_depth=-1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 8.2.6
ENV DRUPAL_MD5 57526a827771ea8a06db1792f1602a85

# Download Drupal8
RUN curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz \
	&& chown -R www-data:www-data sites modules themes

# Install packages
ADD provision.sh /provision.sh
RUN chmod +x /*.sh
RUN /provision.sh
