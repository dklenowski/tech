Categories: oracle
Tags: em
      enterprise manager

## Useful links ##

- Recreating the Oracle EM

[http://blog.mclaughlinsoftware.com/oracle-architecture-configuration/changing-windows-hostname-and-oracle-enterprise-manager/](http://blog.mclaughlinsoftware.com/oracle-architecture-configuration/changing-windows-hostname-and-oracle-enterprise-manager/)

[http://www.adp-gmbh.ch/ora/admin/password_file.html](http://www.adp-gmbh.ch/ora/admin/password_file.html)

- Generic Oracle EM Configuration

[http://www.akadia.com/services/ora_dbconsole.html](http://www.akadia.com/services/ora_dbconsole.html)

## To configure Oracle EM from scratch ##


- Run the `emreposcre` command to create the em catalog, e.g.

        @/u01/app/oracle/product/10.2.0/db_1/sysman/admin/emdrep/sql/emreposcre /u01/app/oracle/product/10.2.0/db_1 SYSMAN SYSMAN TEMP ON;

- Create the web configuration and `dbcontrol` database schema's.

        # emca -config dbcontrol db

  - This command will prompt for SID, port numbers, and system user passwords.
  - Should configure and start database control.

- EM should then be visible at:

        https://<dbserver>:5500/em

## To re-configure Oracle EM ##

        # emctl stop dbconsole
        # emca -repos drop
        # emca -repos create
        # emca -deconfig dbcontrol db
        # emca -config dbcontrol db

- The `deconfig` command removes all the web configuration and the `dbcontrol` database schema's

## Troubleshooting ##

### Oracle Password Files ###

- If using Oracle password files, you need to ensure the file has been created and the database has been initialised correctly, visit the following site for more info:

[http://www.adp-gmbh.ch/ora/admin/password_file.html](http://www.adp-gmbh.ch/ora/admin/password_file.html)


### `emca` fails during DST. ###

        # export TZ=Australia/Sydney+1
        # emctl resetTZ agent

