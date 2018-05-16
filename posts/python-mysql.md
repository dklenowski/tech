Categories: python
Tags: python
      mysql

## Setup Conneciton

    con = MySQLdb.connect(host='localhost', read_default_file="/root/.my.cnf")
    cursor = con.cursor()

## Fetch single row

    cursor.execute("select @@server_id")
    row = cursor.fetchone()

## Fetch multiple rows

    cursor.execute("select host from information_schema.processlist where command='binlog dump'")
    rows = cursor.fetchall()
    hosts = []
    for row in rows:
      ip = row[0].split(':')[0]
      hosts.append(ip)
