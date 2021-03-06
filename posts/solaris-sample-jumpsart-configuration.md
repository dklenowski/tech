Categories: solaris
Tags: solaris
      jumpstart

### Package List

    # Core Solaris Operating Environment
    # cluster and a few other packages which contain critical functionality
    cluster         SUNWCreq

    # Sun Workshop Compilers Bundled libC ( in core)
    # package   SUNWlibC

    # To support the Network Time Protocol r - root, u - user
    package     SUNWntpr
    package     SUNWntpu

    # To support truss
    # utilities for software development, including ld, ldd, od, and truss
    package     SUNWtoo

    # to support DTRACE
    package     SUNWjdmk-base
    package     SUNWcacaort
    package     SUNWcacaodtrace

    # To support gzip
    package     SUNWgzip

    # To support tar (gnu tar)
    package     SUNWgcmn
    package     SUNWgtar

    # To support Secure Shell (Solaris 7+)
    # SUNWxwice - Library and utilities to support the X Window System Inter-Client Exchange (ICE) protocol
    package     SUNWxwice

    # To support Secure Shell X Tunneling
    #   SUNWxcu4t - XCU4 make and sccs utilities
    #   SUNWxcu4 - XCU4 Utilities
    #   SUNWxwpl - Platform specific X server supplementary links
    #   SUNWxwplr - X Window System platform software configuration
    #   SUNWxwplt - X Window System platform software
    package     SUNWxcu4
    package     SUNWxcu4t
    package     SUNWxwrtl
    package     SUNWxwpsr
    package     SUNWxwpl
    package     SUNWxwplr
    package     SUNWxwfnt
    package     SUNWxwplt

    # To support Solstice DiskSuite
    # SUNWsadml - Solstice Launcher.
    # SUNWmfrun - Motif RunTime Kit
    package     SUNWsadml
    package     SUNWctpls
    package     SUNWmfrun

    # To use showrev
    # SUNWadmap - System administration applications
    # SUNWadmc - System administration core libraries
    # SUNWadmfw - System & Network Administration Framework
    # package       SUNWadmap
    # package       SUNWadmc
    package     SUNWadmfr
    package     SUNWadmfw

    # to install man
    package     SUNWman
    package     SUNWdoc

    # for /usr/ucb stuff
    # SUNWpcr - client configuration files and utilities for the print service
    # SUNWpcu - client configuration files and utilities for the print service
    # SUNWscplp - print utilities for user interface and source build compatibility with SunOS 4.x
    # SUNWscpu - utilities for user interface and source build compatibility with SunOS 4.x
    package     SUNWpcr
    package     SUNWpcu
    package     SUNWscplp
    package     SUNWscpr
    package     SUNWscpu

    # for interprocess communication
    package     SUNWipc

    # volume managment
    package     SUNWvolr
    package     SUNWvolu

    # for oracle installation
    # SUNWarc SUNWarcr - Lint Libraries (usr)
    # SUNWbtool - CCS tools bundled with SunOS
    # SUNWhea - SunOS Header Files
    # SUNWsprot - Solaris Bundled tools
    package     SUNWarc
    package     SUNWbtool
    package     SUNWhea
    package     SUNWsprot

    #
    package SUNWgnome-base-libs-root
    package SUNWxi18n