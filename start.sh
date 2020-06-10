#!/bin/bash
# TODO log to stdout somehow
pgrep java || /usr/share/tomcat9/bin/startup.sh

echo "Waiting for fits to become available"
if ! timeout 60 bash -c 'until curl http://localhost:8080/fits/version; do sleep 1; done'
then
  echo "fits never became ready. Exiting"
  exit 1
fi

echo "Starting Sidekiq"
bin/sidekiq -C config/sidekiq.yml -r ./sidekiq.rb -vv
