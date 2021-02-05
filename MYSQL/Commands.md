# Commands for MySQL DB

## CONNECT

As a root user on the DB server
```
mysql
```

As any user on the DB server
```
mysql -u <example_user> -p
```


## DATABASES

### List
List existing DBs
```
SHOW DATABASES;
```


## TABLES

### Create 

Create a table
```
CREATE TABLE example_database.todo_list (
    item_id INT AUTO_INCREMENT,
    content VARCHAR(255),
    PRIMARY KEY(item_id)
);
```

### Insert

Insert a line into table
```
INSERT INTO example_database.todo_list (content) VALUES ("My first important item");
```


### Select

Select from a table in specific DB
```
SELECT * FROM example_database.todo_list;
```










