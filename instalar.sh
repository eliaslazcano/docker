#!/bin/bash

# docker builder prune -f
docker run --rm -v ${PWD}/php:/backup php:8.4-fpm sh -c "cp -ra /usr/local/etc/php/* /backup"
grep -vE '^(;|[[:space:]]*$)' ${PWD}/php/php.ini-production > ${PWD}/php/php.ini

mkdir -p "$(pwd)/nginx"
docker run --name tmp-nginx -d nginx:stable
docker cp tmp-nginx:/etc/nginx/. "$(pwd)/nginx"
docker rm -v -f tmp-nginx

mkdir -p "$(pwd)/mariadb"
docker run --name tmp-mariadb -d mariadb:11
docker cp tmp-mariadb:/etc/mysql/mariadb.conf.d/. "$(pwd)/mariadb"
docker rm -v -f tmp-mariadb

docker compose up -d

# Habilita o JIT
docker run --rm -v ${PWD}/php:/usr/local/etc/php php:8.4-fpm sh -c "printf '\nopcache.enable=1\nopcache.enable_cli=1\nopcache.jit=1235\nopcache.jit_buffer_size=64M\nopcache.memory_consumption=128\n' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini"
docker rmi php:8.4-fpm
