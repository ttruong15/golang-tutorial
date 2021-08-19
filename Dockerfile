# This dockerfile is the Payconnector base for the ECS (non-kubernetes) environments
FROM ubuntu:20.04

# Speed up by using local mirror
RUN sed -i 's|/archive|/au.archive|' /etc/apt/sources.list

# install php 8.0
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -q -y rsyslog software-properties-common curl wget htop vim zip less wget htop telnet
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y apache2 php php-cli php-curl php-dev php-fpm php-soap php-gmp php-pgsql php-uuid make \
    php-mbstring php-xml default-jdk psutils psmisc php-gd php-bcmath php-xdebug \
    git php-zip logrotate php-apcu build-essential libz-dev pkg-config libgpgme11-dev awscli \
    software-properties-common language-pack-en msmtp-mta protobuf-compiler
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y mosquitto mosquitto-clients autoconf zlib1g-dev php-pear cmake
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y npm

#RUN pecl install gnupg
#RUN echo "extension=gnupg.so" > /etc/php/8.0/mods-available/gpg.ini
#RUN phpenmod gpg

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN pecl install grpc
RUN echo "extension=grpc.so" > /etc/php/7.4/mods-available/grpc.ini
RUN phpenmod grpc

RUN pecl install protobuf
RUN echo "extension=protobuf.so" > /etc/php/7.4/mods-available/protobuf.ini
RUN phpenmod protobuf

#RUN a2enmod rewrite expires headers proxy proxy_http actions fastcgi alias rewrite mpm_event proxy_fcgi
#RUN a2dismod mpm_worker mpm_prefork
#RUN a2enconf php8.0-fpm

#RUN wget https://archive.apache.org/dist/pulsar/pulsar-2.8.0/apache-pulsar-2.8.0-bin.tar.gz
#RUN tar -xzf apache-pulsar-2.8.0-bin.tar.gz
#ENV PATH "$PATH:/apache-pulsar-2.8.0/bin"

RUN wget https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.7.linux-amd64.tar.gz

# build grpc_php_plugin so we can generate protobuf
RUN bash -c 'mkdir -pv /php/{code,plugins}'
RUN cd /php && git clone --recurse-submodules -b v1.38.0 https://github.com/grpc/grpc
RUN cd /php/grpc && git submodule update --init && mkdir -p cmake/build && cd cmake/build && cmake ../.. && make protoc grpc_php_plugin 
RUN cp /php/grpc/cmake/build/grpc_php_plugin /php/plugins

RUN mkdir /node
COPY grpc-build.sh /php

RUN mkdir golang
WORKDIR golang
ENV GOPATH "/golang"
ENV GOBIN "/usr/local/go/bin"
ENV PATH "$PATH:/usr/local/go/bin:/golang/bin"

# install golang protobuf compiler and grpc
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1

RUN git clone -b v1.35.0 https://github.com/grpc/grpc-go



CMD ["tail", "-f", "/var/log/dpkg.log"]
#CMD ["/usr/local/go/bin/go", "run", "/golang/grpc-go/examples/helloworld/greeter_server/main.go"]
