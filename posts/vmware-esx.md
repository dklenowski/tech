Categories: perl
Tags: template
      class
      exe

### Links ###

[Timekeeping for Linux ESX Guests](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1006427)


## Console

### List the network interfaces

        # vim-cmd hostsvc/net/info 

### Setting ^C

- By default the `stty` `intr` is not set.
- To view `stty` settings:

        # stty -a

- To set the `intr`

        # stty intr ^C

  - Note, Type the carat `^` then `C` (with no space).


### List the network interfaces

- Short format (ESXi):

         esxcfg-vmknic -l

- Long format (ESX and ESXi):

          # vim-cmd hostsvc/net/info

## Restarting ESX Server Console ##

- You can restart the ESX server console without affecting the guest's.
-  e.g. if problems with the gui.

### Process

- On the vmware server issue the following command:

        # service mgmt-vmware restart
        Stopping VMware ESX Server Management services:
           VMware ESX Server Host Agent Services                  [  OK  ]
           VMware ESX Server Host Agent Watchdog                  [  OK  ]
           VMware ESX Server Host Agent                           [  OK  ]
        Starting VMware ESX Server Management services:            
           VMware ESX Server Host Agent (background)              [  OK  ]
           Availability report startup (background)               [  OK  ]


- Note, sometimes this process may hang, if so try:

        # /etc/init.d/mgmt-vmware stop
        # /etc/init.d/mgmt-vmware start

- To check:

        # /etc/init.d/mgmt-vmware status

- and look for the process (note, this process is killable..):

        /usr/lib/vmware/hostd/vmware-hostd /etc/vmware/hostd/config.xml -u -a

## Fixing Hung Guest OS ##

1.  Determine full path

        # ps -ef |grep test-host
        ...
        ... /vmfs/volumes/4648111d-d2d8d138-8a27-001aa01567e0/test-host/test-host.vmx 

2.  Check if it is really hung:

        # vmware-cmd /vmfs/volumes/4648111d-d2d8d138-8a27-001aa01567e0/test-host/test-host.vmx  getstate
        getstate() = off

3.  To reset:

        # vmware-cmd /vmfs/volumes/4648100d-d2d8d138-8a27-001aa01567e0/Free-Bsd02/Free-Bsd02.vmx reset

4.  If problems still persist, may need to clone.

### Cloning a Hung Guest OS

- Before running this process, ensure the guest OS has been stopped (either via the GUI or by killing).

1.  Clone disk

        # mkdir /vmfs/volumes/storage1/test-host2
        # pwd
        /vmfs/volumes/storage1/test-host2
        
        # vmkfstools -i test-host2.vmdk /vmfs/volumes/storage1/Free-BsdOld/test-host.vmdk
         Destination disk format: VMFS thick
        Cloning disk 'test-host2.vmdk'...
        Clone: 2% done.
        Cloning disk 'test-host2.vmdk'...
        Clone: 100% done.
        #

2.   Change Guest OS profile in GUI to point to new image (or use a new profile).

## Copying a host ##

1. Export the VM as a `vmdk` (Note, destination path will be overwritten, if it exists)

        # vmkfstools -i <src> <dst>
        # vmkfstools -i /vmfs/volumes/vmserver1.vmdk -d 2gbsparse /dest/folder/vmserver1.vmdk
