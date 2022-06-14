# REDIS COMMANDS



# DB

> If your Redis instance is running multiple databases, these databases will be differentiated from one another by their unique index number.

## Connect

> If you don't have a certificates, but Redis is configured only with enctypred sessions,
> you might want to use `stunnel` tool
> https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls


Connect to instance
```
redis-cli -h <HOST> -p 6379 -a <PWD>
```

Connect to DB, which number is 10
```
redis-cli -h <HOST> -p 6379 -a <PWD> -n 10

     OR 

[redis_client]> select 10
```

## Delete

Delete DB, which number is 10
```
redis-cli -h <HOST> -p 6379 -a <PWD> -n 10 flushdb
```


Delete  ALL  DBs
```
redis-cli -h <HOST> -p 6379 -a <PWD> flushall
```




# Keys

## Read

Read all keys
```
redis-cli -h <HOST> -p 6379 -a <PWD> keys *

     OR 

[redis_client]> keys *
```

Read keys, which names contain `virtual_vessel`
```
redis-cli -h <HOST> -p 6379 -a <PWD> keys *virtual_vessel*

     OR 

[redis_client]> keys *virtual_vessel*
```

## Delete

Delete specific key
```
redis-cli -h <HOST> -p 6379 -a <PWD> del "<key_name>"

     OR 

[redis_client]> del "<key_name>"
```

