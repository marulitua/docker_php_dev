FROM php:5.6-alpine

MAINTAINER erwinmaruli <erwinmaruli@live.com>

EXPOSE 5000
# we need to update repo database
RUN apk update && apk upgrade &&\
#in some case php composer need git to download dependency
#alpine by default come with ash shell so that we install bash
#in case we need specific bash commands or scripts
    apk add --no-cache bash openssh git &&\
#install pdo_mysql
    docker-php-ext-install pdo_mysql &&\
#install gd
    apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev\
    libjpeg-turbo-dev && docker-php-ext-configure gd\
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
    NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-install -j${NPROC} gd && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev && \
#install mcrypt
    apk add --no-cache libmcrypt-dev libltdl && \
    docker-php-ext-configure mcrypt && \
    docker-php-ext-install mcrypt

WORKDIR /usr/src/app
RUN curl -O https://getcomposer.org/composer.phar

# Start the app
CMD ["php -v"]
