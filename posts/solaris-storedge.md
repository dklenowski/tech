Categories: solaris
Tags: storedge


## Configuring the Sun Storage Automated Diagnostic Environment ##

### `SUNWstade` ###

- Run the `site_info_upd` command.

          bash-3.00# ./ras_admin site_info_upd
          
          Type 'q' to quit
          Enter Company Name*             : <something>
          Enter Contract Number           : <something>
          Enter Site Name*                : <something>
          Enter Address                   : <something>
          Enter Address 2                 : <something>
          Enter Mail Stop                 : <something>
          Enter City*                     : <something>
          Enter State                     : <something>
          Enter Zip Code                  : <something>
          Enter Country*                  : <something>
          Enter Primary Contact Name*     : <something>
          Enter Primary Telephone Number  : <something>
          Enter Primary Extension         : <something>
          Enter Primary Contact Email*    : <something>

- Discover the device:

          bash-3.00# ./ras_admin discover_inband
            Discover::inband: trying 3310
            Discover::inband: trying A3500FC
            Discover::inband: trying D2
            Discover::inband: trying Luxadm
              - found 1 device(s) using Discover::Luxadm
            Discover::inband: trying HBAApi
            Adding devices from inband.local to configuration:
            adding device : FCloop/50800200002137a0/ip=

- Run the install script:

          bash-3.00# ./ras_install
          Trying perl /usr/bin/perl (5008.004)
                      -> This version works
          
          *** USING PERL: /usr/bin/perl ***
          
            +----------------------------------+
            | Installing the Package and Crons |
            +----------------------------------+
          
          ? Are you installing a Master or a Slave Agent?
            (Enter M=master, S=slave, E=Empty Master)
            NOTE: An Empty Master will reset the configuration to an
                  initial package install state.
           [M/S/E]: (default=M)
          *** Master Install ***
          
          
          - Starting the Storage A.D.E service (rasserv):
          
          /opt/SUNWstade/rasserv/bin/apachectl start: nice -5 ./rasserv started
          
          - Setting up crons:
          ? Do you want to C=start or P=stop the Agent cron
          [C/P] : (default=C)
            -> cron installed.
          
          - Testing access to rasserv (this test will timeout after 6 tries of 15 secs):
            -> ping 'emercdb01.emerchants.com.au' succeeded!
            -> 1/6 attempting to contact agent service...
          
          - Contacted agent with hostid=83b019d5.
          
            +-------------------------------+
            |  SUNWstade installed properly |
            +-------------------------------+

- Install the `SUNWstadm` package if this is a management station.

### Troubleshooting

Command Timeout Issues

- To limit the HBA speed to 160MB/s, create the file/kernel/drv/mpt.conf with the following contents, then reboot the system.
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