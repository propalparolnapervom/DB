CREATE TABLE t1 (
     c1    integer,
     c2    varchar(40)
);


insert into t1 (
    c1, c2
)
select
    floor(random() * 10 + 1)::int,
    md5(random()::text)
from generate_series(1, 40000) s(i);

SELECT pg_database.datname as "database_name", pg_database_size(pg_database.datname)/1024/1024 AS size_in_mb FROM pg_database ORDER by size_in_mb DESC;
