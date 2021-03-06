Categories: mercurial
Tags: hg

## Miscellaneous ##

### Repository Location ###

        $ cd <mecurial-working-dir>
        $ cat .hg/hgrc 
        [paths]
        default = ssh://dave@random.host.com//repo/hg/repo1 


## Undoing Changes ##

- Reference [http://wiki.geeklog.net/index.php/Using_Mercurial](http://wiki.geeklog.net/index.php/Using_Mercurial)

### `hg revert`

- Revert changes made before commit.

### `hg rollback`

- Revert changes committed to local repo.

### `hg backout`

- Revert changes that have been committed and pushed (by creating a new version and applying the modifications).

## Branching ##

### Show available branches ###

    # hg branches
    lrutweaks                     65:5586c1232dc7
    default                       63:d9feddceabb8 (inactive)

- `inactive` describes a branch with no topological head.

### Show the current branch

    # hg branch
    default

### Switching ###

    # hg update -C lrutweaks
    # hg branch
    lrutweaks

#### Switching to a specific revision ####

    # hg update -r<REV>

### Create a branch ###

    # hg branch <branchname>
    # hg ci -m "branch creation"
    # hg push

- Note, in eclipse, select the `Team > Add Branch` and then you need to `push` the changes to the remote repo.

### Merging features from branch to parent ###

- Assuming you are currently in `feature-x`

        # hg up default
        # hg merge feature-x
        # hg ci -m "merged feature-x to defeault"
