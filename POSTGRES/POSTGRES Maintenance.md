# README

## CONNECTION

**COMAND LINE**

```
    # psql -h <host_name> -p <port_name> -d <db_name> -U postgres_user

psql -h postgres.infra.internal -p 5432 -d auditing -U postgres_user
```

## HELP

List available commands
```
\?
```


## DB

**List**

List databases
```
\l

          Name           |     Owner     | Encoding |   Collate   |    Ctype    |        Access privileges        
-------------------------+---------------+----------+-------------+-------------+---------------------------------
 auditing                | postgres_user | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 auth_service            | postgres_user | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
```

Show current DB
```
SELECT current_database();

    current_database 
    ------------------
    auditing
    (1 row)
```

**Connect**

Connect to the other DB
```
\c <DB_NAME>
```

**Create**

Create new DB
```
CREATE DATABASE databasename;
```

**Size**

Show size of all DBs.
```
SELECT pg_database.datname as "database_name", pg_database_size(pg_database.datname)/1024/1024 AS size_in_mb FROM pg_database ORDER by size_in_mb DESC;
```

## TABLE

**List**

List user tables in current DB (via command)

```
\dt

                            List of relations
    Schema |                 Name                  | Type  |     Owner     
    --------+---------------------------------------+-------+---------------
    public | BootstrapMeta_auditing_domain_service | table | postgres_user
    public | insp_template_item_references         | table | postgres_user
```

List user tables in current DB (via query)

```
SELECT * FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';

 schemaname |               tablename               |  tableowner   | tablespace | hasindexes | hasrules | hastriggers | rowsecurity 
------------+---------------------------------------+---------------+------------+------------+----------+-------------+-------------
 public     | inspection_template_sections          | postgres_user |            | t          | f        | t           | f
 public     | inspection_templates                  | postgres_user |            | t          | f        | t           | f
```

List all tables (user, system, etc)
```
SELECT * FROM pg_catalog.pg_tables;

     schemaname     |               tablename               |  tableowner   | tablespace | hasindexes | hasrules | hastriggers | rowsecurity 
--------------------+---------------------------------------+---------------+------------+------------+----------+-------------+-------------
 pg_catalog         | pg_statistic                          | rdsadmin      |            | t          | f        | f           | f

```

**Create**

```
CREATE TABLE t1 (
     c1    integer PRIMARY KEY,
     c2    varchar(40)
);
```


**Insert**

Specific data
```
INSERT INTO t1 VALUES
    (11, 'Bananas');
```

Random data
```
insert into xbsdbname1.public.t1 (
    c1, c2
)
select
    floor(random() * 10 + 1)::int,
    md5(random()::text)
from generate_series(1, 10) s(i);
```



## USERS

List users
```
\du
```

Create new user
```
CREATE ROLE username WITH LOGIN PASSWORD 'quoted password' [OPTIONS]
```

Grant permission to user
```
GRANT ALL PRIVILEGES ON DATABASE super_awesome_application TO patrick;
```