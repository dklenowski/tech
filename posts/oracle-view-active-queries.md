Categories: oracle
Tags: sql
      active
      queries

- Using the library cache.


        SELECT p.username, l.sql_text, LPAD(' ',4*(LEVEL-2))||
                        operation || ' ' ||
                        options || ' ' ||
                        object_name "Execution Plan"
        FROM (
                select s.username, p.address, p.hash_value, p.operation,
                        p.options, p.object_name, p.id, p.parent_id
                        from v$sql_plan p, v$session s
                        where (p.address = s.sql_address and
                                p.hash_value = s.sql_hash_value)
                                and s.username = '[USER]') p, v$sql l
        WHERE ( l.address = p.address
        AND     l.hash_value = p.hash_value)
        START WITH id=0
        CONNECT BY PRIOR id=parent_id