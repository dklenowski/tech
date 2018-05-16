Categories: oracle
Tags: tablespace

## Oracle Tablespace's

### List tablespace's ###

      1  select tablespace_name, extent_management, allocation_type, contents,
      2* segment_space_management from dba_tablespaces;
    
    TABLESPACE_NAME                EXTENT_MAN ALLOCATIO CONTENTS  SEGMEN
    ------------------------------ ---------- --------- --------- ------
    SYSTEM                         DICTIONARY USER      PERMANENT MANUAL
    UNDOTBS                        LOCAL      SYSTEM    UNDO      MANUAL
    CWMLITE                        LOCAL      SYSTEM    PERMANENT MANUAL
    DRSYS                          LOCAL      SYSTEM    PERMANENT MANUAL
    EXAMPLE                        LOCAL      SYSTEM    PERMANENT MANUAL
    INDX                           LOCAL      SYSTEM    PERMANENT MANUAL
    TEMP                           LOCAL      UNIFORM   TEMPORARY MANUAL
    TOOLS                          LOCAL      SYSTEM    PERMANENT MANUAL
    USERS                          LOCAL      SYSTEM    PERMANENT MANUAL
    
    9 rows selected.

### Show free extents for tablespace's ###

    SQL> SELECT TABLESPACE_NAME, SUM(BYTES) FREE_SPACE
      2  FROM DBA_FREE_SPACE
      3  GROUP BY TABLESPACE_NAME;
    
    TABLESPACE_NAME                FREE_SPACE
    ------------------------------ ----------
    CWMLITE                          14680064
    DRSYS                            12845056
    EXAMPLE                           1703936
    INDX                             26148864
    SYSTEM                           32997376
    TOOLS                            10420224
    UNDOTBS                         190513152
    USERS                            26148864

### Show extent information for tablespace's ###

    SQL> select tablespace_name, max(bytes) largest, min(bytes) smallest, count(*) ext_count from dba_free_space group by tablespace_name;
    
    TABLESPACE_NAME                   LARGEST   SMALLEST  EXT_COUNT
    ------------------------------ ---------- ---------- ----------
    ATMD                             23003136     851968          2
    ATMDI                           236912640  236912640          1
    STATSPACK                        40828928     262144          2
    SYSTEM                          308215808     327680          2
    UNDOTBS1                       1042219008      65536         12