
\! echo
\! echo " Define current DB"
\! echo

\! echo
SELECT current_database() as current_db;

\! echo
\! echo " Kill all active sessions in current DB ..."
\! echo

\! echo
SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity 
WHERE pg_stat_activity.datname = current_database() AND pid <> pg_backend_pid();

\! echo
SELECT count(*) as active_sess_num_in_curr_db
FROM pg_stat_activity
WHERE state = 'active'
AND datname = current_database()
AND pid <> pg_backend_pid();


\! echo
\! echo " List DBs like current one"
\! echo

\! echo
SELECT datname 
FROM pg_database
where datname like ('%' || current_database() || '%');

\! echo
\! echo " Create \`$NEW_DB\` DB from the \`$CURR_DB\` DB"
\! echo

\set newdb `echo "$NEW_DB"`
\set currdb `echo "$CURR_DB"`
CREATE DATABASE :newdb  TEMPLATE :currdb;

\! echo
\! echo " List DBs like current one"
\! echo

\! echo
SELECT datname 
FROM pg_database
where datname like ('%' || current_database() || '%');

\q