Categories: oracle
Tags: import
      export

## Exporting ##


1. Ensure `catexp.sql` or `catalog.sql` (which runs `catexp.sql`) has been run.
  - To check:

              SQL> select role from dba_roles;
              
              ROLE
              ------------------------------
              .....
              EXP_FULL_DATABASE     /* this role must exist */


2. Estimate the size of the export:
  - For a table:

              SQL>  select segment_name, bytes from user_segments where segment_name='EMPLOYEES';
              
              SEGMENT_NAME                       BYTES
              ------------------------------ ---------
              EMPLOYEES                         131072

  - For a schema:

              SQL> select sum(bytes) from user_segments;
              
              SUM(BYTES)
              ----------
                 2359296
                 
  - For a tablespace:

              SQL> select tablespace_name, sum(bytes) free_space
                2  from dba_free_space
                3  group by tablespace_name;



3. Check access privileges:
  - To export a table owned by another user must have the `EXP_FULL_DATABASE` role.
              
              SQL> select grantee, granted_role from dba_role_privs where grantee = 'SYS';
              
              GRANTEE                        GRANTED_ROLE
              ------------------------------ ------------------------------
              .....
              SYS                            EXP_FULL_DATABASE
              SYS                            IMP_FULL_DATABASE


4. Run the export:
  - e.g.

              exp / buffer=1024000 compress=y consistent=y constraints=y file=blah.dmp \
              feedback=100000 log=exp_log.txt rows=y
  
  - where:

              /           - use OS authentication (i.e. SYSDBA)
              buffer      - size of buffer to fetch rows (determines max number of rows in an array fetched)
              compress    - y, export flags table data into a single extent.
                          - n, current storage parameters used.
              consistent  - y, ensures data seen by export in consistent.
                          - n, each table exported in a single transaction.
              constraints - y, exports table constraints
              file        - the dump file
              feedback=n  - export will display a progress meter.
                          - variable specified causes a period to be displayed every n rows.
              grants=y    - y, export will export object grants.
                          - unless full database mode (i.e. whole database export) only
                          - only grants granted by the owner of the table are exported.
                          - System privilege grants are always exported.
              rows=y      - n, dont export rows, just table create statements !
              log=filename

  - Note, you can export either tables, tablespaces, schema's or based on a query (for tablespace export must have the `EXP_FULL_DATABASE` role).

              tables=(table1, table2);
              tablespaces=(tablespace1, tablespace2);
              owner=(owner1, owner2);

  - If there are no errors output to the log, can assume the export worked.

### Importing ###

1. Ensure `catexp.sql` or `catalog.sql` (which runs `catexp.sql`) has been run.
  - To check:

              SQL> select role from dba_roles;
              
              ROLE
              ------------------------------
              .....
              IMP_FULL_DATABASE     /* this role must exist */

2. Check access privileges:
  - To import a table owned by another user must have the `IMP_FULL_DATABASE` role.

3. Run the import:
  - e.g.

            imp / file=blah.dmp log=imp_blah.log fromuser=report touser=report \
            tables=repportutilisationpg  grants=y commit=y buffer=1024000

  - where:

            full                  - Imports a full database export dump.
                                  - User must have IMP_FULL_DATABASE role.
            transport_tablespace  - Move tables from one Oracle database to another.
            fromuser=report       - Will import all object in the schemas of the specified set of users.
            table=some_table      - Specify the table to import (must specify the schema that contains them).


 

 

