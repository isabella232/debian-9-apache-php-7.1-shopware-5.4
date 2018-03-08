FROM 1and1internet/debian-9-apache-php-7.1
MAINTAINER jessica.smith@1and1.co.uk
ARG DEBIAN_FRONTEND=noninteractive
COPY files /

# Environment variables for the MySQL DB
ENV SHOPWARE_DB_HOST=mysql \
    SHOPWARE_DB_USER=username \
    SHOPWARE_DB_NAME=databasename \
    SHOPWARE_DB_PASSWORD=EnvVarHere

RUN \
apt-get update &&\
apt-get install -y unzip curl &&\
rm -rf /var/lib/apt/lists/* &&\
{ \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
    echo 'opcache.enable=1'; \
  } > /etc/php/7.1/apache2/conf.d/10-opcache.ini && \
{ \
    echo 'zend_extension = "/usr/lib/php/20160303/ioncube_loader_lin_7.1.so"'; \
  } > /etc/php/7.1/apache2/conf.d/10-ioncube.ini && \

SHOPWARE_DOWNLOAD=$(curl -fsL http://en.community.shopware.com/_cat_725.html/ | grep -Eo 'http://releases.s3.shopware.com.s3.amazonaws.com/install_5.4.[0-9\.]+_[a-f0-9]+.zip' | sed 's/\.zip//' | sort -nr | uniq | head -1) && \
curl -fsL $SHOPWARE_DOWNLOAD.zip -o /usr/src/shopware.zip && \
echo Downloaded $SHOPWARE_DOWNLOAD.zip && \
chmod -R 755 /hooks /init && \
mkdir -p /var/www/html
WORKDIR /var/www/html