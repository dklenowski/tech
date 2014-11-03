Categories: oracle
Tags: cheatsheet

## Users ##

- Can allow administrators to connect to database using OS system authentication or password file authentication.
- Local Administration - Can use either method.
- Remote Administration - Can only use OS authentication if you have a secured network authentication e.g. RADIUS using Oracle9i with Advanced Security Option.
- 2 administrator accounts created by default

        UserID  Password
        SYS     CHANGE_ON_INSTALL
        SYSTEM  MANAGER

- Note:
  - SYS is the default owner of the data dictionary.
  - SYSTEM is a DBA account.

- The pre-defined role `DBA` is created by default (with all database administrative privileges)

 
### OS Authentication

- Oracle verifies OS privileges and allows connection to database.
- MUST be a member of the OSDBA/OSOPER OS system group. (e.g. dba) which specified during installation.
- OSOPER/SYSOPER allowed operations:

        STARTUP, SHUTDOWN, ALTER DATABASE [OPEN/MOUNT], ALTER DATABASE BACKUP, ARCHIVE LOG, RECOVER
        SYSOPER includes RESTRICTED SESSION

- OSDBA/SYSDBA allowed operations:
  - All system privileges with `ADMIN OPTION`, `OSOPER` role, `CREATE DATABASE`, and time based recovery.

- Parameter:

        REMOTE_LOGIN_PASSWORDFILE=none (default)

- To connect to the database:

        SQL> CONNECT / AS SYSDBA
        SQL> CONNECT / AS SYSOPER


### Password File Authentication

- User connects to database using username/password.
- User needs to be have granted appropriate privileges in database.
- Steps:

  1. Using `orapwd` create a password file with the SYS password. 
    - When you change the password in the database, password file automatically updated.


            # orapwd file=<fname> password=<password> [entries=<users>]
            file        Name of password file, usually located $ORACLE_HOME/dbs
            password    Password for the SYS user
            entries     Maximum number of DBAs and OPERs

  2. Set `REMOTE_LOGIN_PASSWORDFILE=[EXCLUSIVE|SHARED]`
    - `SHARED`
      - Password file shared among multiple databases.
      - But cannot add any other user besides SYS or INTERNAL
    - `EXCLUSIVE`
      - Password file used for only 1 database.
      - Can add users other than SYS and INTERNAL to password file.

  3. Grant appropriate users SYSDBA / SYSOPER priviligies.

- Notes: 
  - When connecting to database using SYSDBA privilege, connected to the SYS schema.
  - When connecting to database using SYSOPER privilege, connected to the PUBLIC schema.
  - `V$PWFILE_USERS` contains information about all users granted `SYSDBA/SYSOPER` privileges.


## Configuration Files ##

- At instance startup, Oracle looks in the following order for parameter files:

    1. `spfile<SID>.ora`
    2. `spfile.ora`
    3. `init.ora`

### Parameter File (`PFILE`)

- Read by Oracle when database starts.
- Text file, specifies parameters for configuring database/instance.
- Note, for variables that are not defined in `PFILE`, Oracle will assign default's.
- Default location:

        $ORACLE_HOME/dbs/init<SID>.ora

- Contents:
  - Database name.
  - Location of control files.
  - Location of archive log files.
  - SGA size.
  - Trace files.
  - Parameters to set limits/affect capacity etc

### Persistent Parameter File (`SPFILE`) ###

- Same default location as `PFILE`.
- Binary file, created from `PFILE`.
- During startup Oracle will look for the default `SPFILE` first and then try the default `PFILE`.
- `SPFILE` can only be modified using the `ALTER SYSTEM COMMAND`.

### Operations ###

#### Creation

- To create a `SPFILE` from a `PFILE`:

        SQL> CREATE SPFILE FROM PFILE;

#### Viewing Parameters

        SQL> show parameters [ <name> ] [ <keyword> ]

#### Database Tables

- `V$PARAMETER`
  - Stores parameter values for current session.

- `V$SYSTEM_PARAMETER`
  - Stores system parameter values.

- Both tables define the following columns for parameters:
  - `ISDEFAULT`
    - Oracle default parameter.
    - `FALSE` indicates parameter changed during startup.
  - `ISSES_MODIFIABLE`
    - `TRUE`, parameter can be changed using `ALTER SESSION`.
  - `ISSYS_MODIFIABLE`
    - `FALSE`, parameter cannot be changed using ALTER SYSTEM.
    - `IMMEDIATE`, parameter can be changed.
    - `DEFERRED`, parameter changes takes place next session.

#### Changing Parameters

- To change a parameter system wide.

        SQL> ALTER SYSTEM SET <parameter>=<value> [DEFERRED|IMMEDIATE] [SCOPE=PFILE|MEMORY|BOTH]
        # DEFERRED – Change not made this session, only future sessions.
        # IMMEDIATE – Change immediate, default if none used.
        # SCOPE – defines how the parameter takes effect for the instance.
                   PFILE – New value takes effect only after instance restarted.
                   MEMORY – New value exists only for current instance.
                   BOTH – PFILE and MEMORY.

## Control Files

- Metadata repository for physical database.
- Binary file, created when database created, updated when physical database changes.
- Contents: 
  - Database creation timestamp.
  - Location of data files, redo files.
  - Tablespace names.
  - Log sequence number.
  - Checkpoint information.
  - Beginning and End of undo segments.
  - RMAN information.
- Notes:
  - Critical to operation, Oracle recommends at least 2 control files multiplexed.
  - If Oracle cannot update one of the control files, the instance will crash.

## Parameters ##

- To retrieve the names of the current control files:

        SQL> SHOW PARAMETER control_files

## Views ##

        V$CONTROLFILE
        V$CONTROLFILE_RECORD_SECTION

### Creation ###

- Using the `SPFILE`.

1.  When database open, alter the `SPFILE`

        SQL> ALTER SYSTEM SET CONTROL_FILES=
        '/ora01/oradata/<SID>/ctrl<SID>.ctl',
        '/ora02/oradata/<SID>/ctrl<SID>.ctl','
        '/ora03/oradata/<SID>/ctrl<SID>.ctl' SCOPE=SPFILE;

2.  Shutdown database

        SQL> SHUTDOWN NORMAL

3.  Copy existing control file to new location (using OS “cp”)
4. Startup instance.

        SQL> STARTUP

### Backup ###

- To backup the control file (when database is online):

        ALTER DATABASE BACKUP CONTROLFILE TO '<filename>' REUSE;

- To backup the control file in text format (file written to `USER_DUMP_DEST`).

      ALTER DATABASE BACKUP CONTROFILE TO TRACE;


## Redo Log Files ##

- Record all changes to database.
- The redo log buffer in the SGA written to redo log file periodically by the LGWR process.
- Used to reconstruct all changes made to database (including undo segments).
- Database must have at least 2 redo log files.
- LGWR writes in a circular fashion.
- Oracle automatically recovers instance during startup using the online redo log files.
- The redo log files contain redo record/entries which consist of change vectors:
  - change vector - Provides a description of a change made to a single block in the databases.

- LGWR writes redo log buffer to redo log files when:
  1.  User commits (even if this is only transaction in log buffer).
  2.  Redo log buffer becomes 1/3 full.
  3.  When approximately 1 MB of changed records in buffer (does not include deleted/inserted records).

- Notes:
    - LGWR always writes records to online redo log file before DBWn writes new/modified  database buffer cache records to the datafiles.

### Log Switch

- Current log file – actively being written to.
- Inactive log file's – all others.
- Log switch when current redo log file completely full.
- When log switch, Oracle allocates sequence number to the new redo log files before writing to it (log sequence number).
- Size the log file appropriately to avoid frequent log switches.
- Oracle writes to the alert log whenever a log switch occurs.
- To force a log switch:

        ALTER SYSTEM SWITCH LOGFILE

### Redo log Groups

- A log group can have >= 1 redo log members.
- Log groups referenced by integer.
- Can specify any group number between 1 and `MAXLOGFILES`.
- e.g. To create 2 log file groups (Group 1 and Group 2) and assign a log file to each).

        SQL> CREATE DATABASE “DB01” \
        LOGFILE '/ora02/oradata/DB01/redo01.log' SIZE 10M, \
        LOGFILE '/ora02/oradata/DB01/redo02.log' SIZE 10M;

- e.g. To create 2 log file groups explicitly:


        SQL> CREATE DATABASE “DB01”
        LOGFILE GROUP 1 '/ora02/oradata/DB01/redo01.log' SIZE 10M,
        LOGFILE GROUP 2 '/ora02/oradata/DB01/redo02.log' SIZE 10M;
        
### Multiplexing Log Files

- Safeguard against damage to these files, eliminate a single point of redo log failure.
- If LGWR can write to at least 1 member of the group, database operation proceeds as normal, an entry is written to the alert log file.
- If all members of the redo log file group not available for writing, Oracle shuts down instance.
- Parameters:

        MAXLOGFILES – Maximum number of log file groups.
        MAXLOGMEMBERS – Maximum number of log file group members.

### Redo Operations ###

#### Creation ####

        CREATE DATABASE “DB01”
          LOGFILE
            GROUP 1 (   '/ora02/oradata/DB01/redo0101.log',
                '/ora03/oradata/DB02/redo0102.log') SIZE 10M,
            GROUP 2 (   '/ora02/oradata/DB01/redo0101.log',
                '/ora03/oradata/DB02/redo0102.log') SIZE 10M

#### Addition

        ALTER DATABASE ADD LOGFILE
          GROUP 3 (   '/ora02/oradata/DB01/redo0301.log',
              '/ora03/oradata/DB01/redo0302.log');

        ALTER DATABASE ADD LOGFILE MEMBER
          '/ora04/oradata/DB01/redo0203.log' TO GROUP 2

#### Removal ####

- Notes:
  - Can only drop an inactive group, must have at least 2 groups for normal database functionality.
  - Can only drop members on an inactive redo log group.
  - If database in `ARCHIVELOG`, redo log members cannot be deleted unless redo log group has   been archived.

        ALTER DATABASE DROP LOGFILE GROUP 3;

        ALTER DATABASE DROP LOGFILE MEMBER '<log_filename>'

#### Rename ####

1.  Shutdown database and backup.
2.  Copy and rename log file member.
3.  Startup instance and mount the database `STARTUP MOUNT`
4.  Rename log file in control file:

        ALTER DATABASE RENAME FILE '<old_filename>' TO '<new_filename>';


#### Clearing ####

- If redo log group member (or all members of group) may be corrupted.
- Can clear log group, even with only 2 log groups.
- If log group member has not be archived, use `UNARCHIVED` keyword (should then do a full database backup, because unarchived redo log file is no longer usable for database recovery).

        ALTER DATABASE CLEAR LOGFILE GROUP 3;


## Checkpoint

- A checkpoint is event that flushes modified data from buffer cache to disk and updates the control file and data files.
- 2 processes are used during a checkpoint:
  - `CKPT` - Updates headers of data files and control files.
  - `DBWn` - Writes dirty buffer blocks to file.

## Initiation ##

A Checkpoint initiated when:

1.  Redo log file full and log switch occurs.
2.  Instance shut down with NORMAL, TRANSACTIONAL, or IMMEDIATE.
3.  Tablespace status changed to read only.
4.  Database put in BACKUP mode.
5.  When tablespace/datafile taken offline.

## Manual Checkpoint ##

- To force a manual checkpoint/issue either of the following commands:

        ALTER SYSTEM CHECKPOINT;
        ALTER SYSTEM SWITCH LOGFILE;

