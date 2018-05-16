Categories: mysql
Tags: performance, general

# To log all queries in MySQL

- Note, does not require a database restart.

	SET global log_output = 'FILE';
	SET global general_log_file='/var/lib/mysql/log/mysql_general.log';
	SET global general_log = 1;

- To turn off

	SET global general_log = 0;
