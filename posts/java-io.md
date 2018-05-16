Categories: java
Tags: io
      fileinputstream
      inputstream
      stream

## File IO ##

- Divided into input and output classes.
- All input classes are derived from `InputStream` or `Reader` which have basic methods.
  - e.g. `read()` for reading a single byte or array of bytes.
- All output classes are derived from `OutputStream` or `Writer` which have basic methods.
  - e.g. `write()` to write a single byte or array of bytes.

## `InputStream` ##

-  Represent classes that produce read from different sources.
-  e.g.
  - Array of bytes.
  - String of objects.
  - File.
  - A pipe. 
  - etc

| Class/Superclass | Function | Constructor | Use |
| :----------------- | :--------------------- | :------------------- | :------------------- | 
| `ByteArrayInputStream`<br/>`InputStream` | Allows buffer in memory to be used as an input stream. | `(byte[] buf)`<br/>`(byte[] buf, int offset, int length)` | Use as a source of data. e.g. can connect to a `FilterInputStream`. |
| `StringBufferInputStream`<br/>`InputStream` | Convert a `String` into a `InputStream`. | `(String s)` | Underlying implementation uses a `StringBuffer`. Preferred way to use a `Reader`. |
| `FileInputStream`<br/>`InputStream` | Read information from a file. | `(File f)`<br/>`(FileDescriptor fd)`<br/>`(String name)` | Can connect to a `FilterInputStream`. |
| `PipedInputStream`<br/>`InputStream` | Writes data to the associated `PipedOutputStream`. | `(PipedOutputStream pos)` | e.g. source of data for multithreading. Can be connected to a `FilterInputStream`. |
| `SequenceInputStream`<br/>`InputStream` | Converts >= 2 `InputStream`'s to a single `InputStream`. | `(Enumeration e)`<br/>`(InputStream in1, InputStream in2)` | Source of data. Can connect to a `FilterInputStream`. |
| `FilterInputStream`<br/>`InputStream` | Abstract class. Provides an interface for decorators. | `(InputStream in)` |  |

### `FilterInputStream`

- Modifies the way `InputStream` behaves internally (i.e. decorator).
- e.g. whether it is buffered, keeps track of lines read etc.

| Class/Superclass | Function | Constructor | Use |
| :----------------- | :--------------------- | :------------------- | :------------------- | 
| `DataInputStream`<br/>`FilterInputStream` | Used along with `DataOutputStream` to read primitives (e.g. int, char, long) from a stream in a portable fashion. | `(InputStream in)` | Contains a full interface to read primitives. |
| `BufferedInputStream`<br/>`FilterInputStream` | Uses buffer (prevent physical read's every time data read). | `(InputStream in)`<br/>`(InputStream in, int size) | Doesn't provide an interface per se, just a requirement a buffer is used. |
| `LineNumberInputStream`<br/>`FilterInputStream` | Keeps track of line numbers in the `InputStream`. | `(InputStream in)` | Use `LineNumberReader` instead. |
| `PushbackInputStream`<br/>`FilterInputStream` | Has a 1 byte push back buffer so you can push back the last character read. | `(InputStream in)` | |

## `OutputStream` 

- Represent classes that write output to different destinations.

| Class/Superclass | Function | Constructor | Use |
| :----------------- | :--------------------- | :------------------- | :------------------- |
| `ByteArrayOutputStream`<br/>`OutputStream` | Creates a buffer in memory where all data sent. | `()`<br/>`(int size)` | Used to designate destination for data. Connect to `FilterOutputStream` for a useful interface. |
| `FileOutputStream`<br/>`OutputStream` | For sending information to a file. | `(File f)`<br/>`(File f, boolean append)`<br/> etc. | Can connect to a `FilterOuputStream`. |
| `PipedOutputStream`<br/>`OutputStream` | Any information ends up as the input for the associated `PipedInputStream`. | `(PipedInputStream sink)` | e.g. for multi-threading. Can connect to a `FilterOuputStream`. |
| `FilterOutputStream`<br/>`OutputStream` | Abstract class. Provides an interface for decorators. | `(OutputStream out)` | |

### `FilterOutputStream`

- Modifies the way `OutputStream` behaves internally (i.e. decorator).

| Class/Superclass | Function | Constructor | Use |
| :----------------- | :--------------------- | :------------------- | :------------------- |
| `DataOutputStream`<br/>`FilterOutputStream` | Used along with `DataInputStream` to write primitives (e.g. int, char, long) to a stream. | `(OutputStream out)` | Contains full interface to write primitive datatypes. |
| `BufferredOutputStream`<br/>`FilterOutputStream` | Uses buffer (prevent physical writes every time data written). | `(OutputStream out)`<br/>`(OutputStream out, int size)` | Doesn't provide an interface per se, just a requirement that a buffer is used. |
| `PrintStream`<br/>`FilterOutputStream` | For producing formatted output. | `(OutputStream out)`<br/>`(OutputStream out, boolean autoFlush)`<br/> etc. | Should be the 'final' wrapping for your `OutputStream` object. |

Notes:
  - `PrintStream` used to print primitive data types and `String` objects in a viewable format, while `DataOutputStream` used to put data elements in a stream in a way that `DataInputStream` can portably construct them.
  - `PrintStream` can be problematic, because it traps all `IOExceptions`.
    - i.e. must explicitly check errors with `checkError()`.

## Readers and Writers

- `InputStream` and `OutputStream` aimed at byte orientated IO while `Reader` and `Writer` classes provide unicode compliant character based IO.
- Almost all corresponding IO streams have `Reader`/`Writer` streams.
- Note, some implementations still require byte orientated streams rather than character streams (e.g. `java.util.zip`).

| Stream Class | Reader/Writer Class | Reader/Writer Superclass | Notes | 
| :----------------- | :--------------------- | :------------------- | :------------------- |
| `InputStream` | `Reader` | | Converter is `InputStreamReader` (i.e. `InputStreamReader` is a bridge to convert byte streams to character streams). |
| `OutputStream` | `Writer` | | Converter is `OutputStreamReader` (i.e. `OutputStreamReader` is a bridge to convert byte streams to character streams). |
| `FileInputStream` | `FileReader` | `InputStreamReader` | |
| `StringBufferInputStream` | `StringReader` | `Reader` | |
| `ByteArrayInputStream` | `CharArrayReader` | `Reader` | |
| `PipedInputStream` | `PipedReader` | `Reader` | |
| `FilterInputStream` | `FilterReader` | `Reader` | |
| `BufferedInputStream` | `BufferedReader` | `Reader` | Has `readLine()` |
| `LineNumberInputStream` | `LineNumberReader` | `BufferedReader` | | 
| `PushBackInputStream` | `PushBackReader` | `FilterReader` | |
| `FileOutputStream` | `FileWriter` | `OutputStreamWriter` | |
| N/A | `StringWriter` | `Writer` | |
| `ByteArrayOutputStream` | `CharArrayWriter` | `Writer` | |
| `PipedOutputStream` | `PipedWriter` | `Writer` | |
| `FilterOutputStream` | `FilterWriter` | `Writer` | Abstract, no subclasses. |
| `BufferedOutputStream` | `BufferedWriter` | `Writer` | | 
| `PrintStream` | `PrintWriter` | `Writer` | |

## Examples ##

### Reading Input from a File

        [sourcecode language="java"]
        /**
         *    To open a file with character input, use a FileReader with a String/File object as the file name
         *    For speed, you use a BufferedReader, since BufferedReader also provides readLine() this is your
         *    final object, and the interface you read from
         *
         *       BufferedReader(Reader)
         *                         |
         *                      FileReader(File)
         */
        
        try {
          BufferedReader in = new BufferedReader(new FileReader("Demo.txt"));
        
          String str;
        
          while ( (str = in.readLine()) != null ) {
            System.out.println("String=" + str);
          }
        } catch ( IOException ioe ) {
            // do something
        }
        [/sourcecode]

### Reading from `System.in`

      [sourcecode language="java"]
      /**
       *     System.in is a DataInputStream and BufferedReader needs a Reader argument
       *     Therefore InputStreamReader is brought in to perform the translation
       *        BufferedReader(Reader)  
       *                         |
       *                       InputStreamReader(InputStream)
       *                                             |
       *                                          System.in(InputStream)
       **/
      
      try {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("Enter a line ");
        System.out.println(stdin.readLine());
        
      } catch ( IOException ioe ) {
        // do something
      }
      [/sourcecode]

### Reading input from memory

      [sourcecode language="java"]
      /** 
       *    A StringReader can be used to read a String from memory
       *    Can then use the “read()” method to read a character at a time
       *    Note: that read(0 returns the next byte as an “int” therefore must
       *    be cast to a character
       */
      
      try {
        
        StringReader in = new StringReader(s);
        int c;
        while ( (c = in.read()) != -1 ) {
            System.out.println((char)c);
        }
        
      } catch ( IOException ioe ) {
        // do something
      }
      [/sourcecode]

### Formatted memory input 

      [sourcecode language="java"]
      /**
       *
       *    To read formatted data, use a DataInputStream which is byte orientated rather
       *    than character orientated.
       *    Therefore you must use all InputStream classes rather than Reader classes.
       *    Can read anything using InputStream e.g. files as bytes, or String.
       *    NB When reading form a DataInputStream using readByte() any byte value is a legitimate
       *       value so the return value cannot be used to detect the of input so use the “available()”
       *       method to find out how many more characters are left
       *      DataInputStream(InputStream)
       *                           |
       *                      BufferedInputStream(InputStream)   // superclass FilterInputStream
       *                                               |
       *                                          FileInputStream(File)
      **/
      [/sourcecode]

