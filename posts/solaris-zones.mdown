Categories: solaris
Tags: zones

## Solaris Zones

### Cheat Sheet ###

#### List Zones on a System ####

    zoneadm list -vi


### Types ###

#### Global ####

- Server itself.
- Therefore only 1 global zone on a physical server.

### Non-Global ###

- Created from global zone and managed by it.
- Same OS and characteristics as Global zone (since they share the same kernel).
- As of Solaris 10 version 08/07, possible to use a different environment inside a non-global zone (called a branded zone (BrandZ)).

### Branded ###

- Allows alternative runtime configuration within the zone.
- e.g. Linux OS zone, Note, does not actually run the Linux OS, instead enables binary applications designed for specific distributions of linux to run unmodified within the Solaris zone.
- "Brand" defines operating environment to be installed and how the system will behave.

### States ###

#### Configured ####

- Configuration completed, storage committed.
- Still requires further configuration to be "Ready"

#### Incomplete ####

- During an install/uninstall operation.

#### Installed ####

- Confirmed configuration.
- Packages have been installed under the zone's root path.
- Still has no virtual platform associated with it.

#### Ready ####

- Zones virtual platform established.
- Kernel creates `zsched` process, network interfaces plumbed and file systems are mounted.
- System also assigns a zone ID at this state, but no processes are associated with the it.

#### Running ####

- When first user process created.
- Normal state for an operational zone.

#### Shutting Down ####

- Transitional state for shutting down.

#### Down ####

- Halted.

### Features ###

Reference: Solaris 10 System Administration Exam Prep: Exam CX-310-202, Part II

- The global zone has the following features:

    - The global zone is assigned zone ID 0 by the system.
    - It provides the single bootable instance of the Solaris Operating Environment that runs on the system.
    - It contains a full installation of Solaris system packages.
    - It can contain additional software, packages, file, or data that was not installed through the packages mechanism.
    - Contains a complete product database of all installed software components.
    - It holds configuration information specific to the global zone, such as the global zone hostname and the file system table.
    - It is the only zone that is aware of all file systems and devices on the system.
    - It is the only zone that is aware of nonglobal zones and their configuration.
    - It is the only zone from which a nonglobal zone can be configured, installed, managed, and uninstalled.

- Nonglobal zones have the following features:

    - The nonglobal zone is assigned a zone ID by the system when it is booted.
    - It shares the Solaris kernel that is booted from the global zone.
    - It contains a subset of the installed Solaris system packages.
    - It can contain additional software packages, shared from the global zone.
    - It can contain additional software packages that are not shared from the global zone.
    - It can contain additional software, files, or data that was not installed using the package mechanism, or shared from the global zone.
    - It contains a complete product database of all software components that are installed in the zone. This includes software that was installed independently of the global zone as well as software shared from the global zone.
    - It is unaware of the existence of other zones.
    - It cannot install, manage, or uninstall other zones, including itself.
    - It contains configuration information specific to itself, the nonglobal zone, such as the nonglobal zone hostname and file system table, domain name, and NIS server.
    - A nonglobal zone cannot be an NFS server.



