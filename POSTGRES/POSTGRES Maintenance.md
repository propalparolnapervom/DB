# README

## CONNECTION

**COMAND LINE**

Make a connection
```
    # export PGPASSWORD=<PWD>
    # psql -h <host_name> -p <port_name> -d <db_name> -U postgres_user

export PGPASSWORD=pwdpwd
psql -h postgres.infra.internal -p 5432 -d auditing -U postgres_user
```

Make a connection and apply a sql-file
```
psql -h postgres.infra.internal -p 5432 -d auditing -U postgres_user -f work.sql

    OR

psql -h postgres.infra.internal -p 5432 -d auditing -U postgres_user
\i work.sql
```

Make a connection and run a command
```
psql -U username -d database.db -c "SELECT * FROM some_table"
```


## HELP

List available commands
```
\?
```


## DB

**List**

List all databases
```
\l

    OR

SELECT datname 
FROM pg_database; 
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

    # OR
    
SELECT d.datname AS Name,  pg_catalog.pg_get_userbyid(d.datdba) AS Owner,
    CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
        THEN pg_catalog.pg_size_pretty(pg_catalog.pg_database_size(d.datname))
        ELSE 'No Access'
    END AS SIZE
FROM pg_catalog.pg_database d
    ORDER BY
    CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
        THEN pg_catalog.pg_database_size(d.datname)
        ELSE NULL
    END DESC -- nulls first;
```

Sho size of specific DB
```
SELECT
    pg_size_pretty (
        pg_database_size ('dvdrental')
    );
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

**Size**

http://www.postgresqltutorial.com/postgresql-database-indexes-table-size/


## USERS

List users
```
\du

   OR
   
SELECT *  FROM pg_catalog.pg_user;
```

Create new user
```
CREATE ROLE username WITH LOGIN PASSWORD 'quoted password' [OPTIONS]
```

Grant permission to user
```
GRANT ALL PRIVILEGES ON DATABASE super_awesome_application TO patrick;
```

## SESSIONS

**List**

List all sessions in the specific DB
```
select *
from pg_stat_activity
where datname = 'xbsdbname1';
```

List only active sessions in the specific DB
```
SELECT *
FROM pg_stat_activity
WHERE state = 'active'
AND datname = 'xbsdbname1';
```

List all sessions in the specific DB except you own one
```
SELECT *
FROM pg_stat_activity
WHERE datname = 'xbsdbname1' 
AND pid <> pg_backend_pid();
```

**Terminate**

Terminate all sessions in the specific DB except your own one
```
SELECT pg_terminate_backend(pg_stat_activity.pid) 
FROM pg_stat_activity 
WHERE pg_stat_activity.datname = 'xbsdbname1' 
AND pid <> pg_backend_pid();
```

Terminate only idle sessions in the specific DB except your own one
```
SELECT pg_terminate_backend(pg_stat_activity.pid) 
FROM pg_stat_activity 
WHERE pg_stat_activity.datname = 'xbsdbname1' 
AND pid <> pg_backend_pid()
AND state = 'idle';
```

## VARIABLES

Use env variable in the sql-query (command line only)
```
\set currdb `echo "$CURR_DB"`
SELECT datname 
FROM pg_database
where datname = :'currdb';
```

## PRIVILEGES

List DB privileges
```
\l

      Name       |     Owner     | Encoding |   Collate   |    Ctype    |                     Access privileges                      
------------------+---------------+----------+-------------+-------------+------------------------------------------------------------
 grafana_dev_eks  | postgres_user | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres_user                                         +
                  |               |          |             |             | postgres_user=CTc/postgres_user                           +
                  |               |          |             |             | data_science_crew_assignment_config_user=CTc/postgres_user+
                  |               |          |             |             | todel=c/postgres_user

```

List users and their privileges for a database
```
\du

                             List of roles
    Role name    |  Attributes  |                    Member of
-----------------+--------------+------------------------------------------------
 dba             | Create role  | {util_user,helpdesk_user,helpdesk_admin}
 helpdesk_admin  | Cannot login | {helpdesk_user}
```

List specific privileges on the table
```
\z <table_name>
```
