Categories: bash
Tags: count

Using find, following example counts the number of lines of java (`wc` will display a sum at the end):

        find . -type f -name \*java -print -exec wc -l {} +