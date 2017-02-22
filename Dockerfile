
FROM ubuntu:16.04
MAINTAINER Ivan Berezhnov <ivan.berezhnov@icloud.com>

ENV DEBIAN_FRONTEND noninteractive

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 8.2.6
ENV DRUPAL_MD5 57526a827771ea8a06db1792f1602a85

# Install packages
ADD provision.sh /provision.sh
ADD serve.sh /serve.sh

ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN chmod +x /*.sh

RUN ./provision.sh

WORKDIR /var/www/html

EXPOSE 80 22 35729 9876
#CMD ["/usr/bin/supervisord"]

curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz \
	&& chown -R www-data:www-data sites modules themes