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

## IMPORT/EXPORT

```
# PREPARATION
# Origin DB
export DB_ORIGIN="tools_concourse6"
# Destination DB (copy of origin DB, that should be created eventually)
export DB_DESTIN="tools_concourse604"
# Create empty destination DB (if absent)
psql -h postgres.infra.internal -U postgres_user -d postgres -c "CREATE DATABASE tools_concourse604;"
# Create appropriate DB user (if needed)
psql -h postgres.infra.internal -U postgres_user -d postgres -c "create user concourse604 with encrypted password 'asdffda'; grant all privileges on database tools_concourse604 to concourse604;"

# EXPORT
export PGPASSWORD="asdff"
pg_dump -h postgres.infra.internal -U postgres_user -O -W -d ${DB_ORIGIN}  > dump.sql


# IMPORT
# NB: pay attention to user - it will be owner of the DB objects
psql -h postgres.infra.internal -U concourse604 -W -d ${DB_DESTIN} -f dump.sql

```


## TABLE

**List**

List tables in current schema ('public' by default) (via command)

```
\dt

                            List of relations
    Schema |                 Name                  | Type  |     Owner     
    --------+---------------------------------------+-------+---------------
    public | BootstrapMeta_auditing_domain_service | table | postgres_user
    public | insp_template_item_references         | table | postgres_user
```

List tables in all schemas (via command)
```
\dt *.*
```

List tables in particular schema ('public', for example) (via command)
```
\dt public.*
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
https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-ADMIN-DBSIZE

Show table size (no indexes)
```
SELECT
    pg_size_pretty (
        pg_table_size ('spm_data')
    );
```

Show table + indexes size
```
SELECT
    pg_size_pretty (
        pg_total_relation_size ('spm_data')
    );
```


List 10 biggest tables (table+index)
```
    # table_schema - table's schema name
    # table_name - table name
    # total_size - Total disk space used by the specified table, including all indexes and TOAST data
    # data_size - Disk space used by specified table or index
    # external_size - Disk space used by realted object to specified table

select schemaname as table_schema,
    relname as table_name,
    pg_size_pretty(pg_total_relation_size(relid)) as total_size,
    pg_size_pretty(pg_relation_size(relid)) as data_size,
    pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid))
      as external_size
from pg_catalog.pg_statio_user_tables
order by pg_total_relation_size(relid) desc,
         pg_relation_size(relid) desc
limit 10;
```
More about table size counting
```
select pg_relation_size(20306, 'main') as main,
  pg_relation_size(20306, 'fsm') as fsm,
  pg_relation_size(20306, 'vm') as vm,
  pg_relation_size(20306, 'init') as init,
  pg_table_size(20306), pg_indexes_size(20306) as indexes,
  pg_total_relation_size(20306) as total;
  main  |  fsm  |  vm  | init | pg_table_size | indexes |  total 
--------+-------+------+------+---------------+---------+--------
 253952 | 24576 | 8192 |    0 |        286720 |  196608 | 483328
(1 row)
```

From that, you can tell pg_table_size is the sum of all the return values of pg_relation_size. And pg_total_relation_size is the sum of pg_table_size and pg_indexes_size.

If you want to know how much space your tables are using, use pg_table_size and pg_total_relation_size to think about them -- one number is table-only, and one number is table + indexes.


## INDEXES

List all indexes in the specific schema
```
SELECT
    tablename,
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    schemaname = 'public'
ORDER BY
    tablename,
    indexname;
```

List all inxes on the specific table
```
SELECT
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    tablename = 'table_name';
```

Size
```
SELECT
    pg_size_pretty (
        pg_table_size ('spm_data_vesselcode_index')
    );
```


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

Sho maximum allowed connections (limit)
```
SHOW max_connections;
```

List current amount of sessions
```
select count(*)  from pg_stat_activity;
```

List sessions amount per DB
```
SELECT datname, numbackends 
FROM pg_stat_database 
ORDER BY numbackends desc;

    OR
    
SELECT datname, count(*)
FROM pg_stat_activity 
GROUP BY datname 
ORDER BY count(*) desc;
```

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

List the count of sessions that run distinct type of query, for specified DB
```
SELECT query, count(query)
FROM pg_stat_activity
WHERE datname='xbsdbname1'
GROUP BY query
ORDER BY count(query) DESC;
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

## PRIVILEGES: LIST

Privileges list [explained](https://www.postgresql.org/docs/9.3/sql-grant.html).
```
rolename=xxxx -- privileges granted to a role
        =xxxx -- privileges granted to PUBLIC

            r -- SELECT ("read")
            w -- UPDATE ("write")
            a -- INSERT ("append")
            d -- DELETE
            D -- TRUNCATE
            x -- REFERENCES
            t -- TRIGGER
            X -- EXECUTE
            U -- USAGE
            C -- CREATE
            c -- CONNECT
            T -- TEMPORARY
      arwdDxt -- ALL PRIVILEGES (for tables, varies for other objects)
            * -- grant option for preceding privilege

        /yyyy -- role that granted this privilege
```

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

List users and their privileges for a DB ('CREATE', 'CONNECT', 'TEMPORARY'. No privileges on tables)
```
\du

                             List of roles
    Role name    |  Attributes  |                    Member of
-----------------+--------------+------------------------------------------------
 dba             | Create role  | {util_user,helpdesk_user,helpdesk_admin}
 helpdesk_admin  | Cannot login | {helpdesk_user}
```

List privileges on Table  ('SELECT', 'INSERT', ...) for a user you are currently connected via
```
SELECT table_catalog, table_schema, table_name, privilege_type, grantee FROM   information_schema.table_privileges;
```

List specific privileges on the table
```
\z <table_name>
\dp <table_name>
```

## PRIVILEGES: GRANT

Add all privileges on DB ('CREATE', 'CONNECT', 'TEMPORARY'. No privileges on tables)
```
GRANT ALL PRIVILEGES ON DATABASE <db_name> TO <user_name>;
```

Grant all privileges on *existing* tables and sequences (indexes, etc)
```
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO <user_name>;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO <user_name>;
```

Grant all privileges on *new* tables and sequences (indexes, etc)
```
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON tables TO <user_name>;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, USAGE ON sequences TO <user_name>;
```


## SCHEMA

Which users have been granted privileges on the various schema
```
\dn+

                                        List of schemas
        Name    |     Owner     |       Access privileges        |       Description       
    ------------+---------------+--------------------------------+-------------------------
    public     | postgres_user | postgres_user=UC/postgres_user+| standard public schema
                |               | =UC/postgres_user              | 
    tiger      | rdsadmin      |                                | 

```


