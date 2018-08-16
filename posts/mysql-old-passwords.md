Categories: mysql
Tags: password

# Finding Old Passwords

### Really old (< 5.1) passwords

    SELECT User, Host, Password FROM mysql.user
    WHERE (plugin = '' AND LENGTH(Password) = 16)
    OR plugin = 'mysql_old_password';

## Old (< 5.5) passwords

    SELECT User, Host, Password FROM mysql.user
    WHERE (plugin = '' AND LENGTH(Password) = 41)
    OR plugin = 'mysql_old_password';

## Updating an old passwords

    UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE User='bob';
    FLUSH PRIVILEGES;
    set old_passwords=0;
    SET PASSWORD FOR 'bob'@'%' = PASSWORD('<password>');
    FLUSH PRIVILEGES;


## Implicit `mysql_native_password` accounts

### Finding

    select User,Host,Password from mysql.user
    WHERE plugin = '' AND (Password = '' OR LENGTH(Password) = 41);

### For 5.6

Need to explicitly set mysql_native_password (Ref: https://dev.mysql.com/doc/refman/5.6/en/account-upgrades.html)

    UPDATE mysql.user SET plugin = 'mysql_native_password'
    WHERE plugin = '' AND (Password = '' OR LENGTH(Password) = 41);
    FLUSH PRIVILEGES;
