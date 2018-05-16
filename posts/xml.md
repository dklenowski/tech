Categories: html
Tags: html

## XML

### Introduction

- XML 1.0 Recommendation (http://www.w3.org/TR/REC-xml.html).
- XML document consists 2 main sections:
  - Header - Gives XML parser information on how to handle document.
  - Content - XML data itself.
- e.g.

        <?xml version=1.0?>
        <!DOCTYPE book SYSTEM “DTD/JavaXML.did”>
        <!–- Java and XML Contents -->
        <book xmlns=http://www.oreilly.cmo/javaxml2
              xmlns:ora=http://www.oreilly.com>
        
        
        <title ora:series=”Java”>Java and XML </title>
        
        
        <!-- Chapter List -->
              <contents>
                    <chapter title=”Introduction” number=”1”>
                          <topic name=”XML Matters” />
                    </chapter>
              </contents>
        <ora:copyright>&OreillyCopyright;></ora:copyright>
        </book>

### Header

- A basic header:

        <?xml version=1.0?>

- Can also include encoding, and whether document is standalone or requires other documents to be referenced.

        <?xml version=1.0 encoding=”UTF8” standalone=”no”?>

- Rest of header is made up of items like the `DOCTYPE` declaration.
- e.g. to refer to a document on the local filesystem, use the SYSTEM keyword.

        <!DOCTYPE book SYSTEM “DTD/JavaXML.did”>

- SYSTEM – Any time you use a relative or absolute file path or a URL use the SYSTEM keyword.
- PUBLIC – Follow with a public identifier. Use a consortium defined a standard DTD that is associated with that public identifier. e.g.

        <!DOCTYPE html PUBLIC “-//W3C/DTD XHTML 1.0 Transitional//EN”
            http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd>

- `-//` identifies a public identifier, the URL following the declaration is a SYSTEM identifier (i.e. if the PUBLIC identifier cannot be resolved the SYSTEM identifier is used)

### Root Element

- Used by parser to recognise the beginning and end to an XML document.
- Can only be 1 root element in an XML document.

### Element

- Must start with a letter. Cannot contain embedded spaces.
- XML elements are case sensitive.
- Every open element must be close.
- XML documents must be well-formed (unlike HTML).
- Can nest any number of elements, but cannot be mixed.
- Can specify an opening and closing element tag within 1 element. e.g.

        <chapterIncomplete />
        <img src=”/images/xml.gif” />

### Attribute

- Included in elements opening declaration.
- e.g.

        <chapter title=”Advanced SAX” number=”4”>

- Must follow same rules as XML elements
- Attribute values must always be enclosed within double quotation marks. (single quotation marks are allowed by not widely used).

### Entity References

- Special data type in XML used to refer to special characters.
- Format:

        &<entityName>;

- Five entity references:

        &lt;                   less than bracket “<”
        &gt;                  greater than bracket “>”
        &amp;              ampersand
        &quot;              Double quotation mark
        &apos;              A single quotation mark

- Can also define own entity references.

### CDATA

- Used to display unparsed data.
- e.g.

        <unparsed-data>
              <![CDATA[Diagram:
                    <Step 1>Install Cocoon to “/user/lib/cocoon”
                    <Step 2> Locate the correct properties file
              ]]>
        </unparsed-data>

### Namespaces

- Associated `>=1` elements in an XML document with a particular URI.
- i.e. an element is identified by both its name and its namespace URI.
- Namespace specification requires that a unique URL be associated with a prefix to distinguish the elements in the namespace from elements in other namespaces (a URL is recommended).
- e.g. Text above declares 2 namespaces:
  - First namespace considered default, because no prefix is supplied.
  - Any element without a prefix is associated with this namespace.
  - The second `ora` defines a prefix, which must be assigned to reference element tags from this namespace e.g. `<ora:copyright>` references the xmlns:ora namespace.

### Schema

- DTD and schemas are used to provide descriptions of document structures.
- i.e is basically a “contract” as to how the XML document will be laid out.
- Can also:
  - Provide defaults for attributes.
  - Provide a mechanism to reference content from other documents (i.e. entity declaration).
- Schema Verse DTD:
  - XML schemas use XML document syntax.
  - XML schemas can have a richer and more complex internal structure.
  - XML schemas can define their own “data-orientated” data types in addition to the more “document oriented” data types in DTDs
  - XML schemas support namespaces

        <?xml version="1.0" encoding="UTF-8"?>
        <xs:schema targetNamespace="http://www.oreilly.com/javaxml2" xmlns:ora="http://www.oreilly.com" xmlns="http://www.oreilly.com       /javaxml2" xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified">
        <xs:import namespace="http://www.oreilly.com" schemaLocation="contents-ora.xsd"/>
        <xs:element name="book">
            <xs:complexType>
                <xs:sequence>
                <xs:element ref="title"/>
                <xs:element ref="contents"/>
                <xs:element ref="ora:copyright"/>
                </xs:sequence>
            </xs:complexType>
        </xs:element>
        
        
        <xs:element name="title">
            <xs:complexType>
                <xs:simpleContent>
                    <xs:extension base="xs:string">
                        <xs:attribute ref="ora:series" use="required"/>
                    </xs:extension>
                </xs:simpleContent>
            </xs:complexType>
        </xs:element>