Categories: mysql
Tags: account
      password


## Creating a read only account

        GRANT SELECT, EXECUTE
        ON *.*
        TO 'ro'@'%'
        IDENTIFIED BY '<password>';

## Creating a read write account

        GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE 
        ON *.* TO 'rw'@'%'
        IDENTIFIED BY '<password>';

## Creating an admin account


        CREATE USER dave IDENTIFIED BY "<password>";
        GRANT ALL PRIVILEGES ON *.* TO dave;

- Then update your `~/.my.cnf`

        [client]
        user = dave
        password = <password>

## For older MySQL clients

- For older MySQL clients (<4.1), you may need to use an older style hashing.

        SET @@session.old_passwords = 0;
        SET PASSWORD FOR '<username>'@'%'=PASSWORD('<password>');
        FLUSH Privileges 
        SELECT `User`, `Host`, Length(`Password`) FROM mysql.user where User='<username>';

- Reference: http://dev.mysql.com/doc/refman/5.0/en/password-hashing.html