Categories: linux
            xen
Tags: linux
      xen

## `virt-install` ##

- When creating hosts using `virt-install` the configuration is written to:

      /var/lib/xend/domains

- Each domain has a main configuration file called `config.sxp` (sorted by UUID).


## Optimising

### Memory

- Run `xm info` to determine overall memory:

        # xm info |grep memory
        total_memory           : 8186
        free_memory            : 2988

- Use `xm memset` OR `virsh> setmem` to adjust memory parameters.
  - **CAN** only adjust memory up to the domains "Max Memory", otherwise must `set maxmem` and `set mem` and reboot the domain.

### CPU

- Try to pin at least 1 cpu to a domain using:

        # xm vcpu-pin <domain> <virtual_cpu_of_domain> <physical_cpu>

- e.g. 

#### Initial Configuration

- 4 physical CPU's mapped to 4 Virtual CPU's (VCPU's).
- Each domain (test1/test2) configured to use 2 VCPU's that can be bound to any host.

        # xm vcpu-list
        Name                              ID VCPUs   CPU State   Time(s) CPU Affinity
        Domain-0                           0     0     0   -b-  181900.8 0
        Domain-0                           0     1     1   r--  113443.0 1
        Domain-0                           0     2     2   -b-   87980.9 2
        Domain-0                           0     3     3   -b-   92222.3 3
        test1                              5     0     1   -b-      13.5 any cpu
        test1                              5     1     0   -b-       4.6 any cpu
        test2                              6     0     3   -b-      11.2 any cpu
        test2                              6     1     2   -b-       5.0 any cpu

#### Pin CPU's

- We want to bind 1 of the VCPU's of each host to a physical CPU:

        # xm vcpu-pin test1 1 1 
        # xm vcpu-pin test2 1 2comindico1
 comindico1
com

#### Final Configuration

- After pinning the VCPU's the configuration now looks like:

        # xm vcpu-list
        Name                              ID VCPUs   CPU State   Time(s) CPU Affinity
        Domain-0                           0     0     0   -b-  181901.0 0
        Domain-0                           0     1     1   r--  113443.3 1
        Domain-0                           0     2     2   -b-   87981.0 2
        Domain-0                           0     3     3   -b-   92222.5 3
        test1                              5     0     2   -b-      13.8 any cpu
        test1                              5     1     1   -b-       4.8 1
        test2                              6     0     3   -b-      11.4 any cpu
        test2                              6     1     2   -b-       5.2 2

