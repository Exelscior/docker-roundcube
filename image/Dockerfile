FROM osixia/web-baseimage:1.1.1

# roundcube version
ARG ROUNDCUBE_VERSION=1.3.8
ARG ROUNDCUBE_SHA256=c49e33f9643f98311b700138a1e1a0358c37b1205250e1124bd43d7f9a920d05

# MariaDB version
ARG MARIADB_MAJOR=10.3

# Install apache2 and php7.0-fpm using osixia/baseimage utils
# Caution: /container/tool/install-service-available arguments order is important
# php7.0-fpm install will detect apache2 and configure it

# Add MariaDB repository
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 \
    && echo "deb http://ftp.igh.cnrs.fr/pub/mariadb/repo/$MARIADB_MAJOR/debian stretch main" > /etc/apt/sources.list.d/mariadb.list \
    && { \
		     echo 'Package: *'; \
		     echo 'Pin: release o=MariaDB'; \
		     echo 'Pin-Priority: 999'; \
	     } > /etc/apt/preferences.d/mariadb


# Download, check integrity and unzip roundcube to /var/www/roundcube_bootstrap
RUN apt-get update \
		&& /container/tool/add-multiple-process-stack \
		&& /container/tool/add-service-available :apache2 :php7.0-fpm :ssl-tools \
		&& LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       aspell \
       aspell-en \
       aspell-fr \
       ca-certificates \
       curl \
       mariadb-client-$MARIADB_MAJOR \
       php7.0-enchant \
       php7.0-gd \
       php7.0-intl \
       php7.0-json \
       php7.0-ldap \
       php7.0-mcrypt \
       php7.0-mysql \
       php7.0-pgsql \
       php7.0-sqlite3 \
       php-apcu \
       php-gettext \
       php-pear \
		&& curl -o roundcube.tar.gz -SL https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBE_VERSION}/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz \
		&& echo "${ROUNDCUBE_SHA256} *roundcube.tar.gz" | sha256sum -c - \
		&& mkdir -p /var/www/roundcube_bootstrap /var/www/roundcube \
		&& tar -xzf roundcube.tar.gz --strip 1 -C /var/www/roundcube_bootstrap \
		&& apt-get remove -y --purge --auto-remove curl \
    && rm roundcube.tar.gz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add service directory to /container/service
ADD service /container/service

# Use baseimage install-service script
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service

# Add default env variables
ADD environment /container/environment/99-default

# Set roundcube data directory in a data volume
VOLUME ["/var/www/roundcube", "/data/backup"]

# Expose http and https default ports
EXPOSE 80 443
