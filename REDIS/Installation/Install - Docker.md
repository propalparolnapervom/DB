## Install REDIS via Docker

Make run it locally
```
docker run --name my-redis -d -p 6379:6379 redis
```

Connect to the Redis CLI
```
docker exec -it my-redis sh
redis-cli
```




























