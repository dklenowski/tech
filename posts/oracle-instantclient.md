Categories: oracle
            unix
            linux
Tags: instant client
      tnsnames

### Setting up Oracle Instantclient Environment ###

- Assumes the instant client was installed in `/opt/oracle/instantclient`

        export ORACLE_BASE=/opt/oracle
        export ORACLE_HOME=$ORACLE_BASE/instantclient
        export PATH=$ORACLE_HOME:$PATH
        export LD_LIBRARY_PATH=$ORACLE_HOME/lib32:$LD_LIBRARY_PATH

- Create the `tnsnames.ora` in `$ORACLE_HOME`

- Use the following connect string:

        # sqlplus <user>/<pass>@<hostname>/<service_name>

  - Where `<service_name>` is retrieved from the `tnsnames.ora` file (i.e. see [ http://www.orafaq.com/wiki/Tnsnames.ora](http://www.orafaq.com/wiki/Tnsnames.ora)).

