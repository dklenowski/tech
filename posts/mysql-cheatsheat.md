Categories: mysql
Tags: innodb
      myisam
      mysqldump
      index

## Database

### Innodb Status

- For checking innodb errors

		mysql> show innodb status\G


### System Variables

		 select * from INFORMATION_SCHEMA.GLOBAL_VARIABLES where VARIABLE_NAME like '%INNODB%';
		 show variables like '%innodb%';

## Tables

### Describe the table

		mysql> show table status where name='<tabel>';

## Indexes

### List indexes for tables

		mysql>  show indexes from <table>;


## Mysqldump

### To export data only

    mysqldump -u<user> --no-create-db --no-create-info <db> > dump.sql

### To export structure only

    mysqldump -u<user> --no-data <db> > dump.sql

### To import to database

    mysql -u<user> <db> < dump.sql

## Slow Queries

- To enable the mysql slow query log, use the following configuration options in `/etc/my.cnf` under the `[mysqld]` section.

        long_query_time=5
        log-slow-queries=/var/log/mysql/mysql-slow-queries.log

- Where the `long_query_time` specifies the minimum time the query must take before it is logged (for the above case every query over 5 seconds is logged).

## MyISAM Verses InnoDB ##

### MyISAM

- Uses B-tree indexes (R-tree for spatial data).
- Data/indexes stored separately (Indexes are stored in the .MYI file while data is stored in the .MYD file).
- Locking of MyISAM tables is performed at the table level. “Readers obtain shared (read) locks on all tables they need to read. Writers obtain exclusive (write) locks.”[1].
- If a MyISAM table has no deleted rows, you can insert rows into the table while select queries are running against it.

### Features

#### Prefix Compression 

- For string keys (e.g. when storing URLs which include `http://`) as keys, MySQL will compress the common prefix so it takes less space.

#### Packed Keys (Prefix Compression for integer keys). 

- e.g. integer keys stored with high bytes first, so there will be a large group of keys that can share a common prefix. (NB `PACK_KEYS=1` has to be added to the `CREATE TABLE` statement for this compression to occur).

#### Delayed Key Writes (controlled via the delay_key_write setting) 

- Allows MySQL to delay writing index data to disk (performance improvement for heavy `INSERT`, `UPDATE` and `DELETE` statements).

#### Blob Indexing 

- It is possible to index blob data (although MySQL will only use the first 500 bytes to use as the key).

#### Full Text Indexing

- A full text index allows fast lookups of individual words within a field (utilises two B-tree’s to perform full text indexing which should be taken into the sizing considerations).

#### MyISAM Compression 

- If a table is only being read from (not updated) the tables can be compressed (using `myisampack`).

#### Merge Tables (optionally with compression) 

- It is possible to “merge” smaller tables and present them as one big logical table. It is also possible to compress individual tables within the merge (e.g. older tables that aren’t being written to anymore).

### InnoDB

- Stores all its data in a series of >=1 datafiles (collectively know as tablespace).
- InnoDB provides B-tree indexes. The indexes are stored in the InnoDB tablespace.
- InnoDB requires a primary key for each table (if you don’t provide one, MySQL will supply a 64-bit value for you).

### Features

#### Very high concurrency 

- Uses MVCC to achieve concurrency. “InnoDB defaults to the repeatable read isolation level and implements all four levels: read uncommitted, read committed, repeatable read and serializable” [1]

#### Referential Integrity 

- InnoDB utilises foreign key constraint checking.

#### Clustered Indexes 

- “The primary key’s value directly affects the physical location of the row as well as its corresponding index node. Because of this, lookups based on primary keys are fast. Since once an index node is found, the relevant records are likely to already be cached in InnoDB’s buffer pool.”[1]

## References ##

[1] High Performance MySQL, Optimization, Backups Replication and Load Balancing. Zawodny, J.D. and Balling, D.J., Oreilly Media 2004.