Categories:  storage
Tags: raid
      storage
      mirror
      strip
      parity

# Overview #

## raid-0

- Striping no redundancy.

## raid-1

- Mirroring.

## raid-5

- Striping with distributed parity.

## raid-6

- Striping with additional distributed parity.

## raid-10

- Striping over mirror sets.

## raid-50

- Striping over raid 5 sets.

## raid-60

- Striping over more than one span of physical disks that are configured as raid 6.

## Detail

## Raid 0 (Striping/Concatenation)

  * >= 2 physical disks combined to form logical device.
  * Striping
    * Data interlaced across multiple physical devices (improved IO).
  * Concurrent access (controllers work in parallel).
  * Data streams placed across multiple disks in equal sized chunks.
  * ADV
    * Multiple chunks can be written in parallel.
    * Chunk sizes can be optimised for sequential/random access.
  * DISADV
    * No data redundancy/parity protection.
    * Can decrease MTBF.

## Raid 1 (Mirroring/Shadowing)

  * Data written to 2 independent disks.
  * ADV
    * 100% redundancy.
    * Increases read performance (if disks on separate controllers)
    * High MTBF.
  * DISADV
    * Every write has to be duplicated.

## Raid 0+1 (Striping+Mirroring)

  * Stripe disks in mirror.
  * ADV
    * Some RAID software can return data from least busiest device.
  * DISADV
    * Double number of disks in configuration.
    * Increased write performance (e.g. in 2 controllers degradation can be
nominal around 4%).

## Raid 3 (Striping with dedicated parity)

  * Singe drive stores parity/error correction information.
  * Data striped across remaining drives.
  * ADV
    * Bandwidth equal to n-1 disk transfer rate.
    * All disk read from or written to simultaneously (NB single chunk random
IO slows RAID group to performance of a single disk).
    * Provides good sequential transfer rates, at the expense of random IO
performance.

## Raid 5 (Striping with distributed parity)

  * Data/parity interlaced across multiple physical devices.
  * Provides redundancy (distributed parity) and load balancing.
  * Parity written for every write operation (parity avoids cost of full
duplication of disk drives of Raid 1).
  * Parity can be used to reconstruct disk (in case of loss).
  * Both data and parity spread across all disks in the array.
  * ADV
    * Read performance improved (reads/sec can reach the individual disk rate
times the number of disks).
    * Parity constitutes a 20% overhead compared to 100% overhead in Raid 1.
  * DISADV
    * Write Penalty - Each write incurs additional overhead of reading old
parity, computing new parity and writing actual data (last 2 operations
simultaneously lock 2 drives).

    * i.e. single chunk write requires 4 operations:
      1. Read old data
      2. Read old parity
      3. write new data, calculate new parity
      4. write new parity

    * If disk fails, IO penalty incurred during disk rebuild is extremely
high.

  * Read intensive applications (DSS, data warehousing) can use Raid 5 without
major real-time performance degradation.

## Raid S

  * EMC Raid 5 solution.
  * Differs from Raid 5 in that:
    * Stripes parity, does not stripe data.
    * Async write cache (used to defer writes, so overhead of calculating and
writing parity info can be done when the system is less busy).
  * DISADV
    * Striping of data not automatic and has to be done manually by 3rd party
disk management software.

# Oracle on Raid

## Raid 1

  * Most useful where complete redundancy must and disk space not issue.
  * Large datafiles, may not be feasible.
  * Writes under this level are no faster and no slower than 'usual'.

## Raid *

  * For all other levels of Raid, writes will tend to be slower and reads will
be faster than under 'usual' filesystem.

### Data Striping

  * ADV
    * Logical files created can be large than maximum size suported by OS
  * DISADV
    * Cant local single datafile on specific physical drive (may cause some
loss of application tuning capabilities).
    * Increased database recovery time (for single disk failure, all disks in
strip must be involved in recovery).

## File Layout

  * In general, Raid usually impacts write operations more than read
operations.


    RAID            Control File    Database File   Redo Log File   Archive
Log File

    0   Striping    Avoid*          OK*             Avoid*          Avoid*

    1   Mirror      OK              OK              REcommended
Recommended

    0+1             OK              Recommended (1) Avoid           Avoid

    3               OK              Avoid (2)       Avoid           Avoid

    5               OK              Avoid (2)       Avoid           Avoid


    * RAID 0 has no protection against failures (requires strong backup
strategy)

    1 RAID 0+1 recommended for database files because this avoids hot spots
and

      gives best posibility of performance during a disk failure

      Disadv: costly configuration

    2 When heavy write operation involves this datafile


### datafiles/archive log files

  * Accessed randomly.

### redo logs

  * Database sensitive to read/write performance of redo logs should be on
Raid 1, Raid 0+1 or no raid (since access sequentially and performance is
enhanced in their case by having the disk drive head near the last write
location).

### temp tablespace

  * Should also go on Raid 1 (instead of Raid 5)
  * i.e. stream write performance of distributed parity (Raid 5) isn't as goog
as that of simple mirroring (Raid 1).

### Swap Space

  * Can be used on RAID devices without affecting Oracle performance.

