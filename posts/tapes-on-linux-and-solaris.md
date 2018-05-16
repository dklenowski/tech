Categories: unix
Tags: tapes
      mt
      rmt

## Tapes on linux and solaris

- The major disadvantage of tapes is that they only provide sequential access to files (which means you must step through the files to get to the one you want)
- When a ufsdump occurs to tape, the files are placed on the tape in “chunks” that are separated from each other with “marks”. When the tape is first placed in the drive, it will reside on no mark (EOF). i.e. File 0. You then have to forward it to the file/chunk you want.
- Device lettering:
  - Linux `/dev/rmt`
  - SunOS `/dev`

- Device numbering in /dev/rmt:

        The device number consists of :
            letter  Specifies density and compression
            h   high density
            m   medium density
            l   low density
            c   uncompressed
            u   ultra compressed
            n   optional, specifies no rewind
            2 letter interface code     st - scsi tape
                                        mt - non scsi tape 9 track tape
        1/2 ditit number    Encodes device number, density and compression
                    0-7         Low density
                    8-15        medium density
                    16 - 23     high density
                    24 - 31     compressed

- e.g.

        # hostdump.sh 0 /dev/rmt/0cn /var/tmp/hostdump.log

## Process for recovering a file/s

### 1. Insert the tape and check the status

    # mt -f /dev/rmt/0n status
    Quantum DLT7000 tape drive:
    sense key(0x6)= Unit Attention   residual= 0   retries= 0
    file no= 0   block no= 0

- From the above output you can see that you are at file “0” on the tape.

### 2. Check the backup utility for the location of the backed up data file position on the tape and move to the location

- e.g. to move the tape to “file 5” issue the following command

        # mt -f /dev/rmt/0n fsf 5

- and check the status:

        # mt -f /dev/rmt/0n status
        Quantum DLT7000 tape drive:
           sense key(0x0)= No Additional Sense   residual= 0   retries= 0
           file no= 5   block no= 0

- If there is no `n` in `0n` at the end of the device file, the tape will rewind on every operation (not recommended).

### 3. Run the “ufsrestore” command in interactive mode

        # ufsrestore -if /dev/rmt/0n

- `-i` specifies interactive mode

### 4. Once you are at the `ufsrestore >` prompt you can move around as if it was a normal filesystem

- Interactive mode does have a help facility (type “help” at the prompt)
- The commands that are most often used:

        add [ <file> | <directory> ]
            Adds the file / directory to a list of files that will be restored.
             
        extract
            The files that were "add"ed are extracted to disk.
            They will be extracted relative to the location
            where you issued the ufsrestore command
        
        marked
            List the items that are marked for extraction.

- Notes:

- The files are extracted relative to the directory where the ufsrestore command was issued.
- The directory structure is preserved from the backup, minus the original “root” filesystem
- e.g. If the file was backed up as `/u/export/db/save` and you extracted it to `/export/home/restore` the restored file will be placed in `/export/home/restore/export/db/save`.
- When you type extract, it will usually print the following:

        You have not read any volumes yet.
        Unless you know which volume your file(s) are on you should start
        with the last volume and work towards the first.
        Specify next volume #: 1
        set owner/mode for '.'? [yn] y
        Directories already exist, set modes anyway? [yn] n

  - For the first question `specify next volume` just type `1`.
  - For the second question `set owner/mode for .` type yes if you want to preserve the ownership and mode preserved.

## Linux Notes

- When amanda finishes a backup, puts the tape in the offline state.
- i.e.

        serv# mt -f /dev/nst0 status
        SCSI 2 tape drive:
        File number=-1, block number=-1, partition=0.
        Tape block size 0 bytes. Density code 0x0 (default).
        Soft error count since last status=0
        General status bits on (10000):
         IM_REP_EN

- To put tape back online:

        serv# mt -f /dev/nst0 load
        serv# mt -f /dev/nst0 status
        SCSI 2 tape drive:
        File number=0, block number=0, partition=0.
        Tape block size 0 bytes. Density code 0x19 (unknown to this mt).
        Soft error count since last status=0
        General status bits on (41010000):
         BOT ONLINE IM_REP_EN

- To restore from amanda:

        serv# amrestore /dev/nst0 <HOST> <FILESYSTEM>

  - Will extract files into the current directory.