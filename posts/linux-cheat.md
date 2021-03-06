Categories: linux
Tags: securetty
      getconf
      setuid
      setgid
      ldap

## Miscellaneous

### LDAP Home directory creation

To enable creation of the home directory for LDAP based users add the following line to the `/etc/pam.d/system-auth` file.

        session required pam_mkhomedir.so mask=0022 skel=/etc/skel

### `securetty`

- List the names of tty's where root is allowed to login.
- Format is a tty (which root is allowed to login) on each line (tty is specified without the `/dev/` prefix).
- If the file does not exist, root is allowed to login on any tty.


### Run a find and exclude the "." directories ###

        # find ./ -maxdepth 1 -not -name ".*" -exec du -sh {} \;

### `getconf`

- Retrieve POSIX configuration variables.

        # getconf LONG_BIT        // whether 32/64 bit
        # getconf PAGE_SIZE       // page size in bytes

- To display all configuration (Redhat)

        # getconf -a /usr/libexec/getconf/


## Files

- In addition to standard `rwx` bits, 3 additional bits used.

#### SetUID

- Set user ID upon execution (for executable files).
- Has no effect for directories.

        -rws------      # Execute bit set along with SUID.
        -rwS------      # No execute bit set.

#### SetGID

- Set group ID upon execution (for executable files).
- For directories, any files/subdirectories created under SGID directories are created with the groupID of the owner (rather than the person creating the directory).

        ----rws---      # Execute bit set along with SGID.
        ----rwS---      # No execute bit set.

