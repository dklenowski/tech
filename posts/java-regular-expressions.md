Categories: java
Tags: pattern
      matcher
      regex

## Java Regular Expressions

- Consists of:
  - Pattern Class - Used to represent regular expressions (see Javadoc for types of regular expressions allowed).
  - Matcher Class - Matches a regular expression against the input stream.

## Pattern Class

- Regular expressions, represented by a string, is compiled into an instance of the Pattern class, using:

        Pattern.compile()

- Can then perform operations using methods in the Pattern class (e.g. split()) or methods in the matches class.
- e.g.

        import java.util.regex.*;
        
        public class splitter {
               public class splitText()   {
                      // create Pattern to match breaks
                      Pattern p = Pattern.compile("[,\\s]+");
                      // split the input with the pattern
                      String[] res = p.split("one, two, three   four");
               }


## Matcher Class

- Used to match character sequences against a given sequence pattern.
- Matcher created by invoking Pattern's matcher() method.
- A Matcher can perform 3 difference operations:
  - `matches()` method matches the entire input sequence against the pattern.
  - `lookingAt()` method attempts to match the input sequence, starting at the beginning against the pattern.
  - `find()` method scans the input sequence looking for the next sequence that matches the pattern.
- e.g. simple word replacement

        public replace()     {
               Pattern p = p.compile("cat");
               Matcher m = p.matcher("one two three cat");
               StringBuffer sb = new StringBuffer();
        
               while ( m.find() )     {
                      m.appendReplacement(sb, "dog");
               }
               // add the last segment of input to the new string
               m.appendTail(sb);
        }

## Regular Expression Groups

- A group is a numbered part of a regular expression
- e.g.

        "(\\d+)zzz"
        Group 0 - Refers to the whole expression
        Group 1 - Sub-expression starts with ( and finishes with )

- The text of matched groups is saved by the regular expression
- e.g.

        /* matches will be "123" and "456" */
        public groupTest()   {
          String a[] = { "abc 123 def", "456 ghi" };
          Pattern p = Pattern.compile("(\\d+)");
        
          for( int i = 0; i < a.length; i++ ) {
            String str = a[i];
            if ( m.find() ) {
              System.out.println("Match = " + match.group(1));
            }
          }
        }

- Can also reference individual groups from the pattern
- e.g.

        "(\\d+).*\\1"
        \\1 - back reference to the first group in the expression. For a match, input sequence must contain a number followed by any characters followed by the original number.

- Can also be used for string editing
- e.g.

        public demo()        {
          String a[] = { "abc 123 def   123",  "456 ghi", "123.123" };
          Pattern p = Pattern.compile("(\\d+)");
        
          for( int i = 0; i < a.length; i++)      {
               String str = a[i];
               Matcher m = p.matcher(str);
               StringBuffer sb = new StringBuffer();
        
               while ( m.find() )     {
                  match.appendReplacement(sb, "[$1]");
               }
        
               match.appendTail(sb);
               System.out.println(sb.toString());
          }

- where:
  - `appendReplacement()` - Replace matched text in the input with a new string.
  - `appendTail()` - Used to append the rest of the input (after the match) to the output