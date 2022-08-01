FROM ruby:2.7.6 as base

ENV TZ=America/New_York
ENV LANG=C.UTF-8

# System packages
# hadolint ignore=DL3008
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends clamav clamdscan clamav-daemon libstdc++6 libffi-dev wget libpng-dev make curl unzip \
  libmediainfo-dev openjdk-11-jre-headless -y && \
  rm -rf /var/lib/apt/lists/*

# ClamAV
RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    echo "TCPSocket 3310" >> /etc/clamav/clamd.conf && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

RUN freshclam

RUN curl -Lo /tmp/fits.zip https://github.com/harvard-lts/fits/releases/download/1.5.0/fits-1.5.0.zip \
  && mkdir -p /usr/share/fits \
  && mkdir -p /usr/share/man/man1 \
  && unzip /tmp/fits.zip -d /usr/share/fits \
  && rm -rf /tmp/fits.zip


RUN mkdir /app && chown -R clamav /app

WORKDIR /app
USER clamav

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
COPY --chown=clamav Gemfile Gemfile.lock /app/
RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)" && \
  bundle config set path vendor/bundle && \
  bundle install && \
  rm -rf /app/.bundle/cache && \
  rm -rf /app/vendor/bundle/ruby/*/cache

COPY --chown=clamav . /app/
CMD [ "/app/entrypoint.sh" ]
