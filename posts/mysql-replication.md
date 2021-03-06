Categories: mysql
Tags: replication

## Notes ##

- `binlog` replication needs to be setup on the database before replication can occur, i.e. the following parameter needs to be set in `/etc/my.cnf`

        log-bin=mysql-bin


# Online Setup

1. Lock tables and record the `File` and `Position`:

        mysql> FLUSH TABLES WITH READ LOCK;
        mysql> SHOW MASTER STATUS;

2. Dump the master databases

        mysqldump --all-databases --master-data > dbdump.db

3. Apply the mysqldump on the slave

        mysql -uroot -p < dbdump.db

4. Update the master parameters on the slave and start replication

        CHANGE MASTER TO MASTER_HOST='<master>',MASTER_USER='slave',
        MASTER_PASSWORD='<password>',MASTER_LOG_FILE='<master-bin.log>',MASTER_LOG_POS=<master-log-pos>;

# Offline Setup

## Initial Sync ##

### 1. Lock Master ###

1. Lock tables and record the `File` and `Position`:

        mysql> FLUSH TABLES WITH READ LOCK;
        mysql> SHOW MASTER STATUS;

### 2. Stop Master and Slave ###

1. Stop both the master and slave database:

        # service mysqld stop

### 3. Sync Master to Slave ###

1. Copy the mysql datafiles from the master to the slave.
2. Datafiles can be found using the following command (when the database is running).

        mysql> SHOW VARIABLES LIKE 'datadir';

3. Once the file copy is complete restart the master:

        # service mysqld start

4. Release the read lock on the master:

        mysql> UNLOCK TABLES;

5. Grant replication privileges to the slave:

        mysql> GRANT REPLICATION SLAVE ON *.* to '<username>'@'<slave.ip>' IDENTIFIED BY '<password>';

### 4. Begin Slave Replication ###

1. Start the slave:

        # /etc/init.d/mysql start --skip-slave

2. Setup communication between master and slave (using the `File` and `Position` recorded in `1.1`):

        mysql> CHANGE MASTER TO
            -> MASTER_HOST='<master_ip_address>'
            -> MASTER_USER='<replication_username>'
            -> MASTER_PASSWORD='<replication_password>'
            -> MASTER_LOG_FILE='<recorded_File>'
            -> MASTER_LOG_POS='<recorded_Position>';

3. Start the slave:

        mysql> START SLAVE;


