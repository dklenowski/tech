Categories: linux
            redhat
Tags: yum

## Installing specific versions/architectures of packages ##

- Ref: `man yum`

        SPECIFYING PACKAGE NAMES
        A package can be referred to for install, update, remove, list, info etc with any of the following as well as globs of any of the
        following:
               name
               name.arch
               name-ver
               name-ver-rel
               name-ver-rel.arch
               name-epoch:ver-rel.arch
               epoch:name-ver-rel.arch

## To determine what `basearch`/`releasever` yum will use ##


        # python -c 'import yum; yb = yum.YumBase(); print(yb.conf.yumvar)'
        Loaded plugins: langpacks, presto, refresh-packagekit
        {'releasever': '16', 'basearch': 'x86_64', 'arch': 'ia32e', 'uuid': 'a0edb459-70b8-4375-adf0-ffcbda25ef1c'}

        