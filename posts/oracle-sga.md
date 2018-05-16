Categories: oracle
Tags: sga

# Oracle SGA #

- Shared Global Area (SGA)

## granule 

- Memory in SGA assigned in contiguous blocks (granules)
- `SGA_MAX_SIZE < 128 MB` 1 granule = 4 MB
- `SGA_MAX_SIZE > 128 MB` 1 granule = 16 MB

- A minimum of 3 granules assigned to the SGA:
  - Granule 1 - Fixed part of SGA (e.g. redo buffers, locking information, database state information)
  - Granule 2 - Buffer Cache
  - Granule 3 - Shared Pool (e.g. library cache, data dictionary cache)

|   | Parameter | Sub Parameter | Notes |
|:--|:----------|:--------------|:------|
| Database Buffer Cache | db_cache_size | | |
| | | db_keep_cache_size | |
| | | db_recycle_cache_size | |
| Shared Pool | shared_pool_size | |
| | | shared_pool_reserved_size | Requires a database reset. Default is 5%, Oracle recommends 10% |
| Redo Log Buffer | log_buffer | | Requires a database reset. See Note: 30753.1. |
| Miscellaneous Pools | large_pool_size | | |
| | java_pool_size | | |

### Database Buffer (DB) Cache ###

- Caches database data, shared all user connections.
- 3 types:
  - Dirty Buffers - Data in buffer that is changed and needs to be written to disk.
  - Free Buffers - No data or free to be overwritten.
  - Pinned Buffers - Currently being access or explicitly retained for future use.
- Oracle uses 2 lists to manage buffer cache
  - Write List
      - aka dirty buffer list
      - buffers modified and need to be written to disk
  - LRU List
      - Contains free/pinned/dirty buffers that have been moved to the write list using LRU.
      - i.e. oracle process buffer, moves buffer to the MRU end of list.
- 3 sub-caches within the Database Buffer Cache.
  - KEEP Buffer Pool
      - Retains data blocks in memory (not aged out).
  - RECYCLE Buffer Pool
      - Removes buffers from memory as soon as they are not used.
  - DEFAULT Buffer Pool
      - Contains blocks that not assigned to other pools.

### Shared Pool ###

- Consists of
  - Library Cache 
      - Contains private/shared SQL areas, PL/SQL procedures and packages, and control structures. e..g locks and library cache handles.
      - Oracle divides each SQL statement that it executes into a Shared SQL Area and a Private SQL Area.
        - Shared SQL Area
          - Contains the parse tree and execution plan.
        - Private SQL Area
          - Contains the values for bind variables (persistent area) and runtime buffers

## SGA Parameters

### sga_max_size ###
- SGA cannot exceed this variable.

### Database Buffer Cache ###

#### db_block_size ####
- Size of the Oracle block in the buffer cache.

#### db_cache_size ####
- Size of the buffer cache.

#### db_keep_cache_size ####
- Size allocated to the KEEP pool.

#### db_recycle_cache_size ####
- Size allocated to the RECYCLE pool.

#### db_cache_advice ####
- Enable/disable statistics collection for caches 
- Values either `ON`, `OFF`, `READY`
- `v$db_cache_advice` contains statistics.

### Redo Log Buffer ###

#### log_buffer ####
- Size of the redo log buffer.


### Sizing ###

    Approximate SGA Size = shared_pool_size + log_buffer + large_pool_size + java_pool_size
    Approximate Memory = Approximate SGA Size + pga_aggregate_target

