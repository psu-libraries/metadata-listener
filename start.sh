#!/bin/bash
# TODO log to stdout somehow
pgrep java || /usr/share/tomcat9/bin/startup.sh

echo "Waiting for fits to become available"
if ! timeout 60 bash -c 'until curl http://localhost:8080/fits/version; do sleep 1; done'
then
  echo "fits never became ready. Exiting"
  exit 1
fi

echo "Updating Virus Definitaions"
freshclam &

if [ ${ENV:-production} == "development" ]; then
  echo "Checking Bundle"
  bundle check || bundle install
  echo "Sleeping Forever"
  sleep infinity
else
  echo "Starting Sidekiq"
  bundle exec sidekiq -C config/sidekiq.yml -r ./listener.rb -vv
fi
