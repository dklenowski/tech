Categories: linux
Tags: nfs

## Server

### Options 

#### `rw`
- Allow NFS share to be accessed as a “read-write” share.

#### `sync`

- The server will complete a synchronous NFS version 3 request without delay, and will return the status of the data in order to inform the client as to what data should be maintained in its caches, and what data is safe to discard.

#### `no_subtree_check`

- By default every file request is check to make sure requested file is in an exported subdirectory. 
- This turns off default, and only verification that the file is in an exported filesystem is made.

#### `no_wdelay`

- Turns off NFS write optimisation.
- i.e. NFS delay's committing a write request to disc if it suspects another related write request may be in progress or may arrive 
- e.g. if the NFS server has small/unrelated requests this option can reduce performance and should be turned off.

#### `nohide`

- Setting the `nohide` option on a filesystem causes it not to be hidden, and an appropriately authorised client will be able to move from the parent to that filesystem without noticing the change.

#### `anonuid=<uid>` and `anongid=<gid>`

- Set the anonymous uid and gid when accessing the NFS shared.
- By default `nfsnobody` is used for both


### Configuration (for NFSv4) ###

#### `/etc/idmapd.conf`

      Domain = test.com
      Nobody-User = nfsnobody
      Nobody-Group = nfsnobody

- To restart idmdapd:

        # service rpcidmapd restart


### `/etc/exports` ###

      /export 192.168.1.0/24(fsid=0,ro,insecure,all_squash,no_subtree_check)
      /export/backups 192.168.1.0/24(rw,insecure,all_squash,no_subtree_check)

### Directory Permissions

      # chmod 777 /export/backups/
      # chown nfsnobody:nfsnobody /export/backups/

## Client ##

### Options

#### `insecure` ####

- Allows clients with NFS implements that don't use a reserved port for NFS.

#### `hard` ####

- NFS file operations continue to retry indefinitely.

#### `intr` ####

- Allow NFS file operations to be interrupted (i.e. via `Ctrl-C`)

#### `noatime` ####

- Do not update inode access times on this file system

#### `nodiratime`

- Do not update directory inode access times on this filesystem.

#### `rsize=32768` ####

- The number of bytes the NFS client requests from the NFS server in a single read request.

#### `wsize=32768` ####

- The number of bytes the NFS client sends to the NFS server in a single write request.

### Configuration (for NFSv4) ###

#### `/etc/idmapd.conf`

      Domain = test.com
      Nobody-User = nfsnobody
      Nobody-Group = nfsnobody

- To restart idmdapd:

          # service rpcidmapd restart


### `/etc/fstab` ###

      nfs.test.com:/backups /export/backups   nfs4    proto=tcp,intr,rsize=32768,wsize=327687 0 2

## Firewall's

### NFSv4

- NFSv4 requires the following ports to be open:

          2049 TCP      NFSv4 protocol
          2049 UDP      NFSv4 PROTOCOL
          111  TCP      portmapper
          111  UDP      portmapper

### NFSv3

- NFSv3 uses random ports for protocol initialization and the exchange of information.
- To hardcode the ports, edit `/etc/sysconfig/nfs` and update the following (the port assignments can be random but should be at the higher end, to avoid conflicts with existing ports/ephemeral ports etc):

          STATD_PORT=60001
          LOCKD_TCPPORT=60002
          LOCKD_UDPPORT=60003
          MOUNTD_PORT=60004
          RQUOTAD_PORT=60005

#### Verification ####

- To verify that the correct ports are allowed, enter the following command on the NFS client

          # rpcinfo -p <nfs_server>
