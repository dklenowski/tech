Categories: git
Tags: branch
      remote


## Cheats

### Quick view log messages

    git log --pretty=oneline

### Undo the previous commit

    git reset --soft HEAD^1

- `1` down from `HEAD`
- `soft` keeps file changes (as unstaged changes)
- `hard` undoes all changes.

### Push a local branch to a remote repository

    git push -u origin <local-branch-name>

- `-u` ensures a *tracking* branch is created (i.e. a relationship between local and remote).

### List remote repo's (including upstream repo's)

    git remote -v
    origin  https://github.com/davidk/redisutil.git (fetch)
    origin  https://github.com/davidk/redisutil.git (push)

### Add an upstream repo

    git remote add upstream git://github.com/path/to/forked/repo.git
    git fetch upstream

### Merging from an upstream repo

    git remote add upstream git://github.com/path/to/forked/repo.git
    git fetch upstream
    git merge upstream/master

## Setup

## Current config

    git config --global -l

### Custom Config

    git config --global user.name "david"
    git config --global user.email eddie@gmail.com
    git config --global color.ui true
    git config --global http.sslverify 0
    git config --global core.editor /usr/bin/vim
    git config --global core.excludesfile ~/.gitignore_global

## Standard Stuff

    export GIT_EDITOR=vim
    git add <file>
    git commit -m "message" <file>

## Commit Cheats

### Undo staged changes

    git reset HEAD

## Branches

Format: `(remote)/(branch)` e.g. `origin/master`

## Branch Cheats

    git branch -a      # local + remote branches
    git branch -r      # remote branches
    git branch -v      # local + remote branches with latest commit message

## Merging

- Creates a `merge` commit that contains `master/branch` changes

        git checkout master
        git pull
        git checkout <branch-name>
        git merge

## Rebasing

- Applies all changes on one branch/master to another branch/master
- (effectively abandoning existing commits and applying new ones).

        git checkout master
        git pull
        git checkout <branch-name>
        git rebase master

## Creating a repository

- Want to create a *bare* repository (i.e. a repo that only has a `.git` directory) so you can push commits.

        cd <gitdir>
        git --bare init
