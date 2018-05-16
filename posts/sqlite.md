Categories: database
Tags: linux
      sqlite
-->

### Connecting

    # sqlite <database_file>

### View databases

    sqlite> .databases

### View tables

    sqlite> .tables

### View table columns

    sqlite> pragma table_info(<table>);

### Viewing create sql

    sqlite> select * from sqlite_master;

### Exiting

    sqlite> .quit