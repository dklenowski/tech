Categories: linux
Tags: linux
      screen

## List `screen`s ##

      # screen -ls

## Detach current `screen`

      <ctrl>-A d

## Create a new window in the current `screen`
 
      <ctrl>-A c

## Resume screen ##

      # screen -r <name>

- where `<name>` is from `screen -ls`
  

## Exit from current `screen` ##

      <ctrl>-A K

- or type `exit` in `screen` (if possible).

## Logging `screen` output ##

      <ctrl>-A H

- Command above entered in the `screen` where logging is required.
- To finish logging (and save the log), repeat the command above.
- Logs to a file called `hardcopy.<n>` in the `cwd` (i.e. the directory where screen was started).


## Kill a `screen` ##

      # screen -X -S <name> kill

- where `<name>` is from `screen -ls`

