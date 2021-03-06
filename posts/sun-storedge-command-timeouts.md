Categories: sun
            solaris
Tags: storedge
      cfgadm
      scsi
      scsi options

### Command Timeout Issues ###

- To limit the HBA speed to 160MB/s, create the file` /kernel/drv/mpt.conf` with the following contents, then reboot the system.

  - For an SE3310 RAID array: (there must be exactly 5 spaces between SUN and StorEdge)

            device-type-scsi-options-list =
                "SUN     StorEdge 3310", "SE3310-scsi-options";
            SE3310-scsi-options = 0x41ff8;

  - For an SE3310 JBOD: (this example is for a dual-ported HBA with device paths /pci@1e,600000/scsi@3 and /pci@1e,600000/scsi@3,1)

            name="mpt" parent="/pci@1e,600000"
                     unit-address="3"
                     scsi-options=0x1ff8;
            name="mpt" parent="/pci@1e,600000"
                     unit-address="3,1"
                     scsi-options=0x1ff8;
