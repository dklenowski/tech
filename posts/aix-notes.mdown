Categories: aix
Tags: hmc
      lpar

## Terms ##

### HMC ###

- Intel, customized SuSE.
- i.e. used to create LPAR's
- Configure/control <= 48 machines (per HMC).
- Also collects information (e.g. errors).

### SDMC ###

- Superceeds HMC.
- Either virtual machine or hardware device.


### VIOS (Virtual IO Server) ###

- Create partitions that use IO resources of another partition.
- Used for ethernet, FC, SCSI etc

### NIM ###

- aka kickstart server.

## PowerPC ##

### P5/P6

- Each die has 2 cores.
- Each core has each 2 threads.

### P7 ###

- Each die has 8 cores.
- Each core has 4 threads.

## DLPAR ##

- similar to VMWare VMotion
- Must have shared storage.


### IVE ###

- Integrated Virtual Ethernet.
- Legacy equipment.
- Used to offload ethernet traffic (i.e. traffic goes through board and not hypervisor).


## Processors ##

### Processing Unit ###

- 1 core on a CPU.
- Each Processing Unit has access to a 10 ms timeslice on a core.
- i.e. A partition with 0.2 processing units is entitled to 20% capacity of 1 processor during each timeslice.
- A partition with 1.8 processing units uses 2 processors for 9ms each during the 10 ms hypervisor timeslice.

### Shared Processors ###

- Physical processors allocated to to multiple partitions.

#### Micro Partitions ####

- Partitions using shared processor pool.

#### Shared Processor Logical Partition (SPLPAR)

- Partition that used shared processors.

### Active Memory Sharing ###

- Allows multiple LPAR's to share a common pool of memory.
- Advantageous for LPAR's that are not used at the same time.

### Processor Folding ###

- If allocated more processors that required, AIX kernel will negotiate with Hypervisor and, if possible, turn processors off.


### Viewing Processor Information ###

        lsdev -c processor
        lsattr -E1 proc0
        bindprocessor -q          // Power 7
        lparstat -i
        
        
## Integrated Virtual Ethernet (IVE) ##

- Ethernet offloading.
- Interface comprised of port groups (1 port group used by 1 LPAR).
- For 2 interfaces, LPAR must use 2 different port groups (only on supported cards).
- Interfaces must be in the same port group to be able to talk to each other.


## Virtual I/O ##

### Shared Ethernet Adapter (SEA) ###

- Located on the VIO server.
- Bridge between the virtual and physical.

### `vswitch0` ###

- Located inside the hypervisor.

### Virtual Interface ###

- Try to ensure the `Adapter ID` on the LPAR maps the `Adapter ID` on the VIO server.



