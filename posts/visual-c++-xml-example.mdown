Categories: visual c++
Tags: xml

## Visual C++ XML Example

    // includes
    #include "stdafx.h"
    #include <iostream>
    #import <msxml4.dll>
    
    using namespace MSXML2;
    using namespace std;
    
    //
    // in main
    //
    HRESULT fpRes;
    IXMLDOMDocument2Ptr fpXMLDomDoc;
    string xmlfile("/tmp/test.xml");
    
    // initalise the COM environment
    fpRes = CoInitialize(NULL);
    if ( fpRes ) {
      cerr << "Failed to initialize COM environment, errCode=" << fpRes << endl;
      exit(1);
    }
    
    fpRes = fpXMLDomDoc.CreateInstance(__uuidof(DOMDocument40));
    if ( fpRes ) {
      cerr << "Failed to instantiate an XML DOM Document class DOMDocument40,"
           << "errCode=" << fpRes << endl;
      exit(1);
    }
    
    // turn off async, prevents return before complete document loaded.
    fpXMLDomDoc->async = VARIANT_FALSE;
    
    if ( fpXMLDomDoc->load(xmlfile) != VARIANT_TRUE ) {
      IXMLDOMParseErrorPtr fpPErr = fpXMLDomDoc->GetparseError();
      _bstr_t errbstr(fpPErr->reason);
    
      _tprintf(_T("Error:\n"));
      _tprintf(_T("Code = 0x%x\n"), fpPErr->errorCode);
      _tprintf(_T("Source = Line : %ld; Char : %ld\n"), fpPErr->line, fpPErr->linepos);
      _tprintf(_T("Error Description = %s\n"), (char*)errbstr);
    
      exit(1);
    }
    
    // Query a single node.
    IXMLDOMNodePtr fpNode = fpXMLDomDoc->selectSingleNode("//stock[1]/*");
    if ( fpNode == NULL ) {
       printf("Invalid node fetched.\n%s\n", (LPCSTR)fpXMLDomDoc->parseError->Getreason());
    } else {
       printf("Result from selectSingleNode:\nNode, <%s>:\n\t%s\n\n",
          (LPCSTR)fpNode->nodeName, (LPCSTR)fpNode->xml);
    }
    
    // Query a node-set.
    IXMLDOMNodeListPtr fpNodeList = fpXMLDomDoc->selectNodes("//stock[1]/*");
    printf("Results from selectNodes:\n");
    for (int i=0; i < fpNodeList->length; i++) {
       pNode = fpNodeList->item[i];
       printf("Node (%d), <%s>:\n\t%s\n", i, (LPCSTR)fpNode->nodeName, (LPCSTR)fpNodeList->item[i]->xml);
    }
    
    fpXMLDomDoc.Release();
    fpNode.Release();
    fpNodeList.Release();
    CoUninitialize();
