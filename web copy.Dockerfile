FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'root:docker123' | chpasswd
RUN sed -i 's@archive.ubuntu.com@mirror.kakao.com@g' /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo sudo ca-certificates \
    wget curl openssh-server vim git nginx \
    php7.1-fpm php7.1-curl php7.1-xml php7.1-zip php7.1-xml php7.1-mysql \
    php7.1-bcmath php7.1-ctype php7.1-json php7.1-mbstring php7.1-pdo php7.1-tokenizer php7.1-redis php7.1-mcrypt
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# 컴포저 설치
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin/
RUN ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

WORKDIR /home/heojun.mysoho.test

ENTRYPOINT service ssh start && service php7.1-fpm stop && service php7.1-fpm start && service nginx start && bash
