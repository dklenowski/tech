# MySQL Performance

Reference: https://www.percona.com/live/mysql-conference-2015/sites/default/files/slides/Tuning%20MySQL%20Its%20About%20Performance_0.pdf

# Innodb

## Buffer Pool Efficiency

Use `show global status;` to get variables to calculate:

    Innodb_pages_read / Innodb_buffer_pool_read_requests
    Innodb_pages_written / Innodb_buffer_pool_write_requests

Want them to be low (< 5%), otherwise you will need to tune the buffer pool.

## `innodb_buffer_pool_size`

    mysql> SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_read%s';
    +----------------------------------+-------------+
    | Variable_name                    | Value       |
    +----------------------------------+-------------+
    | Innodb_buffer_pool_read_requests | 18832544250 |
    | Innodb_buffer_pool_reads         | 4987908     |
    +----------------------------------+-------------+
    2 rows in set (0.00 sec)

    Performance = 1-(Innodb_buffer_pool_reads/Innodb_buffer_pool_read_requests)*100

### Whats in the buffer pool

Note, query can be slow.

  USE information_schema;
  SET @page_size = @@innodb_page_size;
  SET @bp_pages = @@innodb_buffer_pool_size/@page_size;
  SELECT P.TABLE_NAME, P.PAGE_TYPE,
  CASE WHEN P.INDEX_NAME IS NULL THEN NULL WHEN P.TABLE_NAME LIKE '`SYS_%' THEN P.INDEX_NAME WHEN
  P.INDEX_NAME <> 'PRIMARY' THEN 'SECONDARY' ELSE 'PRIMARY' END AS INDEX_TYPE,
  COUNT(DISTINCT P.PAGE_NUMBER) AS PAGES,
  ROUND(100*COUNT(DISTINCT P.PAGE_NUMBER)/@bp_pages,2) AS PCT_OF_BUFFER_POOL,
  CASE WHEN P.TABLE_NAME IS NULL THEN NULL WHEN P.TABLE_NAME LIKE 'SYS\_%' THEN NULL ELSE
  ROUND(100*COUNT(DISTINCT P.PAGE_NUMBER)/CASE P.INDEX_NAME WHEN 'PRIMARY' THEN TS.DATA_LENGTH/
  @page_size ELSE TS.INDEX_LENGTH/@page_size END, 2) END AS PCT_OF_INDEX
  FROM INNODB_BUFFER_PAGE AS P
  JOIN INNODB_SYS_TABLES AS T ON P.SPACE = T.SPACE
  JOIN TABLES AS TS ON T.NAME = CONCAT(TS.TABLE_SCHEMA, '/', TS.TABLE_NAME)
  WHERE TS.TABLE_SCHEMA <> 'mysql'
  GROUP BY TABLE_NAME, PAGE_TYPE, INDEX_TYPE;

## `buffer_pool_instances`

Contention can occur in buffer pool if there is many threads trying to write.

    mysql> show variables like '%buffer_pool_instances%';
    +------------------------------+-------+
    | Variable_name                | Value |
    +------------------------------+-------+
    | innodb_buffer_pool_instances | 32    |
    +------------------------------+-------+
    1 row in set (0.00 sec)


## `innodb_log_file_size`

Fixed size files that are overwritten when full and records changes to the db (`ib_logfile[1|2]`)

## Monitoring

    SET GLOBAL innodb_monitor_enable='module_buffer';
    SELECT name, count_reset FROM INFORMATION_SCHEMA.INNODB_METRICS WHERE name LIKE 'buffer_flush_sync%';

If the counts are regularly greater than zero, increase `innodb_log_file_size`.

## `innodb_log_buffer_size`

For writing redo logfiles.
Every commit has to wait for the redo log to flush.


    SHOW GLOBAL STATUS LIKE 'Innodb_log_waits';


innodb_lru_scan_depth





