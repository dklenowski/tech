Categories: java
Tags: hive
      kerberos
      hadoop


    public static void main(String[] args) {
        try {
            Class.forName("org.apache.hive.jdbc.HiveDriver");
        } catch ( ClassNotFoundException cnfe ) {
            logger.error("failed to load hive jdbc driver (org.apache.hive.jdbc.HiveDriver)", cnfe);
            System.exit(1);
        }

        String mysqlDb = System.getProperty("db");
        String mysqlUser = System.getProperty("dbUser");
        String mysqlPass = System.getProperty("dbPass");

        if (mysqlDb == null || mysqlUser == null || mysqlPass == null) {
            usage();
        }

        System.setProperty("java.security.auth.login.config","/etc/jass-login.conf");
        System.setProperty("sun.security.jgss.debug","true");
        System.setProperty("javax.security.auth.useSubjectCredsOnly","false");
        System.setProperty("java.security.krb5.conf","/etc/krb5.conf");

        Set<PopularSearchEntry> results = null;
        try (Connection conn = getConnection(hiveUrl)) {
            check(conn);
            results = load(conn);
        } catch (SQLException sqle) {
            logger.error("errors encountered retrieving results from hive..", sqle);
            System.exit(1);
        }

        if (results == null) {
            logger.error("failed to retrieve any results from hive, check the error log for details...");
            System.exit(1);
        } else if (results.size() < 1000) {
            logger.error("failed to retrieve enough results from hive (actual size=" + results.size() + "), check the error log for details...");
            System.exit(1);
        }

        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch ( ClassNotFoundException cnfe ) {
            logger.error("failed to load mysql jdbc driver (com.mysql.jdbc.Driver)", cnfe);
            System.exit(1);
        }

        String url = "jdbc:mysql://" + mysqlDb + ":3306/belen_popsearch";
        try (Connection conn = getConnection(url, mysqlUser, mysqlPass)) {
            save(conn, results);
        } catch ( SQLException sqle ) {
            logger.error("errors encountered saving results to mysql", sqle);
        }
    }
