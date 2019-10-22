FROM wordpress:5.2.4-php7.1-apache

MAINTAINER Fuchi Corp <fuchicorpsolution@gmail.com>


## Download kubectl command and make it excecutable
RUN curl -o /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl
RUN chmod +x /tmp/kubectl
RUN mv /tmp/kubectl /usr/local/bin/kubectl

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
