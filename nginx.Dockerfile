FROM ubuntu:14.04
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root
RUN echo 'root:docker123' | chpasswd
RUN sed -i 's@archive.ubuntu.com@mirror.kakao.com@g' /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo net-tools sasl2-bin fcitx-hangul wget curl \
    ca-certificates openssh-server vim git build-essential g++
RUN apt-get install -y libfcgi-dev libfcgi0ldbl libjpeg62-dbg libmcrypt-dev libssl-dev libbz2-dev libjpeg-dev \
    libfreetype6-dev libpng12-dev libxpm-dev libxml2-dev libpcre3-dev libbz2-dev libcurl4-openssl-dev \
    libjpeg-dev libpng12-dev libxpm-dev libfreetype6-dev libmysqlclient-dev libt1-dev libgd2-xpm-dev \
    libgmp-dev libsasl2-dev libmhash-dev unixodbc-dev freetds-dev libpspell-dev libsnmp-dev libtidy-dev \
    libxslt1-dev libmcrypt-dev libdb5.3-dev
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# nginx 1.16.0 설치
RUN wget -O /root/nginx_signing.key http://nginx.org/keys/nginx_signing.key
RUN apt-key add /root/nginx_signing.key
RUN echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list
RUN echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y nginx

# php 5.3.29 컴파일 설치
RUN mkdir /usr/include/freetype2/freetype
RUN ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h

# RUN wget -O /root/php-5.3.29.tar.gz http://kr1.php.net/get/php-5.3.29.tar.gz/from/this/mirror
COPY front-web/php/php-5.3.29.tar.gz /root/php-5.3.29.tar.gz
RUN tar xvf /root/php-5.3.29.tar.gz -C /root

WORKDIR /root/php-5.3.29
RUN /root/php-5.3.29/configure --with-mysql=/usr/local/mysql \
    --with-mysqli \
    --with-gd \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib-dir=/usr/local/zlib \
    --with-freetype-dir \
    --enable-ftp \
    --enable-sockets \
    --enable-mbstring \
    --disable-debug \
    --with-tsrm-pth \
    --with-config-file-path=/usr/local/php/etc \
    --with-curl \
    --enable-fpm \
    --with-openssl \
    --with-mcrypt \
    --with-mhash \
    --prefix=/usr/local/php

RUN cd /root/php-5.3.29 && make && make install
RUN cp /root/php-5.3.29/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
RUN chmod u+x /etc/init.d/php-fpm

# check_permission_utf8.php
# RUN chmod -R 644 /home/dev-httpd
# RUN find /home/dev-httpd -type d -exec chmod -v 705 {} \;

# php-fpm.conf, nginx 설정
RUN addgroup nobody
RUN mkdir -p /backup/logs/

# php 링크 파일 생성, composer 설치
RUN ln -s /usr/local/php/bin/php /usr/bin/php
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin/
RUN ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

WORKDIR /home/dev-httpd

ENTRYPOINT service ssh start && service php-fpm start && service nginx start && bash
