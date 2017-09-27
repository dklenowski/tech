Categories: java
Tags: java
      hadoop
      hive

# Hadoop Course Notes

## Cheatsheat

    hdfs dfs -cat /dualcore/orders/part* | head -n 100 > test_orders.txt
    beeline -u jdbc:hive2://localhost:10000


- Impala uses more memory.
- Map-reduce doesn't use much memory.

## Hadoop files

- Preference to using larger files.
- Hadoop will internally split it up (and handles replicas).

## HBase

- Uses HDFS

## HDFS 

- Storage layer.
- Handles blocking/replication.

        hdfs fs -> equiv to hadoop fs (hadoop commands being deprecated).

## `getmerge`

- Merge files.


## Files

- Hadoop by default will not overwrite a directory.

### HDFS

- By definition, better to handle large files.
- Mappers work at the file level.
- i.e. smaller files requires more mappers.
- Waste memory in name node.


## YARN

- MapReduce v2
- next generation mapreduce1
- Resource Manager (RM) - Manages YARN instances.
- Node Managers (NM) - Manages individual nodes.

###  MapReduce v1

- Older.
- JT (Job Tracker) - Manager.
- TT (Task Tracker) - Nodes.


## MapReduce Process

- HDFS -> Mapper -> Intermediate Language -> Reducer -> HDFS

## Spark
 
- A more generic version of map-reduce.


## Impala

- Cloudera opensource software.

## Sqoop

- Can configure how many mappers.
- A file is created for each mapper.

### `--direct`

- Faster
- e.g. for mysql uses mysqldump

### `lastmodified`

- Add's and updates existing records.

## HBASE

- Hadoop databases
- Uses HDFS

## PIG

- Is an abstraction over map reduce.
- By default, uses tab separated files.
- Pig, by default uses 1 reducer.
  - Use `default_parallel` to increase the size of reducers.

### Datatypes

- Default is `bytearray` (i.e. `string`).
- "Schema on Read" 
 - i.e. Most hadoop things check format of fields on read.
- Missing values in CSV are `null`.
- Map/Reduce only done on `store` or `dump`.
  - Path will be optimized by map/reduce.

### Join's

- `COGROUP` is a primitive form of `JOIN`.
- Use `JOIN` with `FLATTEN` to get the same result as a `COGROUP`.

### Order By

- Shuffle and sort not done in the reducer.
- Uses a partitioner for multiple reducers.
  - Total order partitioner - Allocates keys to partitions and incorporates string comparisions.
- By default, when you use multiple reducers, you will still need to sort.


## Hive/Imapala

- Hive Metastore now called Metastore.


### Hive Vs Impala

- Hive will try to cast dynamically if required.
- Impala will not try to cast dynamically, must explicitly cast.

### Table

- Simply HDFS directory containing 1 or more files.
- Can add files dynamically.

## Creating Tables

### `EXTERNAL`

- IMPORTANT, use `EXTERNAL` to prevent Hive/Impala deleting table data when you delete the table.

### Loading Data

- `impala shell` updates metadata.


### Partitioning

- Prefer larger files. 


## Hive

- Hive Server 2 
  - Connects to metastore to get table definitions.
  - Connects to RM to schedule jobs.
  - Clients connect to hive server 2.


### Variable

- Setting variables inside hive/impala.

    ${variable}


## Metastore

- Schema definitions (Column, column types).
- Database information.
- Directories that undefly table.
- File format information.

### Managing

- Hive (beeline), impala-shell, hcat.

## UDF Verse Transform

- UDF is faster than transform.

## Indexes

- Not used in the map-reduce process.
- More higher level (i.e. in join's).


## Command Examples

### Sqoop

    sqoop import \
    --connect jdbc:mysql://localhost/movielens \
    --username training --password training \
    --fields-terminated-by '\t' \
    --warehouse-dir /movielens \
    --table movie


## Create with partitioning


    CREATE external TABLE ads (
    campaign_id STRING,
    display_date STRING,
    display_time STRING,
    keyword STRING,
    display_site STRING,
    placement STRING,
    was_clicked TINYINT,
    cpc INT)
    PARTITIONED BY (network tinyint)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t';
    
    
    LOAD DATA INPATH '/dualcore/ad_data1/*'
    INTO TABLE ads
    PARTITION(network=1);

## Complex Create

    CREATE external TABLE loyalty_program (
    cust_id STRING,
    fname STRING,
    lname STRING,
    email STRING,
    level STRING,
    phone MAP<STRING,STRING>,
    order_ids ARRAY<INT>,
    order_value STRUCT<min:INT, max:INT, avg:INT, total:INT> )
    
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '|'
    COLLECTION ITEMS TERMINATED BY ','
    MAP KEYS TERMINATED BY ':'
    
    LOCATION '/dualcore/loyalty_program';
    
    Location:
    
    
    select SENTENCES(message) from ratings where posted > '2014-05-01';
    
    
    SELECT SUM(total_price-total_cost) AS lost_revenue
    FROM cart_shipping
    WHERE steps_completed < 4;



