# MONGODB Commands

## DUMP

Take a DB dump
```
DB_NAME_TO_DUMP="<db_name>"
HOST_NAME_PORT="prod-shard-0/prod-shard-00-00-65ope.mongodb.net:27017,prod-shard-00-01-65ope.mongodb.net:27017,prod-shard-00-02-65ope.mongodb.net:27017"
USER_NAME="<some_user>"
USER_PWD="<some_pwd>"

mongodump --host ${HOST_NAME_PORT} --ssl --username ${USER_NAME} --password ${USER_PWD} --authenticationDatabase admin --db ${DB_NAME_TO_DUMP}

# Dir with files will be created:
ls -ltr dump/${DB_NAME_TO_DUMP}

```

Restore DB from dump
```
# DB will be created with the name of the dir with DB dump
DESIRED_DB_NAME="<db_name>"
DIR_WITH_DB_DUMP="dump/${DESIRED_DB_NAME}"
HOST_NAME_PORT="prod-shard-0/prod-shard-00-00-65ope.mongodb.net:27017,prod-shard-00-01-65ope.mongodb.net:27017,prod-shard-00-02-65ope.mongodb.net:27017"
USER_NAME="<some_user>"
USER_PWD="<some_pwd>"

mongorestore --host ${HOST_NAME_PORT} --ssl --username ${USER_NAME} --password ${USER_PWD} --authenticationDatabase admin -d ${DESIRED_DB_NAME} --dir=${DIR_WITH_DB_DUMP} --dryRun

mongorestore --host ${HOST_NAME_PORT} --ssl --username ${USER_NAME} --password ${USER_PWD} --authenticationDatabase admin -d ${DESIRED_DB_NAME} --dir=${DIR_WITH_DB_DUMP}
```

