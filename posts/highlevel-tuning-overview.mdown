Categories: computing
Tags: tuning
      dma
      udma

## Hardware ##

- QuickPath Interconnects (QPI) 
  - Replaces FSB (Northbridge/Southbridge)
  - 64 bits (requires 2 clocks)
- CPU
  - 64 bit cache line
- iommu (requires support on motherboard)
  - esp when using 32 bit devices (i.e. avoid bounce buffers)
- Fast disks
- Enough memory

### Disks ###

- DMA/UDMA

## Operating System ##

### IO Schedulers ###

- e.g. noop, deadline, anticipatory, cfq

### Virtual Memory ###

- e.g. swappiness, huge pages

### Network ###

- Receive socket memory.
- Send socket memory.
- Memory buffers

### Filesystem ###

- ext4
- xfs (rhel 6)
- zfs?

### Processes ###

- Tie processes to cpu (schedutils/taskset)

## Router ##

- CEF (uses forward information base (FIB) and adjacency table).
- Buffer Tuning (done only when packets cant be CEF switched).

## Gathering Stats ##

### `ps`

        -e Select all processes.
        -f Long format.
        -l Longer (BSD) style format.


### Combination Memory/Disk/Memory 

#### `vmstat`

- Display's memory/paging/io/cpu statistics.
- Can be used to determine excessive paging (`si`/`so`)
- To run vmstat every 3 seconds:

        # vmstat 3


### Disk

#### `iostat`

- Retrieves disk statistics (tps, reads/sec, writes/sec)
- Requires the `sysstat` package.

### Network

#### `ss`

- Dump socket statistics (in summary form).

### CPU

#### `mpstat`

- Multiprocessor usage.

        # mpstat -P ALL

### Lock Contention ###

#### `pidstat`

### Memory

#### `free`

- Display memory statistics.

        # free -m 

- `-m` displays megabytes.

