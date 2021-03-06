Categories: oracle
Tags: sqlplus

### Connection ###

    connect <username>/<password>@<connectString>

where: 

    connectString - database name (i.e. in tnsnames.ora)

### Variables ###

    set pagesize 15
    set linesize 80

### Commands ###

#### describe [table|view|etc]

- List columns in table|view|etc

### Buffer Commands ###

- Set the `EDITOR=vi` before running `sqlplus` to get the buffer to open `vi` when running a command.

#### `run|r`

- Run command in buffer.

#### `list|l`

- List contents of buffer.

#### `append|a`

- Append to buffer.

#### `change /old/new`

- Change old to new in buffer.

#### `input|i` ####

- Add a line to the buffer.

#### `save <filename>` ####

- Save buffer to file (replaces file).
- Default extension .sql.

#### `get <filename>` ####

- Load file `<filename>` into buffer.

### Environment ###

    set <variable> <value>
    show <variable>

### Output

#### AS

    SELECT min_salary AS "Minimum Salary" FROM jobs

#### Concatenation

    SELECT TO_CHAR(SERIAL) || ',' ||
    TO_CHAR(ORIGINALSEVERITY) || ',' ||
    TO_CHAR(SEVERITY) || ',' ||
    '"' || TO_CHAR(FIRSTOCCURRENCE,'dd-MON-YY HH24:mi:ss') ||
    '"' || TO_CHAR(DELETEDAT,'dd-MON-YY HH24:mi:ss') || '"' |
    '"' || NODE || '"' || ',' ||
    '"' || ALERTGROUP || '"' || ',' ||
    '"' || ALERTKEY || '"' || ',' ||
    '"' || SUMMARY || '"' || ',' ||
    '"' || CUSTOMERID || '"' || ',' ||
    '"' || DEVICEID || '"' || ',' ||
    '"' || INCIDENTREF || '"'
    FROM REPORTER_STATUS WHERE
    FIRSTOCCURRENCE BETWEEN
    TO_DATE('02-09-02 22:00:00','DD-MM-YY HH24:MI:SS') AND
    TO_DATE('03-09-02 03:00:00','DD-MM-YY HH24:MI:SS')
    ORDER BY FIRSTOCCURRENCE;
