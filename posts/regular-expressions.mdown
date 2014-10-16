Categories: unix
Tags: regular expression
      regex

## Regular Expressions

### Ref : Unix Power Tools (Chap 26 Regular Expressions)

- Don’t confuse regexes with filename matching patterns (regexes must be quoted so the shell wont expand the arguments before passing them to the program).

## Metacharacters

  - `.` - Match any single character except the end of line character
  - `*` - Matches zero or more occurrences of the preceding regular expression. By itself does not match anything in a regular expression, i.e. it modifies what goes before it. e.g. the .`*` matches any number of characters

## Types of regexp’s

- Simple and Extended (Boundaries between the 2 have become blurred (simple regexes have evolved over time)
- 3 parts to a regex:

### Anchors

- used to specify the pattern in relation to a line of text

#### `^`

- starting anchor
- is only anchor if it is the first character
- e.g. `^A` Match `A` at the start of the line

#### `$`

- end anchor
- is only an anchor if it is hte last character
- e.g. `A$` Match `A` at the end of the line
- Note, if anchor characters not used at the proper end of the pattern (they no longer act as anchors)

### Character Sets

- Match >= 1 characters in a single position

#### `[]`

- Used to match specific characters
- Use a hyphen to specify a range of characters
- i.e. a contiguous set of characters from low to high in the ASCII chart

#### `^`

- Inside a square bracket as the first character will negate the search.
- i.e. search for all characters except those in the square bracket.
- e.g. to match all characters except vowels [^aeiou]

### Modifiers

- Specify how many times the previous character set is repeated

#### `*`

- Matches zero or more copies
- e.g. ^#* is useless as it matches any number of “#“‘s at the beginning of the line (including zero). therefore this will match every line !!
- e.g. if you wanted to look for a digit at the beginning of the line and there may may not be spaces before the digit you would use

#### `^ *`

- which will match 0 or more spaces at the beginning of the line

## Matching Sets

- use `\{` and `/}` to match sets.
- e.g.

        \{min,max\} min     minimum number of matches (range 0 - 255)
                   max     maximum number of matches (range 0 - 255)
                            can be omitted, which removes the upper limit.

- Only work if it follows a character set.
- Notes:
  - Must backslash the “{”
  - Normally a backslash turns off the special meaning for a character.
  - However if a backslash is placed before a <, >, {, }, (, ) or before a digit the backslash turns on a special meaning.
  - Because these special meanings were added late in the life of a regular expression and changing the meanings of <, > etc would have broken old expressions

## Matching words

- use `\<` and `\>` to match words.
- anchor the expression between to match only if it is on a word boundary word boundary
- e.g. to search for the words “the” or “The” use the following expression

        \<[tT]he\>

  - The character before the “t” or “T” must be either a newline character or anything except a letter, digit or underscore (i.e the word boundary)
  - The character after the “e” must also be a character other than a digit letter or underscore or it could be the end of line character

## Remembering patterns

- Some programs can mark part of a pattern using `\(` and `\)` can recall the remembered pattern using \ followed by a single digit
- e.g. to search for 2 identical letters use

        \([a-z]\)\1

- Can have up to 9 different remembered patterns where each occurrence of \( starts a new pattern
- e.g. to match a five letter palindrome e.g. radar use

        \([a-z])\([a-z]\)[a-z]\2\1

## Extended Regular Expressions

- egrep and awk (perl uses regular expressions that are more extended) use extended regular expressions
- in extended regular expressions, those special characters preceded by a backslash no longer have special meaning
- e.g. cant use (, ), {, } etc
- `?` - Matches zero or one instances of the character set before it
- `+` - Matches 1 or more copies of the character set
- Additional meta-characters for extended regular expressions are (, | and )
  - `(, )` - Used to group expressions
  - `|` - Acts as an OR operator
  - Together they let you match a choice of patterns

- e.g. using egrep to print all “From:” and “Subject:” lines use

        % egrep '^(From|Subject): ' /usr/spool/mail/$USER

- (There is no easy way to do this with regular expressions).
- e.g. To match words (since there are \< and >) could do the following

        (^|)the([^a-z]|$)

- i.e. 2 choices for the beginning of the line a space or the beginning of the line
- following the word, there must be something besides a lowercase letter or the end of the line
- e.g. to match “a simple problem”, “an easy problem” as well as “a problem” could be

        % egrep "a[n]? ((simple|easy) )?problem" data

- The reason why backslash special characters are not used in extended regular expressions:
  - No easy way to add the /(…/) functionality without changing the current usage.
  - i.e. ( already has a special meaning, therefore /( must be the ordinary character !!

## Limiting Extent of a Match

- A regular expression will try to match the longest string possible (i.e. is greedy)