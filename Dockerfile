FROM php:7-apache-buster
RUN a2enmod rewrite
RUN apt update \
 && apt upgrade -y \
 && apt install git wget unzip zlib1g-dev libpng-dev -y \
 && docker-php-ext-install gd \
 && curl https://getcomposer.org/installer > /root/composer-setup.php \
 && php /root/composer-setup.php --install-dir=/usr/local/bin/ --filename=composer
COPY typemill.zip /
RUN cd /var/www \
    && mkdir -p html \
  # && wget https://typemill.net/media/files/typemill-1.5.2.zip -O /typemill.zip \
    && unzip /typemill.zip -d /var/www/html \
    && cd html 
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 570 {} \; \
	&& find /var/www/html -type f -exec chmod 460 {} \;
RUN cp -R /var/www/html/content /var/www/html/content.orig
COPY entry.sh /
COPY init.sh /
RUN chown root:root /entry.sh ; chmod 0700 /entry.sh
RUN chown root:root /init.sh ; chmod 0700 /init.sh
CMD ["/entry.sh"]