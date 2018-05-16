Categories: gerrit 
Tags: gerrit 
      git 
      rebase


## Checkout the `master` and pull the change

    git checkout master
    git pull

## Checkout the branch your working on and run a rebase

    git checkout DK_branch1
    git rebase master

### Fix conflicts

    git add <modified-file>
    git rebase --continue

## Update the commit (if changes were made)

    git commit --amend

## Run the review process

    git review -v
    

