Categories: oracle
Tags: oracle
      install
      installation
      solaris

## Initial

1. Create the users/groups for Oracle (Note, the group's `oinstall` and `dba` are equivalent, use the one that is standard for your company).

          # groupadd oinstall
          # useradd -d /export/home/oracle -g oinstall oracle

2. Create the standard oracle `bin` directory (if it does not exist)

          # mkdir -p /usr/local/bin

3. `chown` the `ORACLE_BASE`

          # bash-3.00# mkdir -p /u01/app/oracle
          # bash-3.00# chown -R oracle:oinstall /u01/app/

4. ssh into the host (with the `-X` option and run the Oracle installer):

          # ./runInstaller

5. (Optional) Install the "Grid Infrastructure" software (required for ASM) which is available on the Oracle 11g "All Downloads" page.
  - There will be some post installation scripts that are displayed on the console and need to be run.


## Post Oracle Installation ##

- Add the following to `/etc/system`

        * Oracle 11g settings (note some settings are historical and now controlled via prctl)
        set noexec_user_stack=1
        set semsys:seminfo_semmni=100
        set semsys:seminfo_semmns=1024
        set semsys:seminfo_semmsl=256
        set semsys:seminfo_semvmx=32767
        set shmsys:shminfo_shmmax=4294967295
        set shmsys:shminfo_shmmni=100

- Configure Solaris Resource controls (Solaris 10). (To verify, check `/etc/project`):

        bash-3.00# projadd group.oinstall
        bash-3.00# projmod -sK "project.max-shm-memory=(priv,4g,deny)" group.oinstall
        bash-3.00# projmod -sK "project.max-sem-nsems=(priv,256,deny)" group.oinstall
        bash-3.00# projmod -sK "project.max-sem-ids=(priv,100,deny)" group.oinstall
        bash-3.00# projmod -sK "project.max-shm-ids=(priv,100,deny)" group.oinstall

- Configure shell limits (to view all limits use `ulimit -a`):

        CPU TIME            -1 (Unlimited)    default               ulimit -t
        FILE SIZE           -1 (Unlimited)    default               ulimit -f
        DATA SEG SIZE       Minimum 1048576   default, unlimited    ulimit -d
        STACK SIZE          Minimum 32768     8192                  ulimit -s <size> or process.max-stack-size
        OPEN FILES/NOFILES  Minimum 4096      256                   ulimit -n <size> or process.max-file-descriptor
        VIRTUAL MEMORY      Minimum 4194304   unlimited             ulimit -v <size>


  - For Solaris 10 (Note if installing Grid infrastructure `max-file-descriptor` needs to be set to `65536` instead of `4096`)

            bash-3.00# projmod -sK "process.max-stack-size=(priv,32768,deny)" group.oinstall
            bash-3.00# projmod -sK "process.max-file-descriptor=(priv,65536,deny)" group.oinstall

  - For Solaris 9, aside from setting ulimits, must add the following to `/etc/system` (Note, `process.max-file-descriptor` is used instead of setting these limits for Solaris 10):

            * maximum file descriptors
            set rlim_fd_max=65536
            * default file descriptors for all shells
            set rlim_fd_cur=1024



## Post ASM Installation ##

For a good introduction into ASM creation visit [http://www.idevelopment.info/data/Oracle/DBA_tips/Automatic_Storage_Management/ASM_10.shtml](http://www.idevelopment.info/data/Oracle/DBA_tips/Automatic_Storage_Management/ASM_10.shtml).

- For all disks that will be part of the ASM diskgroup, ensure the partition table has slices `0` and `4` configured, e.g.

        partition> p
        Current partition table (original):
        Total disk cylinders available: 24620 + 2 (reserved cylinders)
        
        Part      Tag    Flag     Cylinders         Size            Blocks
          0       root    wm       0 -   354      500.78MB    (355/0/0)    1025595
          1 unassigned    wm       0                0         (0/0/0)            0
          2     backup    wu       0 - 24619       33.92GB    (24620/0/0) 71127180
          3 unassigned    wm       0                0         (0/0/0)            0
          4 unassigned    wm     355 - 24618       33.43GB    (24264/0/0) 70098696
          5 unassigned    wm       0                0         (0/0/0)            0
          6 unassigned    wm       0                0         (0/0/0)            0
          7 unassigned    wu       0                0         (0/0/0)            0

- `chown` all disks in `/dev/rdsk` that will be used by the oracle database

        # cd /dev/rdsk
        # chown -R oracle:oinstall c2t5d0*
        # chown -R -h oracle:oinstall c2t5d0*

- Run the ASM configuration utility to configure the first disk group and add disks to that group:

        # /u01/app/11.2.0/grid/bin/asmca

- Note, Although there is an `+ASM` instance created, the instance is down after you run `asmca` but the disk group is still available. To verify:

        ORACLE_SID=+ASM
        ORACLE_BASE=/u01/app
        ORACLE_HOME=/u01/app/11.2.0/grid
        PATH=$ORACLE_HOME/bin:$PATH
        export ORACLE_BASE ORACLE_HOME PATH
      

- To start the `+ASM` instance configure the listener [http://www.idevelopment.info/data/Oracle/DBA_tips/Automatic_Storage_Management/ASM_45.shtml](http://www.idevelopment.info/data/Oracle/DBA_tips/Automatic_Storage_Management/ASM_45.shtml) and then:

        # sqlplus /nolog
        SQL> connect sys as sysasm
        ...
        SQL> startup

## Environment Variables ##

### `ORACLE_BASE` ###

- Top of Oracle tree (e.g. `/u01/apps/oracle`)
- All Oracle versions stored under this directory.

### `ORACLE_HOME` ###

- Location of Oracle software relative to `ORACLE_BASE`
- OFA recommends:

        export ORACLE_HOME=$ORACLE_BASE/product/<release>

### `ORACLE_SID` ###

- Instance name for database.
- Must be unique for all instances (regardless of version) running on the server.

### `ORA_NLS33` ###

- Specifies character set (if different from the default).


### Sample environment initialisation script ###

    export ORACLE_SID=gnrl
    export ORACLE_HOME=/home/oracle/product/9.0.1
    export ORACLE_BASE=/home/oracle
    export ORA_NLS33=$ORACLE_HOME/ocommon/nls/admin/data
    export ORACLE_TERM=xterm
    export PATH=$PATH:$ORACLE_HOME/bin:/usr/local/java/bin
    export TNS_ADMIN=$ORACLE_HOME/config

    # change this NLS settings to suit your taste
    # or don't put anything and fall back to
    # american NLS settings
    # format : language_territory.characterSet
    export NLS_LANG='english_australia.us7ascii'

    if [ -z $LD_LIBRARY_PATH ]
    then
        export LD_LIBRARY_PATH=$ORACLE_HOME/lib
    else
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
    fi
    if [ -z $CLASSPATH ]
    then
        CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/network/jlib
        export CLASSPATH
    else
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/JRE:$ORACLE_HOME/jlib
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/rdbms/jlib:$ORACLE_HOME/network/jlib
        export CLASSPATH
    fi

