Categories: java
Tags: java
      hadoop
      hive


## If using kerberos

    System.setProperty("java.security.auth.login.config","/etc/jass-login.conf");
    System.setProperty("sun.security.jgss.debug","true");
    System.setProperty("javax.security.auth.useSubjectCredsOnly","false");
    System.setProperty("java.security.krb5.conf","/etc/krb5.conf");

## Connect as usual

    import java.sql.*;
    private static final String hiveUrl =
        "jdbc:hive2://hadoop-cm001.cloud:10000/<user>;principal=hive/" +
                "hadoop-cm001.cloud@<kerberos-domain>";
    Connection conn = getConnection(hiveUrl);