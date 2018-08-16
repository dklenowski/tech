Categories: mysql
Tags: gtid
      replication

    STOP SLAVE;
    SET GTID_NEXT="19a50d69-15f3-11e8-aca7-02d7ffe68678:28";
    BEGIN;
    COMMIT;
    SET GTID_NEXT="AUTOMATIC";
    START SLAVE;

