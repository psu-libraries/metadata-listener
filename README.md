
# Configure 
install direnv to make your life easier! (https://direnv.net/)
```
cp .envrc.sample .envrc
direnv allow
```

without direnv
```
cp .envrc.sample .envrc
source .envrc
```

# Build
Occasionally you'll need to rebuild the container, it's a good idea to rebuild anytime the Dockerfile changes, it's been awhile since your last rebuild, or there's been massive changes to your gemfile. It's always good to test that building still works. 

```
docker-compose build
# or as one single step to build & run
docker-compose up --build -d
```

# Run 
Requires scholarsphere to be running, or at the very least a redis instance, and minio instance for the queue to connect to

```
docker-compose up -d 

# get a terminal 
./bin/dc-shell

# fire up the listener
./start.sh
```

# Run tests
from the container:
```
./bin/rspec
```
from outside the container:
```
./bin/dc-rspec
```

# Stop developing and go home for the day
```
docker-compose down
```

# Enqueue metadata listener jobs
This worker uses Sidekiq::Job and expects one JSON payload hash argument.

Use string keys and JSON-safe values:

```
MetadataListener::Job.perform_async(
	'path' => 'uploads/1.pdf',
	'endpoint' => 'https://example.edu/metadata',
	'api_token' => 'token-value',
	'services' => ['metadata', 'virus']
)
```

Notes:
- path is required.
- services should be an array of strings (not symbols).
- if services is missing or empty, the job defaults to virus scanning.
