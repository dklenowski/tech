Categories: html
Tags: html

## HTML

- HTML tags not case sensitive.

## Base Template

        <HTML>
            <HEAD>
                <TITLE> Insert title Here </TITLE>
            </HEAD>
            <BODY>
                <H1> Insert body of HTML here </H1>
            </BODY>
        </HTML>


## HTML Tags

### `<TITLE>`

- Usually shown at the top of the web browser (and is displayed in the users bookmarks).

### `<A>`

- Anchor
- Used for hyperlinks.
- e.g.

        <A HREF="test.html"> The text displayed in this file.</A>

- Can use unix syntax for pathnames (i.e. can use “..” and “.”)
- Relative paths are linked relative to the current location of the current file. e.g.

        <A HREF="dir1/test.html> A simple file </A>

- Links to other services (i.e. what goes in the HREF field).
- e.g. 

        scheme:://host.domain [:port]/path/filename
        scheme - file, ftp, http, telnet etc

- To link to specific sections within HTML document:
  - Create a named anchor in the file at the location you want the link to point to.

          <A NAME="toc"> Table of Contents </A>
  
  - Create the hyperlink.

          <A href="test.html#toc> Back to the table of contents</A>

- Email links format:

        <A HREF="mailto:emailinfo@host">Name of person to email</A>

### `<B>`

- Bold text.

### `<I>`

- Italic text.

### `<BODY>`

- Content.
- Specifies default attributes for page.
- e.g.

        BACKGROUND="filename.gif"   Insert a background image.
        BGCOLOR="#000000"           Insert a background color.
        TEXT="#FFFFFF"              Change the color of the text.
        ALINK="..."                 Active links.
        VLINK="..."                 Visited links.

- Note Most web browsers accept widely understood color names (that can be substituted for hex colors).

        aqua, black, blue, fuchsia, gray,
        green, lime, maroon, navy, olive,
        purple, red, silver, teal, white

### `<BR>`

- Forces a line break with no extra (white) space between lines.

### `<HX>`

- 6 levels of headings (X = 1 - 6).
- `H1` is the largest header.

### `<HR>`

- Horizontal Rule.
- Produces a horizontal line the width of the browser window.
- Attributes:

        SIZE=X      Thickness.
        WIDTH="X"   Percentage of the window covered by the rule.

### `<IMG>`

- Insert images into HTML documents.
- Format:

        <IMG SRC=filename>

- Attributes:

        HEIGHT=X                Only available some browsers, and image may be
                                distorted.
        WIDTH=X
        ALIGN=TOP | CENTER      By default the bottom of an image is aligned
                                with the following text.

### `<P>`

- Paragraphs, for word wrapping.
- Web browsers will automatically word wrap and ignore carriages returns in the - source document.
- Attributes:

        ALIGN=LEFT | CENTER | RIGHT

- e.g.

        <P ALIGN=CENTER> A centred paragraph </P>

### `<PRE>`

- Preformatted text.
- Used to generated text in a fixed width font.
- Marks spaces, new lines and tabs significant from the source file (HTML will recognise).
- Since `<`, `>`, and `&` have special meaning in HTML must use their escape sequences if text is within `<PRE>` tags.
- Note, escape sequences are case sensitive.

        <      &lt;
        >      &gt;
        &      &amp;

- Attributes:

        WIDTH=X     Specifies the maximum number of characters for a line

### `<TABLE>`

- Tables.

        <TR>       Table contains rows of cells defined with the <TR> tag.
        <TD>       Each <TR> tag contains data cells defined with the <TD> tag.

- Attributes:

        ROWSPAN=X   Cell spans X columns.
        ALIGN=LEFT | RIGHT | CENTER
                    Horizontal alignment of text within the cell.
        VALIGN=TOP | MIDDLE | BOTTOM | BASELINE
                    Verticle alignment of text.
                    Baseline - Aligned to the baseline of the text.
        
- e.g.

        <TABLE>
            <TR>
               <TD> Laundry Detergent </TD>
               <TD ALIGN=RIGHT> $4.88 </TD>
            </TR>
            <TR>
               <TD> Cat food </TD>
               <TD ALIGN=RIGHT> $128.00 </TD>
            </TR>
        </TABLE>

### `<UL>`

- Unnumbered lists.

        <UL>
            <LI> Apples </LI>
            <LI> Oranges </LI>
        </UL>


### `<OL>`

- Numbered list:

        <OL>
            <LI> Apples </LI>
            <LI> Oranges </LI>
        </OL>

### `<FRAME>`

- Not part of the HTML standard.
- Attributes:

        BORDERCOLOR="color"         The color of the frame border
        FRAMEBORDER="YES" | "NO"    Whether a frame has borders
        MARGINHEIGHT="height"       Margin (in pixels) between the top and
                                    bottom edges of the frame and the frame
                                    contents
        MARGINWIDTH="width"         Margin (in pixels) between the left and
                                    right edges of the frame and the frame
                                    contents
        NAME="framename"            Specifies the user cannot resize the frame
        NORESIZE                    If a frame adjacent to an edge is not
                                    resizable, the entire frame is not
                                    resizable
        SCROLLING="YES" | "NO" | "AUTO"
                                    Whether scrollbars available on a frame
        SRC="url"                   Specifies the url for the document to be
                                    displayed in the frame (cannot include a
                                    anchor name i.e. "#"

### `<FRAMESET>`

- Defines a set of frames that appear in the web browser.
- Used in the Frame Reference document (links all the frames together).
- Do not define the `<BODY>` attribute for a html document when using frames.
- Attributes:

        COLS="colmnWidthList"       CSV list of values giving the width
                                    of each frame in the frameset.
                                    Either:
                                        a. Width of frame in pixels.
                                        b. Width of frame as % of parent.
                                        c. "*" - fill available space.
        ROWS="rowHeightList"        CSV list of values giving the height of each
                                    frame in the frameset (same item values as
                                    COLS)
        BORDER="pixWidth"           Thickness of frame borders for all frames in
                                    the outermost frameset.
        BORDERCOLOR="color"         Color of the frames borders.
        FRAMEBORDER="YES" | "NO"    YES results in 3D borders
        ONBLUR="JScode"             Specifies the JavaScript code to execute
                                    when the window containing the frameset
                                    looses focus.
        ONFOCUS="JScode"            JavaScript code when frame gets focused.
        ONLOAD="JScode"             JavaScript code to execute when frameset is
                                    loaded.
        ONUNLOAD="JScode"

- e.g. Nested Frames

        <HTML> <HEAD> <TITLE> Frame set example </TITLE> </HEAD>
            <FRAMESET COLS="20%, *">
                <NOFRAME> Must use a browser that can display frames </NOFRAMES>
                <FRAME SRC="frametoc.htm" NAME="noname">
                    <FRAMESET ROWS="30%, *">
                        <!-- i.e. for 2 rows have 2 values -->
                        <FRAME SRC="frametopttoc.htm" NAME="toptoc">
                        <FRAME SRC="framerighttoc.htm" NAME="outer">
                    </FRAMESET>
            </FRAMESET>
        </HTML>