Categories: mysql
Tags: account
      password

# Set Debian MySQL System Password

    export PASS=$(awk '/^password/ { print $NF; exit }' /etc/mysql/debian.cnf | tr -d '\r')
    mysql -Bse "set password for 'debian-sys-maint'@'localhost' = password('${PASS}');"