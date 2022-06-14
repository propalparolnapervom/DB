# COMMANDS FOR REDIS

[Official Docs](https://redis.io/commands/)




## Connect

Connect to the `Redis CLI`

### If REDIS started via Docker

Redis is running locally, via Docker, in the container with name `my-redis`
```
docker exec -it my-redis sh
redis-cli
```






## Set key/value

### SET

[SET](https://redis.io/commands/set/)

Set 1 key-value pair
```
redis:6379> SET mykey "Hello"
"OK"
redis:6379> GET mykey
"Hello"
```

### MSET

[MSET](https://redis.io/commands/mset/)

Set multiple key-value pairs at one time
```
redis:6379> MSET key1 "Hello" key2 "World"
"OK"
redis:6379> GET key1
"Hello"
redis:6379> GET key2
"World"
```






## Get key/value

### GET

[GET](https://redis.io/commands/get/)

Get `value` for specified `key`
```
redis:6379> GET nonexisting
(nil)
redis:6379> SET mykey "Hello"
"OK"
redis:6379> GET mykey
"Hello"
```

### KEYS

[KEYS](https://redis.io/commands/keys/)

> **NOTE**: DO NOT USE IN PRODUCTION - IT'S HEAVY. Use `SCAN` instead

Return all keys matching specified pattern
```
redis:6379> MSET firstname Jack lastname Stuntman age 35
"OK"
redis:6379> KEYS *name*
1) "lastname"
2) "firstname"
redis:6379> KEYS a??
1) "age"
redis:6379> KEYS *
1) "lastname"
2) "age"
3) "firstname"
```

### [SCAN](https://redis.io/commands/scan/)



### [EXISTS](https://redis.io/commands/exists/)

Check whether `keys` exists or not
```
redis:6379> SET key1 "Hello"
"OK"
redis:6379> EXISTS key1
(integer) 1
redis:6379> EXISTS nosuchkey
(integer) 0
redis:6379> SET key2 "World"
"OK"
redis:6379> EXISTS key1 key2 nosuchkey
(integer) 2
```


## Delete key

### DEL

[DEL](https://redis.io/commands/del/)

Delete specified `keys`
```
redis:6379> SET key1 "Hello"
"OK"
redis:6379> SET key2 "World"
"OK"
redis:6379> DEL key1 key2
(integer) 2
```

## List

### INFO

[INFO](https://redis.io/commands/info/)

> **NOTE**: The `INFO` command returns information and statistics about the server.

All available info regarding REDIS server (server, clients, mem, cpu, etc)
```
INFO
```

Info about server only
```
INFO server
# Server
redis_version:7.0.2
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:6549e5aa8dc87aec
redis_mode:standalone
os:Linux 5.10.76-linuxkit x86_64
arch_bits:64
monotonic_clock:POSIX clock_gettime
multiplexing_api:epoll
atomicvar_api:c11-builtin
gcc_version:10.2.1
process_id:1
process_supervised:no
run_id:ecb0ccc8caa47ebfdfd918d5ad4f8c860eb18b6c
tcp_port:6379
server_time_usec:1655199277252393
uptime_in_seconds:1232
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:11032109
executable:/data/redis-server
config_file:
io_threads_active:0
```



















