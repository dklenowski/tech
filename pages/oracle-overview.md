Categories: oracle
Tags: overview

# Oracle #

## Logical Database Structure ##

### Tablespace ###

- Highest level, group logical structures together.
- Consists actual data files (.dbf) for databases (i.e. tables created within tablespace).
- i.e. stores data, indexes, sorting and rollback information.

### Blocks ###

- Multiple of OS block size, corresponds to specific number of bytes of physical storage space
- Controlled by variable `DB_BLOCK_SIZE`
- 

### Segment ###

- A segment can only belong to 1 tablespace.
- 4 types of segments

#### 1. Data Segments ####

- Store table (cluster) data.
- Every table has at least 1 data segment.

#### 2. Index Segments ####

- Store index data.
- Every table has at least 1 index segment.

#### 3. Temporary Segments ####

- Used when oracle requires temporary storage (e.g. sorting an SQL query).


#### 4. Undo Segments ####

- Stores undo information.


### View

- aka Virtual Table
- Customised representation of data from >= 1 tables.
- Notes: 
  - Views become invalid when base table structure modified and needs to be recompiled.
  - Oracle automatically recompiles when access, but to explicitly recompile use:

          ALTER VIEW <view> COMPILE;

#### Creation ####

        CREATE VIEW admin_employees AS
        SELECT first_name || last_name NAME, email, job_id POSITION
        FROM EMPLOYEES
        WHERE department_id = 10

### Synonym

- Alias for database object (table, view, sequence, procedure, function package)
- Are public/private synonyms.
- Don't become invalid if objects they point to are dropped and can create synonym that points to an object that doesn't exist.
- e.g.

        CREATE [PUBLIC] SYNONYM <name>
        FOR [<schema>.]<object>[@<db_link>]
        CREATE PUBLIC SYNONYM employees FOR hr.employees

### Data Dictionary

- Created by `catalog.sql` at database creation time.
