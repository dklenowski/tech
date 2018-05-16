Categories: cisco
Tags: router
      configuration
      aaa
      snmp
      logging

## Cisco Router Configuration Template

- oldish ..

        aaa new-model
        aaa authentication login default radius local
        aaa authentication login CONSOLE line
        enable secret 0 <password>
        username config password 0 <password>

        isdn switch-type basic-net3

        clock timezone AEST 10
        clock summer-time AEDT recurring last Sun Oct 2:00 last Sun Mar 3:00
        ip subnet-zero
        ip classless
        no ip http server

        ....

        logging source-interface Serial0
        logging <source-ip-for-log-messages>

        snmp-server host <snmp-server-ip> traps <snmp-password>
        snmp-server location "<location>"
        snmp-server contact "<contact>"
        snmp-server community <snmp-password> 2

        access-list 2 permit <source-ip-for-access-to-router> <source-ip-netmask>

        ....

        radius-server host <radius-ip> auth-port 1645 acct-port 1646
        radius-server retransmit 3
        radius-server key <radius-password>
        !
        line con 0
        logging synchronous
        password 0 <admin-password>
        login authentication CONSOLE
        line vty 0 4
        logging syhchronous
        access-class 2 in

        ....

        ntp clock-period 17180117
        ntp source Ethernet0
        ntp server <ntp-server-ip>
        end