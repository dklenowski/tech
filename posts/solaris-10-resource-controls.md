Categories: solaris
Tags: resource control
      prctl

## Projects ##

Notes:

- To create a project for a group, specify `group.<system_group>` as the project name.
- To create a project for a user, specify `user.<system_user>` as the project name.

### List Projects ###

Display what users are in what projects.

    # projects -l


### Dump limits for a project ###


    # prctl -i project default


### View project for current user ###


    # id -p

### Remove a project attribute ###


    # projmod -r -K process.max-stack-size group.oinstall


