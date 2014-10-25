Categories: oracle
Tags: logminer

## Setup

1. Enable supplemental logging:

          SQL> ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;


2. Create database dictionary for logminer
  - To translate contents of redo logs, logminer requires access to a database dictionary.
  - i.e. to translate internal object identifiers and datatypes to object names and external data formats.
  - Dictionary file must have same database character set and be created from the same database as the redo logs being analyzed.
  - 3 alternatives:
      - extract dictionary to flat file
      - extract dictionary to redo logs
      - logminer uses an online catalog.

  - For the catalog, execute:

              SQL> EXECUTE DBMS_LOGMNR.START_LOGMNR(OPTIONS => - DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG);

  - Notes:
      - Logminer packages are owned by the SYS schema.
      - Therefore, if not connected as SYS, must include SYS in the call.
      - If it spits out an error, logminer has already been directed to use the online catalog.


3. Create a new logfile to monitor:

        SQL> EXECUTE DBMS_LOGMNR.ADD_LOGFILE( -
        > LOGFILENAME=>'/bss/v00/oracle/oradata/BSSV/redo01.dbf', -
        > OPTIONS => DBMS_LOGMNR.NEW);

  - Notes:
      - To add more logfiles, append `OPTIONS => DBMS_LOGMNR.ADDFILE`
      - To remove logfiles, append `OPTIONS => DBMS_LOGMNR.REMOVEFILE`


4. Start the logminer

        SQL> EXECUTE DBMS_LOGMNR.START_LOGMNR();

5. To stop the logminer

        SQL> EXECUTE SYS.DBMS_LOGMNR.END_LOGMNR();

