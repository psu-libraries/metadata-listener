#!/bin/bash
echo "starting FITS Servlet"

bundle check || bundle

# TODO log to stdout somehow
pgrep java || /usr/share/tomcat9/bin/startup.sh

echo "Waiting for fits to become available"
if ! timeout 60 bash -c 'until curl http://localhost:8080/fits/version; do sleep 1; done'
then
  echo "fits never became ready. Exiting"
  exit 1
fi
bundle exec sidekiq -C config/sidekiq.yml -r ./listener.rb -vv
