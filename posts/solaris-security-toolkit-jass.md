Categories: solaris
Tags: jass
      security

## Solaris Security Toolkit (SUNWjass)

        $JASS_HOME=/opt/SUNWjass    (default)

## Execute

        $JASS_HOME/jass-execute -d <driver>

- Note, For each toolkit run, a new subdirectory in /var/opt/SUNWjass/runs is created.

## Undo

        $JASS_HOME/jass-execute -u

- Note, By default, backup’s are enabled in JASS through the follwing variable ( in the `driver.init` file).

        $JASS_SAVE_BACKUP="1"

## Audit

        $JASS_HOME/jass-execute -a <driver>

- Also:

        -v <verbosity>, i.e. -v 1

- Environment variables to set:

        JASS_DISPLAY_HOSTNAME="1"; export JASS_DISPLAY_HOSTNAME
        JASS_DISPLAY_SCRIPTNAME="1"; export JASS_DISPLAY_SCRIPTNAME
        JASS_DISPLAY_TIMESTAMP="1"; export JASS_DISPLAY_TIMESTAMP

## Drivers

- Directory that contains:
  - Control script.
  - Scripts to execute.
- Note use `$JASS_USER_DIR` to set the `Drivers/` subdirectory. 

### `driver.init`

- sets environment

        $JASS_FILES - Copied from files/
        $JASS_SCRIPTS - Scripts to be executed
        Contains: 
        $JASS_USER_DIR/finish.init 
        $JASS_USER_DIR/user.init

### `driver.run`

- Processes contents of `$JASS_FILES` and `$JASS_SCRIPTS`


### `user.run` (optional)

- Enhanced/override functionality of driver.run

## Example Implementation

        <customer>_secure.driver
          driver.init -> config.driver -> driver.init -> driver.run -> user.run

        <customer_hardening>_hardening.driver
          driver.init -> driver.run

- Notes:
  - At each step, variables are initialised (so you are not running the same script with the same results).
  - When you create and install the package, the jass-execute script does not get run in the post install ..