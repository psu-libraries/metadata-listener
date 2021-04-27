FROM ruby:3.0.1 as base

ENV TZ=America/New_York
ENV LANG=C.UTF-8

COPY bin/docker-dependencies.sh /tmp
RUN bash /tmp/docker-dependencies.sh && \
  rm -rf /tmp/docker-dependencies.sh

WORKDIR /app
USER clamav

COPY --chown=clamav Gemfile Gemfile.lock /app/
RUN gem install bundler
RUN bundle config set path vendor/bundle
RUN bundle install && \
  rm -rf /app/.bundle/cache && \
  rm -rf /app/vendor/bundle/ruby/*/cache

COPY --chown=clamav . /app/
CMD [ "/app/bin/startup" ]
