Categories: oracle
Tags: data dictionary
      dictionary

### Data Dictionary

- Set of tables/views that hold database’s metadata information.
- Read only (for users), updated when Oracle issues DDL.
- Consists:
  1. Base Tables 
      - Normalised, cryptic, version specific information.
      - Rarely accessed, some exceptions include `AUD$` etc
  2. Views
      - Provide meaningful information from base tables.


### Data Dictionary Scripts ###

- Need to create dictionary views after creating database.
- Data dictionary base tables created under the `SYS` schema in the `SYSTEM` tablespace when the `CREATE DATABASE` command is issued.
- Before running any data dictionary script, connect to database as `SYS`
- Data dictionary scripts are located in `$ORACLE_HOME/rdbms/admin`.
- At a minimum `catalog.sql` and `catproc.sql` need to be run after database creation.

### `sql.bsq`

- Creates:
  - `SYSTEM` tablespace using the file(s) specified in `CREATE DATABASE`
  - Rollback segment called `SYSTEM` in the `SYSTEM` tablespace
  - `SYS` and `SYSTEM` user accounts.
  - Dictionary base tables and clusters.
  - Indexes on dictionary tables and sequences for dictionary use.
  - Roles: `PUBLIC`, `CONNECT`, `RESOURCE`, `DBA` etc
  - `DUAL` table.

### `catalog.sql`

- Creates data dictionary views and synonyms on the views (for easy access).

### `catproc.sql`

- Creates dictionary items necessary for PL/SQL functionality.
 
## Views

### `DBA_`

- Information about structures in database i.e. show data in all users schemas (e.g. object, owner etc)
- Accessible by `DBA` or `SELECT_CATALOG_ROLE` privilege.

### `ALL_`

- Show information about all objects user has to access (e.g. OWNER etc)
- Accessible all users.

### `USER_`

- Views show information about structures owned by user (in users schema) and do not have OWNER column.
- Accessible all users.

### `V$`

- Dynamic performance views.
- Contain performance data for database.
- Actual views have prefix `V_$`, but public synonyms have prefix `V$`

### `GV$`

- Global dynamic performance views.
- Almost all `V$` views have a corresponding `GV$`.
- GV$ views have a additional column identifying instance (`INST_ID`).
- Useful when using Real Application Clusters.

### Notes

- ALL_ and USER_ views contain almost identical information except for the OWNER column.
- DBA_ columns contain useful information for DBAs.
- For Oracle 9i, initialisation parameter `07_DICTIONARY_ACCESSIBILIGY` now defaults to false. User must have explicit object permissions or role `SELECT_CATALOG_ROLE`.
