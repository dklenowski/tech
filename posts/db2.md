Categories: databases
Tags: db2


## Notes ##

- In general commands that end with `gui` are used for setup and commands that end with `cmd` are used to create.
- The fenced user is used internally by DB2.
- Swapspace should be twice the size of physical memory.
- DB2 uses OS password file to perform authentication.
- Database files are stored in the instance owner's home directory.
- You don't need a license for the client.
- Visit IBM Fix Central to download fixpacks.

## Control Centre ##

- Control Centre can be used to manage multiple databases, create databases etc
- To launch, run:

        # db2cc

## Installation ##

### Install a DB2 Server

- Extract the DB2 zip file, `cd` to the unzipped directory and run the gui:

        # ./db2setup

- To use a response file run:

        # ./db2-install

- For the install GUI:
    - Select `Custom Setup`.
    - `App Dev Tools` > `Base Development`
    - Don't install `SA MP` (unless required).
    - Don't create a DB instance (Install any Fixpacks first).
    - Check the logfile for any errors, before proceeding.

### List fixpack level ###

        # db2level

## Licensing ##

### List licenses ###

        # db2licm -l

### Add a license ###

        # db2licm -a <path>/<file>.lic

- You may need to bounce the instance, e.g.

        # db2stop [force]


## Instance ##

### Creating an Instance ###

        # db2isetup

### Listing instances ###

        # db2ilist

### Start/Stop an instance ###

        # db2start
        # db2stop

- Note, the above commands start the instance and the network listeners.

### Enable/disable auto-start ###

        # db2iauto

## Database ##

### Connecting to a database ###

        # db2 connect to <db> user <db2inst1> [using <password>]

### Create a sample database ###

- Run the following command as the instance owner:

        # db2sampl

### List databases ###

        # db2 list db directory

### Retrieve configuration information for database ###

- Run the following commands as the instance owner:

        # db2 get dbm cfg

### Miscellaneous ###

        # db2 list tables
        # db2 describe table <depth>

## Troubleshooting ##

- Run the following command as the instance owner to view the instance logs:

        # db2diag

- To view what the database is doing run the following command as the instance owner:

        # db2 list utilities

## Uninstall ##

1. Stop the database (as instance owner):

        # db2stop

2. Drop the database (as root):

        # db2idrop db2inst1

3. Stop the das (as das user):

        # db2admin stop
        # dasdrop

4. The the `db2_deinstall` program (as root):

        # install/db2_deinstall -a

5. Manually remove the contents of the `/var/db2` directory.

6. Manually delete the associated DB2 users.

7. Remove any DB2 entries from `/etc/services`
