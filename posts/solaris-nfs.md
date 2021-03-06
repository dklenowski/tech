Categories: solaris
Tags: nfs

### Daemons

- `nfsd` - (server) NFS daemon.
- `mountd` - (server) handles client requests.
- `lockd` - (client and server) handles file lock requests.
- `statd` - (client and server) network status monitor daemon. e.g. allows locks to be reset properly after crash.

### Share a filesystem

1. Share filesystem.

        $ share -F nfs [-o <options> ] <pathname>
        <options>   - e.g. ro, rw

  - shares created using the `share` command are not persistent, for persistence add entry to `/etc/dfs/dfstab`.

2. Start NFS

        $ /etc/init.d/nfs.server start

### Sharing ###

#### Mount all shares ####

- Share all entries `in /etc/dfs/dfstab`

        $ shareall      

#### Unmount all shares ####

      $ unshareall

### Troubleshooting

#### Display host shares

      $ showmount -e localhost

#### Display host shares with detail

      $ dfshares
      RESOURCE                                  SERVER ACCESS    TRANSPORT
          nagios:/export/jumpstart              nagios  -         -
          nagios:/jmp/install                   nagios  -         -

