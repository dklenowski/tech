Categories: oracle
Tags: database
      creation
      control file

## Environment Variables ##

## Parameter File Parameters ##

### `CONTROL_FILES`

- Full path/s of control file/s.
- Should use at least 2 control files (on different disks)
- Oracle will create control file when database file created (overwrites existing control files).

### `DB_BLOCK_SIZE`

- Database block size.
- Cannot be changed after database created.
- Default 4 KB (most platforms).
- Range is 2 KB to 32 KB depending on OS.

### `DB_NAME`

- Database name.
- Maximum 8 characters, can include: `a-zA-Z_#$`
- During database creation, `DB_NAME` stored in data files, redo log files and control file (cannot be changed easily, must recreate control file).

### `DB_CACHE_SIZE`

- Size of default buffer cache, with blocks of `DB_BLOCK_SIZE`.
- Can be dynamically altered.

### `LOG_BUFFER`

- Size of redo log buffer (bytes).

### `SHARED_POOL_SIZE`

- Size of the shared pool.
- Specified in KB or MB.
- Default 16 MB (most platforms).

## Database Creation Parameters ##

        CREATE DATABASE [“<name>”]
               [CONTROLFILE REUSE]
               [LOGFILE 
                 [GROUP 1
                   (‘</full/path/to/redolog01.log>’, ‘</full/path/to/redolog02.log>’) SIZE 5M [REUSE],]
                 [GROUP 2
                   (‘</full/path/to/redolog03.log>’, ‘</full/path/to/redolog04.log>’) SIZE 5M [REUSE]]]
        
               [MAXLOGFILE <num>]
               [MAXLOGMEMBERS <num>]
               [MAXLOGHISTORY <num>]
               [MAXDATAFILES <num>]
               [MAXINSTANCES <num>]
               [NOARCHIVELOG | ARCHIVELOG]
               [CHARACTER SET “WE8MSWIN1252”]
               [NATIONAL CHARACTER SET “AL16UTF16”]
               DATAFILE ‘</full/path/to/data01.dbf>’ SIZE 80M
                      AUTOEXTEND ON NEXT 5M MAXSIZE UNLIMITED
               UNDO TABLESPACE UNDOTBX
               DATAFILE ‘</full/path/to/data02.dbf>’ SIZE 35M
               DEFAULT TEMPORARY TABLESPACE TEMP
               TEMPFILE ‘</full/path/to/temp01.dbf>’ SIZE 20M


### `<name>`                                  

- Specifies database name.
- Optional, if omitted Oracle pulls name from DB_NAME parameter.
- `DB_NAME` and `<name>` should be the same.


### `MAXLOGFILES` ###

- For redo log.
- Maximum number of redo log groups for database.
- Recommended (Default) Value: 16

### `MAXLOGMEMBERS` ###

- For redo log.
- Maximum number of redo log members for each redo log group.
- Recommended (Default) Value: 2

### `MAXLOGHISTORY` ###

- For redo log.
- Default value is OS specific.
- Specifies how many archive log files recorded in the archive history.
- If set to a value greater than 0, then whenever an  instance switches from one online redo log file to another,  its `LGWR` process writes the following data to the control file.

### `MAXINSTANCES` ###

- Maximum number instances that can simultaneously mount and open database.
- Only used in RAC.
- Recommended Value: `1`

### `MAXDATAFILES` ###

- Maximum number of data files created for database.
- Datafiles created when tablespace created or more space added to tablespace (i.e. adding a datafile).

### `CONTROLFILE REUSE`

- Overwrites existing control file.
- Used when re-creating database.
- If omitted, and control file in `CONTROL_FILES` exist, Oracle generates error.

### `LOGFILE`

- Specifies location of online redo log files.
- Database must have at least 2 redo groups.
- If `GROUP` omitted, Oracle creates files specified in separate groups with one member in each.
- Recommended all redo log groups be the same size.
- `REUSE` overwrites existing log files (if same size).

### Control File Parameters

- Following parameters stored in the control file.
- Since oracle pre-allocates space for control file, control file size will depend on these limits.
- If variables need to be changed, have to recreate the control file.
            
#### NOARCHIVELOG | ARCHIVELOG

- Configure redo log archiving.
- Default `NOARCHIVELOG`.
- Can change to `ARCHIVELOG` mode using `ALTER DATABASE` command.

#### `CHARACTER SET "<character_set>"`

- Character set to store data, cannot be changed.
- Default WE8MSWIN1252 (on windows).

#### `NATIONAL CHARACTER SET "<character_set>"`

- National character set to store data in columns defined as NCHAR, NCLOB, or NVARCHAR2.
- If not specified defaults to CHARACTER_SET.

#### `DATAFILE "</full/path/to/data01.dbf>" SIZE 80M`

- If unqualified (i.e. with on `TABLESPACE` specified) specifies files for `SYSTEM` tablespace.
- Optionally specify `AUTOEXTEND` clause.

#### `UNDO TABLESPACE <tablespace_name>`

- Specifies undo tablespace with an associated data file.
- Contains undo segments when automatic undo management enabled is enabled with initialisation parameter `UNDO_MANAGEMENT=AUTO`.

#### `DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE "</full/path/to/temp01.dbf>" SIZE 20M`

- Defines tablespace location for all temporary segments.
- If a user is created without specifying a temporary tablespace, this one is used.

## Database Configuration Assistant (DBCA) ##

- Can run as part of OUI.
- Script generated by DBCA does performs the following:

  1.  Creates parameter file, starts database in `NOMOUNT` mode, creates database using `CREATE DATABASE` command.
  2.  Runs `catalog.sql`.
  3.  Creates tablespaces `TOOLS, UNDOTBS, TEMP, USERS` and `INDX`.
  4.  Runs the following scripts:
      - `catproc.sql` – Sets up PL/SQL
      - `caths.sql` – Installs heterogeneous services (HS) data dictionary providing ability to access non-Oracle database form Oracle database.
      - `otrcsvr.sql` – Sets up Oracle trace stored procedures.
      - `utlsampl.sql` – Sets up sample user `SCOTT` and creates demo tables.
      - `pupbld.sql` – Creates product and user profile tables (run as `SYSTEM`).
  5.  Runs scripts necessary for other options chosen.

## Oracle Managed Files (OMF) ##

- Maintains consistency between physical files and logical database objects through initialisation parameters.
- Following parameters can be modified using `ALTER SYSTEM`.

### Parameters ###

#### `DB_CREATE_FILE_DEST`

- Specifies the default location for new datafiles.

        OS File prefix:   ora_
        OS File suffix:   .dbf

#### `DB_CREATE_ONLINE_LOG_DEST_<n>`

- Where `<n>` is `1 - 5`.
- Specifies locations for online redo log files and control files.

        OS online redo log file suffix:   .log
        OS control file suffix:           .ctl

### OMF Database Creation

- Using OMF can simplify database creation.
- i.e. if `DB_CREATE_FILE_DEST` and `DB_CREATE_ONLINE_DEST_<n>` are defined with OS locations for data files and online redo log files.
-  e.g. creating database using OMF:

        SQL> CREATE DATABASE DEFAULT TEMPORARY TABLESPACE TMP;

 


