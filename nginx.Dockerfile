FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'root:docker123' | chpasswd
RUN sed -i 's@archive.ubuntu.com@mirror.kakao.com@g' /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo ca-certificates \
    openssh-server git curl
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

WORKDIR /app
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN apt update && \
    apt install -y nodejs
RUN npm install -g npm@9.6.6
RUN npm i -g yarn

RUN adduser --disabled-password --gecos "" scv

ENTRYPOINT service ssh start && bash
