Categories: apache
Tags: ssl
      openssl
      certificate

## Configuring SSL for Apache

Ref: http://httpd.apache.org/docs/2.0/ssl/ssl_howto.html

1.  Generate a private key

        # openssl genrsa -out server.key

2. To check the key (i.e. check private)

        # openssl rsa -noout -text -in server.key

3. Generate a certificate

        # openssl req -new -key server.key -out server.csr

4. Update Apache

        SSLCertificateFile      /usr/local/apache2/ssl.crt/server.crt
        SSLCertificateKeyFile   /usr/local/apache2/ssl.key/server.key

## To Test

        # openssl s_client -connect localhost:443 -state -debug
        GET / HTTP/1.0