Categories: python
Tags: xml 
      lxml

## Notes ##

- `lxml` is the only Python XML API I could find that supports XPath.

## Adding an element ##

        import lxml.etree
        
        xmlfile = "/tmp/test.xml"
        tree = lxml.etree.parse(xmlfile)
        root = tree.getroot()
        
        node = lxml.etree.Element("element1")
        node.text = "element1text"
        
        root.append(node)
        
        outxmlfile = "/tmp/test2.xml"
        f = open(outxmlfile, 'w')
        f.write( lxml.etree.tostring(root, xml_declaration=True, encoding='UTF-8') )
        f.write("\n")
        f.close()

### Getting text from an element ###

For example using the following XML called `maven-metadata.xml` (from a maven repository):

        <?xml version="1.0" encoding="UTF-8"?>
        <metadata>
          <groupId>com.test</groupId>
          <artifactId>project</artifactId>
          <version>2.1-SNAPSHOT</version>
          <versioning>
            <snapshot>
              <timestamp>20110407.071747</timestamp>
              <buildNumber>13016</buildNumber>
            </snapshot>
            <lastUpdated>20110407071748</lastUpdated>
          </versioning>
        </metadata>

Use the following python code to retrieve the `timestamp`:

        import lxml.etree
        import os
        
        dir = "/tmp"
        path = os.path.join(dir, 'maven-metadata.xml')
        
        tree = lxml.etree.parse(path)
        root = tree.getroot()
        
        nodestr = "//metadata/versioning/snapshot"
        timestamp = None
        
        nodetxt = tree.xpath(nodestr + "/timestamp//text()")
        if nodetxt:
          timestamp = nodetxt[0]



