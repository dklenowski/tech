Categories: java
Tags: jdbc
      odbc

- Set of interfaces that encapsulate database functionality.
- The *JDBC Driver* implements the JDBC API.

## JDBC URL

- Contains:
    1. JDBC specification (e.g. `jdbc`).
    2. Subprotocol
        - Name of the driver or name of the database connectivity mechanism.
        - e.g. `odbc`, `rmi` 
    3. Database Identifier
        - Varies with the database driver used.

- e.g's

        String dbUrl = "jdbc:odbc:nethealth";
        String dbUrl = "jdbc:rmi://192.168.0.2:1099/jdbc:cloudscape:db";

## Driver Types

### Type 1 - JDBC-ODBC Bridge

- Converts JDBC from client to ODBC, which in turn are converted to database calls.
- Require non java software to be installed on machine (i.e. client requires ODBC libraries).
- e.g. JDBC-ODBC bridge from Sun
- Advantage: Will access almost any database.
- Disadvantage: Performance, ODBC driver and native connectivity interface must be installed on the client.

        JDBC-ODBC Bridge
              \/
        ODBC Driver
              \/
        Vendor DB Library -----------> Database Server

### Type 2 - Native API/Partly Java Driver

- Use native code to access database, thin layer java wrapped around native library.
- May perform better than all java drivers.
- Client requires database specific libraries.
- e.g. Oracle OCI
- Advantage: Better performance than ODBC-JDBC Bridge.
- Disadvantage: Vendor database library needs to be installed on the client.

        Native API/Partly Java Driver 
              \/
        Vendor DB Library -----------> Database Server



### Type 3 - Net Protocol/All Java Driver

- Generic network protocol that interfaces with middleware.
- JDBC classes written all java.
- JDBC database requests passed through network to middle-tier server which translates requests directly or indirectly to database specific native connectivity interface to further requests to database server.
- If the middle tier server written in java, can use type 1 or type 2 JDBC driver to do this.
- Can be used with applets because the driver can be downloaded on the fly.
- e.g. IDS Driver (proprietary), Metant DataDirect SequeLink Java 5.0.
- Advantage:
    - Server based, no need for database library to be present on client.
    - portability, scalability, performance, advanced features (e.g. caching of connections, queries etc), logging, load balancing etc.
- Disadvantage: Requires database specific coding on the middle tier.

        Net-Protocol/All Java Driver -----------> Middleware Server -----------> Database Server

### Type 4 - Native Protocol/All Java Driver

- Written entirely in java, driver calls database directly.
- Understand database specific networking and don't require any additional software.
- i.e. Converts JDBC calls into vendor specific DBMS protocol so that client applications can communicate directly with the database server.
- Can be used for applet to database communication.
- Advantage: Increased performance (no translation to ODBC/native connectivity interface).
- Disadvantage: User needs a different driver for each database.

## Performance

- Type 3 & 4
    - Fastest.
    - Type 3 usually provides optimisation (e.g. connection pooling, caching, load balancing).
    - Type 4 don't have to convert to ODBC or native.

- Type 2
    - Average.
    - Generic database calls need to be converted into database specific calls.

- Type 1
    - Slowest.
    - Have to convert JDBC to ODBC and then to database specific calls.

## API ##

### `java.sql.Connection`
- Single connection to database.
- Should explicitly close, frees object memory and release database resources connection may be using.

### `java.sql.Statement`
- Basic SQL statement.
- Main operations:
    - `executeQuery()` - returns `ResultSet`
    - `executeUpdate()` - No results e.g. update/delete.
	
- Since it represents a single SQL statement any call to `executeQuery()`, `executeUpdate()` or `execute()` implicitly closes any active ResultSet associated with the statement.
- Note for large data sets, use a `ResultSet` stream (which is also used for BLOB's/CLOB's) e.g. 

        ResultSet rs = stmt.executeQuery("SELECT ....");
        if ( rs.next() ) {
          BufferedInputStream bis = new BufferedInpuStream(rs.getAsciiStream(1));
          ...
        }

### Advanced `ResultSet`'s

- Default ResultSet is forward-only, read-only `ResultSet`.
- As of JDBC 2.0, `ResultSet`'s are up-dateable.
- e.g.

        Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATEABLE);
        ResultSet = stmt.executeQuery("SELECT ....");
        
        rs.first();             // navigate to the first row
        rs.updateInt(2, 3454);  // update second column
        rs.updateRow();

- Can use `ResultSet` to create new rows. `ResultSet` contains a pseudo row (i.e. a blank row that contains all fields but no data) that can be used to create new rows.

        ResultSet rs = stmt.executeQuery("SELECT . .");
        rs.moveToInsertRow();
        
        rs.updateString(1, "...");	// update first column
        rs.updateInt(2, 12123);	// update second column
        
        rs.insertRow();

## Optimisation

### `Connection`

- Use `getAutoCommit()` / `setAutoCommit()`
    - For multiple statements.
    - Since by default, JDBC starts and commits after each statements execution on a transaction.

- Use `getTransactionIsolation()` / `setTransactionIsolation()`
    - `TRANSACTION_NONE`, `TRANSACTION_READ_COMMITTED` (fastest)
    - Can be problems with multiple connections.

### `Statement`

- Close statement as soon as you finish working with it, gives GC chance to recollect memory.
- Statement Types:
    - `Statement` 
        - Static SQL with no input/output
    - `PreparedStatement` 
        - Pre-parsed/pre-compiled.
        - Provides better performance than `Statement`.
    - CallableStatement
        - Fastest.
        - Requires stored procedures therefore loose portability.
- `getMaxRows()`
    - Maximum number of rows that a `ResultSet` produced by the `Statement` can contain.
- `getFetchSize()`
    - Maximum number of `ResultSet` rows that is the default fetch size for `ResultSet` objects.

- Prepared Statement example:

        connection = DriverManager.getConnection(DB_URL, "username", "password");
        
        String qrystr;
        PreparedStatement stmt;
        ResultSet rs;
        
        qrystr = "SELECT * FROM AirlineSchedule WHERE FROM = ?";
        
        stmt = con.preparedStatement(qrystr);
        stmt.setObject(1, "SAN");
        
        rs = schedule.executeQuery();


### `ResultSet`

- Better to use proper `getXXX()` methods, these have already been optimised.
- Close `ResultSet` when finish (even though Statement object closes `ResultSet` implicitly when it closes) because `ResultSet` may occupy allot of memory (depending on the query).
















	
		
