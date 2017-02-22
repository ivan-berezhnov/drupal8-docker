FROM php:7.0-apache
MAINTAINER Ivan Berezhnov <ivan.berezhnov@icloud.com>

# Install packages
#ADD provision.sh /provision.sh
#ADD serve.sh /serve.sh

#ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf

#RUN chmod +x /*.sh

#RUN /provision.sh


# Force Locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale \
    && locale-gen en_US.UTF-8 \
    && export LANG=en_US.UTF-8

# Timezone
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# PHP
RUN apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql zip memcached xdebug pear soap

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini


WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 8.2.6
ENV DRUPAL_MD5 57526a827771ea8a06db1792f1602a85

# Download Drupal 8
curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz \
	&& chown -R www-data:www-data sites modules themes
EXPOSE 80 22 35729 9876