Categories: solaris
Tags: alom

### setup ###

    #minicom -s
    
    /* Serial port setup */
    
    | A -    Serial Device      : /dev/ttyS0                                |
    | E -    Bps/Par/Bits       : 9600 8N1                                  |
    | F - Hardware Flow Control : Yes                                       |
    | G - Software Flow Control : No                                        |
    
    
    /* Modem and dialing */
    
     | A - Init string ......... ~^M~

    /* Save setup as dfl */

## Commands ##

### Get to `sc` prompt ###

    #.

### Display `sc` configuration ###

    sc> showsc -v

### Start Server ###

    sc> poweron

### Open Console ###

    sc> console
