Categories: unix
            linux
Tags: vi

### Enable spellchecker ###

      :setlocal spell spelllang=en_us

### Color Scheme

      :colorscheme murphy

### Highlighting

- Turn on highlighting

    :set hlsearch

### Cut and Paste

- `yy` - yank current line.
- `dd` - delete current line.

- Use `p` to paste.

### Previous Word 

- `b` - Stops at punctuation.
- `B` - Does not stop at punctuation.


### Next Word

- `w` - Stops at punctuation.
- `W` - Does not stop at punctuation.

### Auto-complete ###

    ctrl+p
    
    - use up/down arrow to select the required word.

### search/replace for select lines ###

    :8,80 s/^/#/g     # put comments on lines from 8 to 80
    :8,80 s/^#//g     # remove comments on lines from 8 to 80


### Split Screen

    sp [<filename>]        horizontal split
    vsp [<filename>]       Vertical split

### To move between the screens:

    ctrl+w [left arrow|right arrow|up arrow|down arrow]

### Deletes ###

- `D` - Delete from current character to end of line.
- `dw` - Delete word
- To delete lines 5 to 30

        :5,30d

### Inserts ###

- To insert a file below the cursor:

        :r <filename>


