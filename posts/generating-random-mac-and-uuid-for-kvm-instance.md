Categories: linux
            unix
Tags: kvm
      uuid

- To generate a random MAC address:

        echo  'import virtinst.util ; print virtinst.util.randomMAC()' | python

- To generate a random UUID:

        echo  'import virtinst.util ; print virtinst.util.uuidToString(virtinst.util.randomUUID())' | python