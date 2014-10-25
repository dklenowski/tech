Categories: oracle
Tags: asm

## 10g ##

### Creating a diskgroup

- To create the diskgroup TEST2 using no redundancy and device `/dev/sdd`.

        # export ORACLE_SID=+ASM
        # sqlplus /nolog
        
        SQL> connect / as sysdba
        SQL> CREATE DISKGROUP TEST2 EXTERNAL REDUNDANCY DISK '/dev/sdd';
        
        Diskgroup created.

- To view the diskgroups:

        SQL> select * from v$asm_diskgroup

- To view diskgroup to device mappings:

        SQL> select * from v$asm_disk;

