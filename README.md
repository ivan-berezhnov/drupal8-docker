# Drupal 8 docker
Create a Drupal 8 docker container for your development env. ( files taken from laravel settler: provision.sh (modified) + serve.sh )

### Install docker && docker compose
please refer to these tutorials:
* install docker (https://docs.docker.com/installation/ubuntulinux/)
```shell
curl -sSL https://get.docker.com/ | sh
```
* install docker compose (https://docs.docker.com/compose/install/)
```shell
curl -L https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

### Pull homestead image
```shell
docker pull ivan.berezhnov/drupal8-docker
```

### Clone && Edit docker-compose.yml
```shell
git clone https://github.com/ivan.berezhnov/drupal8-docker.git
```
rename ```docker-compose.dist.yml``` to ```docker-compose.yml``` then edit the file with you own
paths and ports.

### Start your containers
There are only two containers to run. web container ( includes everything except your database ),
and mariadb container.
```shell
sudo docker-compose up -d
```

# Edit down text #
### SSH into the container (password: secret):
```shell
ssh -p 2222 homestead@localhost
```

### Add a virtual host
Assuming you mapped your apps folder to ```/apps``` (you can change mappings in the docker-compose.yml file,
it's prefered to use absolute paths), you can do:
```shell
cd / && ./serve.sh myapp.dev /apps/myapp/public
```
In the host, update ``` /etc/hosts ``` to include your app domain:
```shell
127.0.0.1               myapp.dev
```

### That's it
Our web container starts nginx, php-fpm, redis, beanstalk. and has gruntjs, gulp, bower...etc
some relevant ports have been added to docker-compose.yml ( livereload standard port, karma server port ),
change them if you need to.

### Notes
- Use docker's local IP address to connect to your database. ``` ifconfig ``` to find the IP used (usually 172.17.0.1).
- Databases: by default mariadb is used as a database, but you are free to use any database you want: choose from these excellent images by Tutum: [tutum/mysql](https://github.com/tutumcloud/mysql) or [tutum/postgresql](https://github.com/tutumcloud/postgresql), they expose different environment variables, so don't forget to update your docker-compose file accordingly.
