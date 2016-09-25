Categories: git
Tags: empty
      repo

## On the `git` / remote host

- i.e. the server where the git repository will lie

        # mkdir castnet
        # cd castnet
        # git init --bare

# On the localhost / where you are working


        # git init
        # git add .
        # git commit -m "initial import."
        # git remote add origin ssh://evedder@some.remote.repo/repodir/
        # git push

# to verify

        # git show remote



