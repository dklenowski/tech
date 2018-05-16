Categories: databases
Tags: mysql

## Estimate the Size of a Table in MySQL < 5.6

- Query doesn't consume resources.

        mysql> use information_schema;
        mysql> SELECT TABLE_SCHEMA
             , TABLE_NAME
             , ROUND(DATA_LENGTH / POW(2, 30), 2) AS "DATA(GB)"
             , ROUND(INDEX_LENGTH / POW(2, 30), 2) AS "INDEX(GB)"
        FROM TABLES
        WHERE TABLE_SCHEMA = "<database>"
          AND TABLE_NAME = "<table>";