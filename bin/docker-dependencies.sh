#!/bin/bash

apt-get update
apt-get install --no-install-recommends clamav clamdscan clamav-daemon libstdc++6 libffi-dev wget libpng-dev make curl unzip \
  tomcat9 libmediainfo-dev openjdk-11-jre-headless -y
rm -rf /var/lib/apt/lists/*

curl -Lo /tmp/fits.zip https://github.com/harvard-lts/fits/releases/download/1.5.0/fits-1.5.0.zip
mkdir -p /usr/share/fits
mkdir -p /usr/share/man/man1
unzip /tmp/fits.zip -d /usr/share/fits
rm -rf /tmp/fits.zip

mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

freshclam

sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    echo "TCPSocket 3310" >> /etc/clamav/clamd.conf && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

mkdir /usr/share/tomcat9/conf \
  && ln -s /etc/tomcat9/catalina.properties /usr/share/tomcat9/conf/ \
  && ln -s /etc/tomcat9/tomcat-users.xml /usr/share/tomcat9/conf/ \
  && ln -s /etc/tomcat9/server.xml /usr/share/tomcat9/conf/

echo 'fits.home=/usr/share/fits' >> /usr/share/tomcat9/conf/catalina.properties \
  && echo 'shared.loader=${fits.home}/lib/*.jar' >> /usr/share/tomcat9/conf/catalina.properties \
  && mkdir /usr/share/tomcat9/webapps \
  && mkdir /usr/share/tomcat9/logs \
  && curl -Lo /usr/share/tomcat9/webapps/fits.war https://projects.iq.harvard.edu/files/fits/files/fits-1.2.1.war

chown -R clamav /usr/share/tomcat9 \
  && chown -R clamav /etc/tomcat9 \
  && mkdir /app && chown -R clamav /app

  

