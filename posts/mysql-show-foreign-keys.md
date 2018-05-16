Categories: mysql
Tags: foreign key
      key
      foreign


## Foreign Keys that reference <tablename>

        $ parallel --quote mysql -h "{}" -D information_schema -BNse 'SELECT @@hostname, TABLE_SCHEMA, \
         TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME FROM KEY_COLUMN_USAGE WHERE \ 
         REFERENCED_TABLE_SCHEMA = "<database>" AND REFERENCED_TABLE_NAME = "<tablename>" AND \
         REFERENCED_COLUMN_NAME IS NOT NULL;' ::: "${DB[@]}"

## Foreign KEys that <tablename> refences


        mysql> SELECT TABLE_SCHEMA, TABLE_NAME, GROUP_CONCAT( COLUMN_NAME SEPARATOR ', ' ), CONSTRAINT_NAME FROM KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = '<database>' AND TABLE_NAME = '<tablename>' AND REFERENCED_COLUMN_NAME IS NOT NULL GROUP BY 1,2,4;