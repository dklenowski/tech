Categories: puppet
Tags: puppet


## Encrypting

Change to the directory where you have your keys

    root@test:/# cd /etc/eyaml/

Encrypt your string

    root@test:/etc/eyaml# eyaml encrypt -s 'test'
    string: ENC[PKCS7,MIIBeQYJKoZIhvcNAQcDoIIBajCCAWYCAQAxggEhMIIBHQIBADAFMAACAQEwDQYJKoZ
    ....
    OR
    block: >
        ENC[PKCS7,MIIBeQYJKoZIhvcNAQcDoIIBajCCAWYCAQAxggEhMIIBHQIBADAFMAACAQEw
        DQYJKoZIhvcNAQEBBQAEggEAEuBNL/RkgECIFRxTT5UBdZKPw8FsJthLoLSo
        cWKQ72VZ0vV9aovoglLxsRvrkThTU5SVabkcgxmHlPJtFPaadJa582w0MO4E
        VEF+ncy+wGoFfJ1NK8Y2hcS/T8Ac/bOi8plM2OLtJqr+3ousLfgwkYXbmFsb
        jN1xwjWJNA/ogDJwPjqSWmSLXXHcdWNAXb9jUQsVomfslS7tgSJ7c1Ca4q2/
        WBG5DZNUWnHCYKbz1sm9kgwFfjCOrIxOvlMxCJGv7EckHNmGzkhVg97XkZR+
        NqOQUhId5x5siIhYQ6h5ZlLPCv+rytc0dXsK6aHIwobs5PPM3aa6HmT3oDlZ
        WiEU2DA8BgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBC3EuvmPHaI7zvSmzil
        DMuLgBChTer/Xtwz3y813DtMWJ/d]

## Decrypting

Change to the directory where you have your keys

    root@test:/# cd /etc/eyaml/

Decrypt your string

    root@au-puppetmaster1001:/etc/eyaml# eyaml decrypt -s 'ENC[PKCS7,MIIB
    ...
    kTOnqL7Xx5yenT+5iRE1ezAPVAhL3q0nG7PIlI2xjA8BgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBCir7S9QcvVRQa0yS7yuly1gBAzeRVn3Nt+HON1jdPbm0BX]'
    test
