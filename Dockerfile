FROM wordpress:5.2.4-php7.1-apache

MAINTAINER Fuchi Corp <fuchicorpsolution@gmail.com>

WORKDIR /wordpress

## Download kubectl command and make it excecutable
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
