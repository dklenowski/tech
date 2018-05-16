Categories: linux
Tags: hdfs
      kerberose
      hadoop

## Troubleshooting Kerberos issues on HDFS

        export HADOOP_OPTS="-Dsun.security.krb5.debug=true"
        ./hadoop fs -ls hdfs://<ip>/<dir>/

