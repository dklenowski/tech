Categories: mysql
Tags: replication

Reference: https://www.percona.com/blog/2008/07/07/how-show-slave-status-relates-to-change-master-to/

If you need to restart a MySQL slave and for some reason the replication parameters were lost (e.g. config change after a restart) you need to use the `Relay_Master_Log_File:Exec_Master_Log_Pos` coordinates (the IO Thread position).

Most times these will match up with the SQL Thread position `Master_Log_File:Read_Master_Log_Pos`, but they can differ.


        mysql> show slave status\G
        *************************** 1. row ***************************
                       Slave_IO_State:
                          Master_Host: 1.2.3.4
                          Master_User: slave
                          Master_Port: 3306
                        Connect_Retry: 60
                      Master_Log_File: master-bin.014874
                  Read_Master_Log_Pos: 1024152184
                       Relay_Log_File: relay-bin.000007
                        Relay_Log_Pos: 879400375
                Relay_Master_Log_File: master-bin.014868
                     Slave_IO_Running: No
                    Slave_SQL_Running: No
                      Replicate_Do_DB:
                  Replicate_Ignore_DB:
                   Replicate_Do_Table:
               Replicate_Ignore_Table: mysql.inventory
              Replicate_Wild_Do_Table:
          Replicate_Wild_Ignore_Table:
                           Last_Errno: 0
                           Last_Error:
                         Skip_Counter: 0
                  Exec_Master_Log_Pos: 879400215
                      Relay_Log_Space: 6573756068
                      Until_Condition: None
                       Until_Log_File:
                        Until_Log_Pos: 0
                   Master_SSL_Allowed: No
                   Master_SSL_CA_File:
                   Master_SSL_CA_Path:
                      Master_SSL_Cert:
                    Master_SSL_Cipher:
                       Master_SSL_Key:
                Seconds_Behind_Master: NULL
        Master_SSL_Verify_Server_Cert: No
                        Last_IO_Errno: 0
                        Last_IO_Error:
                       Last_SQL_Errno: 0
                       Last_SQL_Error:
          Replicate_Ignore_Server_Ids:
                     Master_Server_Id: 142113
                          Master_UUID:
                     Master_Info_File: mysql.slave_master_info
                            SQL_Delay: 0
                  SQL_Remaining_Delay: NULL
              Slave_SQL_Running_State:
                   Master_Retry_Count: 86400
                          Master_Bind:
              Last_IO_Error_Timestamp:
             Last_SQL_Error_Timestamp:
                       Master_SSL_Crl:
                   Master_SSL_Crlpath:
                   Retrieved_Gtid_Set:
                    Executed_Gtid_Set:
                        Auto_Position: 0
        1 row in set (0.00 sec)     