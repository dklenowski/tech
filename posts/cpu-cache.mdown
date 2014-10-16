Categories: cpu
            linux
Tags: linux
      performance
      cpu
      cpu cache
      cache

## References ##

[1]     [http://en.wikipedia.org/wiki/CPU_cache](http://en.wikipedia.org/wiki/CPU_cache)

## Overview

- Typically CPU's have 3 cache's

### Level 1 Cache ###

- Stores instructions.

### Level 2 Cache ###

- Stores data.

### Level 3 Cache ###

- Stores data.

## Cache Prefetching

- Algorithm to pre-fill cache with data that is likely to be requested.

## Associativity ##

- Determines how memory is mapped in the cache.
- The associativity decides how many entries in the cache the CPU must potentially search.
- i.e.
  - Direct Mapped Cache
    - Best, only 1 place an entry can go.
  - 2-way Set Associative Cache 
    - Two places an entry can go in the cache.
- Checking more entries takes potentially more time.
- Caches with more associativity suffer fewer misses.
 - "Typically double the associativity has same effect on hit rate as doubling the cache size. But associativity increases above 4 way have little effect on the hit rate." [1]

## Example, Core i7 ##

- 32 kB L1 instruction cache (8-way set associative).
- 256 kB L2 cache (8-way set associative).
- 8 MB L3 cache (16-way associative).

## Fast Code

- Memory access is linear, memory will be prefetched.

        for (int i=0; i < 32; i++) {
          for (int j=0; j < 32; j++) {
            total += a[i][j];
          }
        }

## Not so Fast Code ##

- Requires more main memory accesses as memory access not linear.
- Therefore requires additional clock cycles to access the main memory.

        for (int i=0; i < 32; i++) {
          for (int j=0; j < 32; j++) {
            total += a[j][i];
          }
        }