Categories: mecurial
            git
Tags: git 
      mercurial

## Preliminaries ##

- Clone `fast-export` from [http://repo.or.cz/w/fast-export.git](http://repo.or.cz/w/fast-export.git)

## 1. Create a authors file (to map mercurial users to git users)

        # cat ~/authors 
        dave=davek <dklenowski@blah.net>
        dave:javautil dave$ 

## 2. Create a local git repository (to import into) ##

        # mkdir <git-project>
        # cd <git-project>/
        # git init

## 3. Import from a mercurial repository ##

- Note the `cwd` where the command is run must be the git repo created in `2`

        # cd <git-project>
        # ~/fast-export/hg-fast-export.sh -A <authors> -r /<hg-project>/

## 4. Run a checkout ##

        # cd <git-project>
        # git checkout head

## 5. Push to github

        # cd <git-project>
        # git remote add origin git@github.com:<github-user>/<git-project>.git
        # git push -u origin master

## Checking out in Eclipse (on Mac) ##

        URI: git@github.com:<github-user>/<git-project>.git
        Protocol: ssh
        User: git
        Store in Secure Store: unchecked
        
        

