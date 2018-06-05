Categories: linux
Tags: socat
      util

## Socat commands

### On a jump host

    s 40; columns 132;
    stty cols 132 rows 40
    socat TCP-LISTEN:1531,reuseaddr,fork FILE:`tty`,raw,echo=0

### On internal host

    socat EXEC:bash,pty,stderr,setsid,sigint,sane TCP:52.208.219.238:1531

## Miscellaneous

1. Getting the current resolution of your window (run on amazon host):
        stty -a

2. On amazon host: (listen for connection, select a PORT number)
        socat TCP-LISTEN:PORT,reuseaddr,fork FILE:`tty`,raw,echo=0

3. On remote side: (send the connection, use same PORT number)
        socat EXEC:bash,pty,stderr,setsid,sigint,sane TCP:52.208.219.238:PORT

4. Setting the resolution within a connect back shell:
        stty cols <cols> rows <rows>

