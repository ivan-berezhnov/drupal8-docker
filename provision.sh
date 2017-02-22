#!/usr/bin/env bash

curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin \
&& composer global require drupal/coder \
&& ln -s /root/.composer/vendor/squizlabs/php_codesniffer/scripts/phpcs /usr/bin/phpcs \
&& ln -s /root/.composer/vendor/squizlabs/php_codesniffer/scripts/phpcbf /usr/bin/phpcbf \
&& ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/Drupal /root/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/Drupal \
&& ln -s /root/.composer/vendor/drupal/coder/coder_sniffer/DrupalPractice /root/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/DrupalPractice \
&& git clone --branch master https://git.drupal.org/sandbox/coltrane/1921926.git /root/drupalsecure_code_sniffs \
&& cd /root/drupalsecure_code_sniffs && curl https://www.drupal.org/files/issues/parenthesis_closer_notice-2320623-2.patch | git apply && cd \
&& apk del --no-cache git \
&& rm -rf /root/.composer/cache/* \
&& ln -s /root/drupalsecure_code_sniffs/DrupalSecure /root/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/DrupalSecure


curl https://drupalconsole.com/installer -L -o drupal.phar
mv drupal.phar /usr/local/bin/drupal
chmod +x /usr/local/bin/drupal

composer global require drupal/console:@stable
echo "PATH=$PATH:~/.composer/vendor/bin" >> ~/.bash_profile
composer global require drupal/console:~1.0 --prefer-dist --optimize-autoloader
composer update drupal/console --with-dependencies

# Download latest stable release using the code below or browse to github.com/drush-ops/drush/releases.
php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush
# Or use our upcoming release: php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush-unstable.phar');" > drush

# Make `drush` executable as a command from anywhere. Destination can be anywhere on $PATH.
chmod +x drush
mv drush /usr/local/bin
