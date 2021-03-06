Categories: linux
Tags: linux
      performance

## Reference ##

- Measuring Basic Linux Operations (Marisabel Guevara and Christopher Gregg, Spring 2009)

## Notes ##

- Old kernel Ubuntu 8.10 and 5400 rpm disks used..

## In General ##

### Kernel Calls, < 10 nanoseconds ###

- Basic (`getpid`, `sysconf` and `gettimeofday`) were tested.

### Context Switch (user interrupts), < 10 microseconds ###

- Context switch + simple operation (e.g. read 32 bits from a pipe).

### Page Allocation, < 1 ms for single page,  < 10 ms if page fault ###

- Greater the memory request, the greater the chance of a page fault.

### File read, < 30 ms/mb ###

- Evaluated both `mmap` and `read`.
- `read` faster than `mmap` for larger files.