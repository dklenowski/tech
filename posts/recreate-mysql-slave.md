Categories: database
Tags: mysql slave replication recreate


# To recreate MySQL using a `mysqldump` file

- These instructions assuming your database lives in `/var/lib/mysql`.

## On the master

### 1. Lock the database

     flush tables with read lock;

### 2. Record the master file and position (for use when you run the `change master` command on the slave)

     show master status;

### 3. Take a `mysqldump`

     mysqldump --all-databases --master-data > dbdump.sql

## On the slave

### 1. Stop MySQL

    /etc/init.d/mysql stop

### 2. Remove the old database

    rm -fr /var/lib/mysql/data/* /var/lib/mysql/log/* /var/lib/mysql/binary/* /var/lib/mysql/relay/* /var/lib/mysql/tmp/*

### 3. Install an empty database

- Note, using `mysql_install_db` will create a empty password for `root` by default.

        mysql_install_db --datadir=/var/lib/mysql/data --user=mysql --verbose

### 4. Start the database

- On debian, the startup scripts use the accounts specified in `/etc/mysql/debian.cnf`. As this is an empty database, we need to start it manually.

        cd /usr ; /usr/bin/mysqld_safe &

### 5. Import the data

    mysql -uroot < dbdump.sql

### 6. Setup replication
  - Use the `master_log_file` and `master_log_pos` from the `show master status` command in the first step.

    CHANGE MASTER TO
    MASTER_HOST='<slave-host>',
    MASTER_USER='slave',
    MASTER_PASSWORD='<slave-password>'
    MASTER_LOG_FILE='<master-bin.<no>', MASTER_LOG_POS=<pos>;

### 7. Ensure `/etc/mysql/debian.cnf` matches the master

- For debian hosts, ensure the startup accounts match the master.


### 8. Restart the database

    mysqladmin -uroot -p shutdown
    /etc/init.d/mysql start

### 9. Start replication

    mysql -uroot -e "start slave;"



