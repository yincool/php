FROM php:8.1.19-fpm-alpine3.18

ADD extension.tar.gz /usr/local/etc/php/conf.d/
ADD *.tgz  /
Add swoftcli /usr/bin/swoftcli
ADD composer.phar /usr/bin/composer

RUN	sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
	apk update && \
	apk add git linux-headers zip libzip-dev libpng-dev openssl-dev autoconf gcc libc-dev libjpeg-turbo-dev freetype-dev make g++ rabbitmq-c-dev libsodium-dev libmcrypt-dev unzip gmp-dev autoconf --no-cache && \
	docker-php-ext-configure gd --with-jpeg --with-freetype && \
	docker-php-ext-install pdo_mysql mysqli zip gd sockets gmp pcntl bcmath

RUN	composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ && \
	cd /xdebug-3.2.0 && phpize && ./configure && make && make install && \
	cd /redis-5.3.7 && phpize && ./configure && make && make install && \
	cd /swoole-5.0.2 && phpize && ./configure --enable-openssl && make && make install && \
	cd /amqp-1.11.0 && phpize && ./configure && make && make install && \
	cd /libsodium-2.0.22 && phpize && ./configure && make && make install && \
	cd /mcrypt-1.0.6 && phpize && ./configure && make && make install && \
	cd /mongodb-1.15.1 && phpize && ./configure && make && make install && \
	cd /xlswriter-1.5.1 && phpize && ./configure && make && make install && \
	cd / && rm -rf xdebug* redis* swoole* amqp* libsodium* mongodb* xlswriter* mcrypt*

EXPOSE 9000
#CMD CMD [ "sh", "-c", "php-fpm" ]
CMD ["php-fpm"]
