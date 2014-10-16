Categories: java
Tags: java
      binary
      mysql

        File f = new File(pic);
        FileInputStream fis = new FileInputStream(f);
        PreparedStatement ps = con.preparedStatmenet("INSERT INTO PICTURES values ??");
        
        ps.setString(1, f.getName());
        ps.setBinaryStream(2, fis, (int)f.length());
        
        ps.executeUpdate();
        
        ps.close();
        fis.close();