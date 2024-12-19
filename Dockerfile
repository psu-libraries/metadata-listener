FROM ruby:3.1.6 as base

ENV TZ=America/New_York
ENV LANG=C.UTF-8

# System packages
# hadolint ignore=DL3008
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends clamav clamdscan clamav-daemon libstdc++6 libffi-dev wget libpng-dev make curl unzip \
  libmediainfo-dev openjdk-17-jre-headless -y && \
  rm -rf /var/lib/apt/lists/*

# ClamAV
RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    echo "TCPSocket 3310" >> /etc/clamav/clamd.conf && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

RUN freshclam

# FITS!
RUN curl -Lo /tmp/fits.zip https://github.com/harvard-lts/fits/releases/download/1.5.5/fits-1.5.5.zip \
  && mkdir -p /usr/share/fits \
  && mkdir -p /usr/share/man/man1 \
  && unzip /tmp/fits.zip -d /usr/share/fits \
  && rm -rf /tmp/fits.zip \
  && rm -rf /usr/share/fits/lib/droid/log4j* \
  && rm -rf /usr/share/fits/lib/log4j* 


RUN mkdir /app && chown -R clamav /app

WORKDIR /app
USER clamav

COPY --chown=clamav Gemfile Gemfile.lock /app/
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
RUN bundle config set path vendor/bundle
RUN bundle install && \
  rm -rf /app/.bundle/cache && \
  rm -rf /app/vendor/bundle/ruby/*/cache

COPY --chown=clamav . /app/
CMD [ "/app/entrypoint.sh" ]
