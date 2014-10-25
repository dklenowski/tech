Categories: perl
Tags: dbi

### Setup

    use DBI ();

    our $db_socket;
    if ( $^O =~ m/darwin/ ) {
      $db_socket = '/tmp/mysql.sock';
    } else {
      $db_socket = '/var/lib/mysql/mysql.sock';
    }

    our $database = 'test';
    our $db_user = 'test';
    our $db_pass = 'test';
    our $db_str = DBI:mysql:$database;mysql_socket=$db_socket"

    $dbh = DBI->connect($db_str, $db_user, $db_pass);
    if ( !$dbh ) {
      print "[ERROR] Failed to connect to $db_str as $db_user : " . $DBI::errstr;
      exit 1;
    }

## Overview

- Consists of:

### Perl DBI

- Defines DBI API, routes method calls to appropriate drivers.
- Database independent.

### Database Drivers

- aka Database drivers (DBD)
- Database Dependant
- Specific drivers implemented for each type of database.
- Perform actual operations on database.

## DBI Handles

- 3 types

### 1. Driver Handles

- Represent loaded drivers created when driver loaded and initialised
- 1 driver handle per loaded driver.
- 2 significant methods
  - `data_sources()` - Enumerate what can be connected to.
  - `connect()` - Connect to database.
- Usually not referenced within your programs, handled by DBI, usually when DBI->connect is called.

### 2. Database Handles

- Encapsulate single connection to a particular database.
- Are children of driver handle, many connections usually possible.
- Initially must connect,

        $dbh = DBI->connect($datasoure, ..);

### 3. Statement handles

- Encapsulate individual SQL statements.
- Children of their corresponding database handles.
- Multiple statement handles can be created.

## Data Source names

        dbi:<name_of_driver>

- Use `DBI->available_drivers()` to determine what drivers are installed on a machine.

## Connection

- Returns database handle or undef on error.

        my $dbh = DBI->connect("dbi:Oracle:archaeo", $username, $password);
        if ( !$dbh ) {
          print "[ERROR] Cannot connect to db archaeo : $DBI::errstr\n";
          exit 1;
        }
        
        
        # do something with dbh
        
        
        if ( !$dbh->disconnect() ) {
          print "[WARN] Failed to disconnect?\n";
        }

## Error Handling

- Manual error checking via `$DBI::errstr`.
- Most DBI methods will return false status value (usually `undef`), when execution fails.

### Automatic Error Checking

- DBI by default performs basic automatic error reporting by enabling the PrintError attribute.
- PrintError - Tells DBI to call perl warn() on error.
- RaiseError - Tells DBI to call perl die() on error.
- To turn off (and manually handle errors), on initialization of dbi:

        %attr = ( PrintError => 0, RaiseError => 0 );

- To turn back on

        $dbh->{PrintError} = 1;
        $dbh->{RaiseError} = 1;


### Error Diagnostic Methods

- The following methods can be applied against any valid handle, driver, database or statement

        $rv = $h->err()         # Returns error number assicated with the current error flaged against the handle $h.
        $str = $h->errstr()     # Returns string containing description of error.
        $str = $h->state()      # Returns string in the format of the standard SQLSTATE 5 character error string.
                                # Many drivers do not fully support this method.

### DBI Error Variables

- Note, error information is reset by DBI before most DBI method calls (i.e. important to check for errors from one method before calling next method of same handle).
- 3 variables that contain the same information as error diagnostic methods but at the class level.

        $DBI::err
        $DBI::errstr
        $DBI::state

- Need to use these variables for database connection issues, since no handle.

## Tracing

- Calling DBI->trace() enables tracing on all DBI operations from that point onwards.
- Valid tracing levels

        1          Traces DBI method execution showing returned values/errors.
        2          As for 1, but includes method entry with parameters.
        3          As for 2, but includes more driver trace information.
        4          Can include more detail than is helpful !!

- e.g.

        DBI->trace(1);
        DBI->trace(2, 'dbitrace.log');

- Note, trace is also available at the handle level (for tracing statement handle problems).
- e.g.

        $dbh->trace(1)

## Miscellaneous

### `quote()`

- Correctly quotes and escapes SQL statements for a specific database.
- e.g.

        my $str = "Don’t view in monochrome (it looks 'fuzzy')!";
        my $qstr = $dbh->quote($str);
        
        
        if ( $debug ) {
          print "[DEBUG] Original=|$str| Quoted=|$qstr|\n";
        }

- Output

        [DEBUG] Original=|Don’t view in monochrome (it looks 'fuzzy')!| Quoted=|'Don’t view in monochrome (it looks \'fuzzy\')!'|