Categories: oracle
Tags: drop
      database

- To remove `datafiles`, `redologs`, `controlfiles` and `spfile`.

        SQL> SHUTDOWN
        SQL> STARTUP MOUNT EXCLUSIVE RESTRICT;
        SQL> DROP DATABASE;

- Note, if using ASM can take a few minutes to propagate.

