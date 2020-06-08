
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
