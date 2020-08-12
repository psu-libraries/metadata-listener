FROM ruby:2.6.5 as base

ENV TZ=America/New_York
ENV LANG=C.UTF-8

# System packages
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends clamav clamdscan clamav-daemon libstdc++6 libffi-dev wget libpng-dev make curl unzip \
  tomcat9 libmediainfo-dev openjdk-11-jre-headless -y && \
  rm -rf /var/lib/apt/lists/*

RUN curl -Lo /tmp/envconsul.zip https://releases.hashicorp.com/envconsul/0.9.2/envconsul_0.9.2_linux_amd64.zip && \
    unzip /tmp/envconsul.zip -d /bin && \
    rm /tmp/envconsul.zip

# ClamAV
RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    echo "TCPSocket 3310" >> /etc/clamav/clamd.conf && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

RUN freshclam

# FITS!
RUN curl -Lo /tmp/fits.zip https://github.com/harvard-lts/fits/releases/download/1.5.0/fits-1.5.0.zip \
  && mkdir -p /usr/share/fits \
  && mkdir -p /usr/share/man/man1 \
  && unzip /tmp/fits.zip -d /usr/share/fits \
  && rm -rf /tmp/fits.zip

RUN mkdir /usr/share/tomcat9/conf
RUN ln -s /etc/tomcat9/catalina.properties /usr/share/tomcat9/conf/
RUN ln -s /etc/tomcat9/tomcat-users.xml /usr/share/tomcat9/conf/
RUN ln -s /etc/tomcat9/server.xml /usr/share/tomcat9/conf/

RUN echo 'fits.home=/usr/share/fits' >> /usr/share/tomcat9/conf/catalina.properties
RUN echo 'shared.loader=${fits.home}/lib/*.jar' >> /usr/share/tomcat9/conf/catalina.properties
RUN mkdir /usr/share/tomcat9/webapps
RUN mkdir /usr/share/tomcat9/logs
RUN curl -Lo /usr/share/tomcat9/webapps/fits.war https://projects.iq.harvard.edu/files/fits/files/fits-1.2.1.war

RUN chown -R clamav /usr/share/tomcat9
RUN chown -R clamav /etc/tomcat9

WORKDIR /app
USER clamav


COPY --chown=clamav Gemfile Gemfile.lock /app/
RUN gem install bundler
RUN bundle config set path vendor/bundle
RUN bundle install && \
  rm -rf /app/.bundle/cache && \
  rm -rf /app/vendor/bundle/ruby/*/cache

COPY --chown=clamav . /app/
CMD [ "/app/entrypoint.sh" ]
