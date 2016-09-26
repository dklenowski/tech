Categories: mysql
Tags: performance

# Enable NUMA for Mysql

- To enable NUMA in Percona for MySQL > 5.5

        [mysqld_safe]
        numa-interleave=1
        flush-caches=1
        innodb_buffer_pool_populate=1
