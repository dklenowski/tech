Categories: c
Tags: com+

## Miscellaneous

- `co` in method names e.g. `coCreateInstance()` stands for Component Object.

## Definitions ##

### Object Linking and Embedding (OLE)

- Provides application capability to contain and manipulate a document that was produced by another application as if it were its own.


### Interfaces

- Exposed connection for controlling application to access COM object.
- The interface has no implementation (i.e. no class).
- i.e a collection of functions and is the exposing mechanism of the object itself (and is not a COM object).
- There can be multiple interfaces for one COM object.
- Interfaces are immutable.
- COM interfaces cannot be versioned.
- Provides access to a table that contains pointers to the objects methods (i.e. the `vtable`).


### Objects

- COM object/component is a particular instance of a COM class.
- Can contain functions accessible through its interfaces.
- Must have at least the `IUnknown` interface (or from another interface that is itself derived from the `IUnknown`).
- COM Server: 
  - COM objects exporting interfaces for another's use.
- COM client:
  - COM objects that use another's interface.

### Classes

- COM object/component is a specific instance of a COM class (which defines components interfaces and methods).
- When COM component instantiated, the class object/factory called to do initialisation.
- A COM class is also referred to as a `coclass`.
- "class factories" (singular, class factory object) have a method in one of its interfaces that produces an instance of the `coclass` (analogous to C++ new operator).


### Client-Server


- Client: 
  - Application that uses services of COM component is called a client.
- Server: 
  - COM component that exposes methods and provides services is a server.
- When the object and its client reside in a single execution context (called an apartment) the client uses direct pointers on object interfaces.
- When the object and client reside in different apartments, COM interposes itself between them and provides the necessary support for calling the interface methods and returning the results.
- COM object implemented in a server. Server can be in a DLL or implemented as a separated executable.
- Server Process:
  - Software that sits in the client process/context is called a "proxy" (represents the interface to the COM server component).
  - Client communicates with the proxy and the proxy communicates with the server process via a "stub" (which resides in the context of the object and acts as the client of the object's interface).
  - i.e. the stub call the interface functions in the component on behalf of the client/proxy.
- The proxy and stub code generated from the `.idl` file by the MIDL compiler and is usually placed in a separate DLL.
- Although is possible to include proxy/stub code within same DLL (by checking flag in wizard).


#### Marshalling

- Process proxy goes through to gather arguments together for an interface function call.

#### Unmarshalling 

- Process of sorting out arguments at the component end (carried out by the stub).

### Identifiers

#### GUID

- Globally Unique ID. ID information is stored in the system registry.
- To generate GUIDs, either use the `guidgen.exe` tool or invoke `CoCreateGuid()` method at runtime.

#### CLSID

- Class identifier.
- A GUID assigned to a class.
- Syntax:

        CLSID_<unique-identifier> = <value>;

#### IID 

- Interface identifier.
- GUID assigned to an interface.
- Syntax:

        IID_<unique_identifier> = { <value> };

#### TLBID

- A GUID assigned to a type library.
- Syntax:

        <TypeLib_identifier> = { <value> }

### IDL

- Interface Description Language.
- Defines a COM interface.
- Stored in a type library (`.tlb`).
- When you build a COM component, MIDL (Microsoft IDL processor) compiler processes the .idl FILE AND THE C++ compiler processes the `cpp` files.

## COM Datatypes ##


### `BSTR`

- Type of string that is used by COM.
- Contains a length prefix that indicates the number of bytes for the string.
- Use `CComBSTR` ATL class for managing BSTRs (handles dynamic pointer allocation and deallocation, as well as pointer reference counting).
- Unicode 
  - Essentially, Unicode uses 2 bytes for encoding characters (exception, Apple PowerMac).
- BSTR consists of 3 main parts:

          Length - 4 bytes.
          Unicode String - Variable length string.
          Null Terminator - Single byte.

- ATL provides for manipulating BSTR's, the `CComBSTR` class which is defined in the `atlbase.h` but implemented in `atlimpl.cpp`.
- AS with smart pointer templates, not required to link with `ATL.LIB` to use `CComBSTR`, but you will need to include the `atlimpl.cpp` once somewhere in your source files (preferably in s`tdafx.cpp`).

          # include <atlimpl.cpp>
          
          BSTR clearText = ::SysAllocString(L"123abc");
          BSTR munged;
          
          hr = pEncrypt->Encrypt(clearText, &munged);
          if ( FAILED(hr) ) {
            // error
            ::SysFreeString(clearText);
            ::SysFreeString(munged);
          } else {
            // do something 
            ::SysFreeString(clearText);
            ::SysFreeString(munged);
          }

- Notes:
  - `L` indicates the string is an `OLECHAR` (which is a Unicode string).
  - Cant use `new` to allocate memory for a `BSTR`.

- Using CComBSTR:

          CComBSTR clearText(m_orig); // a CString
          CComBSTR munged;
          hr = pEncrypt>Encrypt(clearText, &munged);
          if ( FAILED(hr) ) {
            // error
          }

- Notes:
  - Can pass `LPCTSTR` to `CComBSTR` which automatically performs the `SysAllocString` for you (after converting the `TCHAR`-based string to an `OLECHAR` based string).
  - `CComBSTR` destructor performs `SysFreeString` for you.

### `SAFEARRAY`

- Provides mechanism to handle variable size arrays.

### `HRESULT`

- 32 bit integer used exclusively in COM to define result types.
- Contain important information about errors that occur in the COM environment.
- Contain 3 sections:
  - Severity - Bit indicating success/failure.
  - Facility Code - Details where a particular error occurred.
  - Information Code - Information as to the specific error within the specified facility.


- COM provides 2 macros for working with `HRESULT`'s:
  - `SUCCEEDED(hresult)` and the `FAILED(hresult)` return boolean values that allow checking of error codes prior to proceeding.

### VARIANT

- Very large union of datatypes.
- Denotes datatypes the COM standard marshaller is able to automatically marshal for you.
- Simply a discriminated union that contains an integer denoting the type (the discrimination) and a union containing all of the possible datatypes.

        typedef struct tagVARIANT {
          VARTYPE vt;
          WORD wReserved1;
          WORD wReserved2;
        
          WORD wReserved3;
          union {
            long lVal;            /* T_I4 */
            // ..
            VARIANT_BOOL boolVa;  /* VT_BOOL */
            SCODE scode;          /* VT_ERROR */ };
          } VARIANT, VARIANTARG;
        
          // ..
          typedef unsigned short VARTYPE;
        
          // ..
          enum VARENUM {
            VT_EMPTY = 0,
            // ...
            VT_BSTR  = 8,
            // ..
            VT_ERROR = 10,
            VT_BOOL  = 11
          }


- The CComVariant template handles the VARIANT datatype for you (i.e. allocation/deallocation for the discriminated union, assign the discriminator etc)
- e.g.

        CCComVariant varError(VT_ERROR); // declare a VARIANT type VT_ERROR

## Automation

- COM defines a standard for accessing COM object servers called automation.
- In automation, only a subset of all types available in the IDL are supported. e.g. composite types such as structs, arrays and strings are not supported.
- Instead, automation defines new types `BSTR`, `SAFEARRAY` and `VARIANT`.
- Automation defines another type of interface called a dispatch interface (dispinterface/automation interface).
- These interfaces are centered around objects implementating the interface `IDispatch`.

          [ 
          object, 
          uuid(00020400-0000-0000-C000-000000000046), 
          pointer_default(unique) 
          ] 
          interface IDidspatch : IUnknown 
          { 
            HRESULT GetTypeInfoCount( [out] UINT *pctinfo ); 
            HRESULT GetTypeInfo( 
              [in] UINT       iTInfo, 
              [in] LCID       lcid, 
              [out] ITypeInfo **ppTInfo ); 
            HRESULT GetIDsOfNames( 
              [in] REFIID riid, 
              [in, size_is(cNames)] LPOLESTR *rgszNames, 
              [in] UINT   cNames, 
              [in] LCID   lcid, 
              [out, size_is(cNames)] DISPID *rgDispId ); 
            HRESULT Invoke( 
              [in] DISPID          dispIdMember, 
              [in] REFIID          riid, 
              [in] LCID            lcid, 
              [in] WORD            wFlags, 
              [in, out] DISPPARAMS *pDispParams, 
              [out] VARIANT        *pVarResult, 
              [out] EXCEPINFO      *pExcepInfo, 
              [out] UINT           *puArgErr ); 
          }; 


- Unlike COM interface, contains no VTBL layout representations.
- Instead, all methods marked with integer identifiers called dispatch IDs (dispids).
- Each method has a list of properties (each property associated with get and put methods) that retrieve and store its value, resulting in 2 different methods having the same dispid value in the dispinterface.
- Process:
  - Given textual names of method and its parameters, ccaller gets corresponding dispid and similiar IDs for parameter positions using `IDispatch::GetIDsOfNames()`. 
  - Then a call to `IDDispatch::Invoke()` made with all parameters passed in the `pdispParams` array. 
  - Result returned in the output parameter `pVarResult`. 
  - Method call allows a dispatch exception to be thrown, exception reported by way of `pExcepInfo` (not C++ exception).

- Note, Implementing IDispatch difficult, few functions exist to simplify implementation using the type library definition of the dispinterface.

## Marshalling

- Proxy 
  - COM object that presents the same interface for the real COM object. 
  - Gives the illusion that you are communicating with an object in a process.
  - When client invokes method on interface, proxy will pick it up, package it, and send it to the real COM object through an IPC.
  - When the proxy sends the package, it sends it to a stub object, which will unpack the information for the real COM object.
- Marshalling is the process of packaging the information.
- Marshalling is structured for each interface (i.e. the client marshalling code knows how to pack information and unpack the results and the server marshalling code must know how to unpack information and pack results).
- Marshalling code generated using the MIDL compiler on auto-generated IDL code.


## Type Library

- Binary analog of a C++ header.
- Tokenised for of the original IDL used to create the COM object's interface(s). 
- MIDL compiler can build proxy/stub code as well as the type library. 
- The type library contains all the information that a client needs in order to determine the object's interface information.
- IDL processes ID descriptions for interfaces and generates a header file with native C++ definitions.
- The compiler also generates a file that stores the GUIDs for interfaces and `coclasses`.
- Type Library contains richer information that a regular C++ header.
- IDL contains a subset of Object description Language (ODL).


            [ 
            uuid(98178CD0-3467-11d2-914B-52544C004D83), 
            version(1.0), 
            helpstring(“This is type library”) 
            ] 
            library YourLib 
            {
              // type library can be used to describe coclasses
              [ 
              uuid(55712EB0-3468-11d2-914B-52544C004D83), 
              helpstring(“This is coclass”) 
              ] 
              coclass YourClass 
              { 
                [default] interface IMain; 
                interface ISecond; 
              };
            };

- In addition to `coclass`, this definition pulls in the definition of two interfaces.
- Type library can also contain type definitions, enumerators, C struct's, unions etc
- Generated by the IDL compiler, result is a binary file that can be distributed instead of the original IDL.
- `ITypeLib` and `ITypeInfo` are two COM interfaces that can be used to read the contents of the type library.
- Importing type libraries (only on Visual C++ compilers):
 
          import <type_lib> no_namespace

          no_namespace    Used to suppress the generation of a separate
                          namespace for the definition in the type library.

- When preprocessor encounters `#import`:
  - Scans the referenced type library and generates 2 files with extensions `tlh` and `tli` (these extensions stand for type library header and type library implementation). 
  - Former contains header for the generated class, latter contains the implementation of wrapper methods.


## COM Moniker

- To name a particular instance of a COM object, need to know about its interfaces, methods, properties and data. 
- Several ways to make this identification:
  - Create object through CoCreateInstance() and pass it the object's CLSID.

- Moniker is a name for a specific instance. 
- i.e. a combination of the CLSID and the specific data for the object. 
- A moniker is a COM object and exposes this capability through the `IMonkier` interface. 
- Each moniker has everything that it needs to create an instance of the object that is represents. 
  - Does this through the `BindToObject()` method of the `IMoniker` interface. 
  - Client will invoke this method, passing it an IID of the interface it requires on the target object. 
  - The moniker can then instantiate the object and pass back the desired interface to the client.

## `IUnknown`

- Provides mechanism for querying an interface and providing a reference count.
- Provides three methods:


### `QueryInterface()`

- Called to determine whether the component supports a particular interface (named with its IID) and get a pointer to that interface if it does.
- Will return `S_OK` when it succeeds.
- `QueryInterface()` for `IUnknown` always succeeds and always returns the same interface pointer, regardless of the interface on which it was called.


        // Simple implementation of QueryInterface() for an object that exposes 
        // 2 interfaces: IEngine and ICar through multiple inheritance
        //
        STDMETHODIMP CCar::QueryInterface( REFIID riid, void **ppv ) 
        { 
          HRESULT hr = S_OK; 
          // Note that IEngine is designated for IUnknown queries 
          if ( IsEqualIID( riid, IID_IUnknown ) ) { 
            *ppv = (void*)static_cast<IEngine*>( this ); 
          } else if ( IsEqualIID( riid, IID_IEngine ) ) { 
            *ppv = (void*)static_cast<IEngine*>( this ); 
          } else if ( IsEqualIID( riid, IID_ICar ) ) { 
            *ppv = (void*)static_cast<ICar*>( this ); 
          } else { 
            hr = E_NOINTERFACE; 
            *ppv = NULL; 
          } 
          // Note that we call AddRef on the returned pointer 
          if ( SUCCEEDED( hr ) ) { 
          reinterpret_cast<IUnknown*>( *ppv )->AddRef(); 
          } 
          return hr; 
        }


- Note, the above implementation rarely used, when there are many interfaces exposed on the object, code becomes large.
  - The table driven approach is preferred.

### `AddRef()`

- COM component that is being shared keeps track of the number of clients that are using the interface, calling `AddRef()` increments the reference count.

### `Release()`

- Called by a client when it ceases using a component interface.
- Calling `Release()` decrements the reference count for an interface (i.e. when interface count for an interface is zero, object can be destroyed).


        //
        // Definition of IUnknown
        //
        [ 
        local, 
        object, 
        uuid(00000000-0000-0000-C000-000000000046), 
        pointer_default(unique) 
        ] 
        interface IUnknown 
        { 
          HRESULT QueryInterface( 
          [in] REFIID riid, 
          [out, iid_is(riid)] void **ppvObject ); 
          ULONG AddRef( void ); 
          ULONG Release( void ); 
        }; 


- Notes:
  - `local` means interface is not remotable (no marshalling should be generated). 
    - `IUnknown` is remotable, but uses another remoting scheme (`IRemUnknown`).
  - `iid_is` instructs marshalling code to treat the pointer as an interface pointer and names it with an IID.
  - `REFIID` is `IID&` and exploits the fact that C++ compilers pass reference arguments as pointers.

## `IDispatch`

- Dispatch Interface.
- Inherits functions from IUnknown and implements additional functions that make calling interface functions easier (i.e. no `vtable`).
- i.e. adds a function called `Invoke()` which used to call different functions based on a positive 32 bit integer argument called a `DispID` (Dispatch ID).
- Slower than the `vtable` method.

##  `IClassFactory`

- Defines methods needed to create instances of its COM object for the client. 
- Defines the following methods:

### `CreateInstance() `
- Creates instance of the specific object that the factory is designed to create.
- Responsible for creation of a specific COM object, therefore no need for the CLSID. 
- However, it does need to pass the IID to specify which interface it requires.

### `LockServer() `

- Forces newly create COM object to remain in memory. 
- By locking, COM guarantees that individual object reference counts will not inadvertently remove the (static) class factory from memory, until all objects that it creates have been removed.

## COM Runtime

- COM runtime allows:
  - Clients to make IUnknown calls across processes/network.
  - Ability to establish connections between components.
  - Contains necessary system calls to instantiate components.
    
- When starting a COM component:
  - Executable - COM start executable and wait to register its class factory through `CoRegisterClassFactory`.
  - DLL - COM loads the DLL into the clients address space and call `DllGetClassFactory()` (a mandatory DLL exported function).
- When client instantiates component and requests an interface pointer, COM will create the component and pass back the requested interface pointer to the client if the COM object supports the interface.
- Object creation accomplished through `IClassFactory` interface.

## COM Wizard

- When you create a new COM/ATL component, 5 global functions and a global object (`_Module`) are defined.

#### `DllRegisterServer()`
- Register COM component.

#### `DllUnregisterServer()`
- Unregister COM component.

#### `DllMain() `
- Called when DLL loaded into memory and initialises the DLL.

#### `DllCanUnloadNow()`
- Determines whether the DLL is still in use, and called to decide when to remove the DLL from memory.

#### `DllGetClassObject() `
- Retrieve the COM object from the DLL when you create an instance of the component in a client program.

### `_Module` ###

- instance of the class CComModule,
- Represents the COM server module were creating. 
- COM server module will contain functions to manage all the class objects in the module and provides the mechanism for entering information about the COM components in the system registry.
- Not in VC 2003.

## Object Creation

- Objects created through the COM runtime environment or by using monikers.
- Every `coclass` has an associated object called a class object/factory.
- Although not mandatory, the object exposes the interface.

          IClassFactory.[ 
            object, 
            uuid(00000001-0000-0000-C000-000000000046), 
            pointer_default(unique) 
          ] 
          interface IClassFactory : IUnknown 
          { 
            HRESULT CreateInstance( 
              [in, unique] IUnknown *pUnkOuter, 
              [in] REFIID riid, 
              [out, iid_is(riid)] void **ppvObject ); 
            HRESULT LockServer( [in] BOOL bLock ); 
          };
           
           
### `LockServer()` 

- Used to prevent server that implements the objects of interest from unloading when no objects are alive.
- All calls to `LockServer(TRUE)` must be matched with the appropriate number of calls to `LockServer(FALSE)` (as in `AddRef()` and `Release()` for interfaces).
          
### `CreateInstance()`
- Last 2 parameters are the ones passed to `QueryInterface()` and enable client to directly obtain a pointer for a specific interface.
- First parameter is new object's controlling IUnknown and used in aggregation. For regular clients, it is always `NULL`. The returned interface should be reference counted (i.e. `AddRef()` should be called).

## `CoGetClassObject()`

- Most widely accepted way of distributing COM components.
- Works on cocla`sses.

          STDAPI CoGetClassObject( 
            REFCLSID     rclsid, 
            DWORD        dwClsContext, 
            COSERVERINFO *pServerInfo, 
            REFIID       riid, 
            void         **ppv ); 


- Interface pointers goes in the `ppv` parameter.
- Last 2 parameters ones passed to `QueryInterface()` method of the class factory and represent the requested interface for the class factory itself.

#### `pServerInfo` 

- Used to describe the machine and security context of the call. 
- When on the same machine using the default security, `pServerInfo` can be `null`.

#### `STDAPI`

- Indicates that the function returns a 32 bit value of type `HRESULT`.

#### `dwClasContext` 

- Specifies how far it wants the object to be created.
- If the parameter is `CLSCTX_INPROC_SERVER` the COM subsystem will look for a DLL. 
If the parameter is `CLSCTX_LOCAL_SERVER`, COM will look for an exe.

#### `REFCLSID` 

- `CLSID&`.

#### `CLSID`
- GUID.

- Each coclass has a CLSID associated with it (each interface is named by its IID), so any two coclasses can be safely distinguished (so `rclsid` safely names the requested coclass).
- The CLSID of the coclass is manufactured by the class factories (since class factories have no CLSIDs).
- If this function succeeds, the caller holds the pointer to the class factory of the `coclass` of interested and can create as many interfaces as desired (the interface is usually `IClassFactory`).
- When finished with the class factory, the client should call `Release()` as usual.

- Standard GUIDs (e.g. those that name interfaces for Microsoft) are defined in the libraries that are dynamically linked to your program. 
  - Must define GUIDs for custom classes and interfaces, 
  - e.g.

            // {692D03A4-C689-11CE-B337-88EA36DE9E4E}
            static const IID IID_I<interface> = {0x692d03a4, 0xc689, 0x11ce, {0xb3, 0x37, 0x88, 0xea, 0x36,  0xde, 0x9e, 0x4e}};


### `CoCreateInstance()`

- Combines the functionality of `CoGetClassObject()` and `IClassFactory::CreateInstance`.
- Call `CoCreateInstance()` to create the object, then `QueryInterface()` to get interface pointers for the object's interfaces.
- If the class factory exposes the IClassFactory (recommended), COM runtime provides a wrapper for creating a single instance of the coclass:
          
          STDAPI CoCreateInstance( 
            REFCLSID rclsid, 
            IUnknown *pUnkOuter, 
            DWORD    dwClsContext, 
            REFIID   riid, 
            void     **ppv ); 

- `rclsid` and `dwClsContext` are passed to `CoGetClassObject()` to get the class factory of the object (the IID that is passed in is `IID_IClassFactory`).
- If the class factory is obtained successfully, `IClassFactory::CreateInstance()` is called, passing the remaining three arguments and the class factory is released.
- Output argument contains the requested interface pointer on success.
- Passing both the CLSID and an IID, the client can call `CoCreateInstance()` to create the remove object.
- COM runtime will look into the registry in order to map the CLSID to the file of the object to activate.
- If only 1 interface desired, `CoCreateInstance()` is adequate (it can be slow).

### `CoCreateInstanceEx()`

- Provides a way for the client to request a list of IIDs.
- Queries the object for all the interface in the list and then return the entire list of pointers when it has them (prevents client from having to make multiple `QueryInterface()` calls to the remote object).
- Allows client to specify where the remote object should be created, allows client to be dynamic and not rely on the local registry.
      
### Monikers
        
- Can also be used to create remote objects.
- Whenever a client calls the `BindToobject()` method on the `IMoniker` interface, the moniker will call `CoCreateInstance()` with a CLSID from persistent data.

### Registry

- When client calls `CoGetClassObject()`, COM must find the component by looking for the unique 128 bit class ID number in the Windows Registry.
- Thus, the class must be registered permanently on the computer.
- The `CoGetClassObject` function looks up the class ID in the registry and then loads the DLL or EXE as required.
- The human readable program ID can also be looked up using the following function:

        CSIDFromProgID(L"<obj_class>", &clsid);

- `L` indicates the parameter is a Unicode character string pointer of type `OLECHAR*`.
- Note, all string parameters in COM functions (except Data Access Objects) are unicode character string points of type `OLECHAR*`.
    
### COM with ATL

- ATL contains a smart pointer template. 2 types.

1. Create a pointer from scratch:

          template< class T > class CComPtr

2. If you call IUnknown:QueryInterface() through a COM object pointer:

          template< class T, const IID* piid > class CComQIPtr

## IDL

- Similar to syntax of C++ declarations with some additional annotations.
        
        //
        // IDL definition
        //
        import “unknwn.idl” 
        
        [object, uuid(C21D0200-2FB6-11d2-8952-444553540000)] 
        interface ICar : IUnknown 
        { 
        HRESULT SetSpeed( [in] long nSpeed ); 
        };
        
        // 
        // Resulting header file
        //
        interface 
        DECLSPEC_UUID(“C21D0200-2FB6-11d2-8952-444553540000”) 
        
        ICar : public IUnknown 
        { 
        public: 
        virtual HRESULT STDMETHODCALLTYPE 
        SetSpeed( /* [in] */ long nSpeed ) = 0; 
        };  


- Notes:
  - `object` indicates that this is COM interface (as opposed to an RPC interface).
  - `uuid()` gives the interface `IID`.
  - All COM interfaces should derive from `IUnknown`.
  - All methods in COM interfaces should return `HRESULT`.
  - `STDMETHODACALLTYPE` enforces the `stdcall` calling convention.
  - DECLSPEC_UID` can be safely ignored (C++ extension introduced by Microsoft Visual C++ 5.0).
  - `IUnknown` is publicly inherited because a base interface is part of the VTBL (virtual function table) and should be visible.
  - Multiple interfaces can be defined in a single IDL file.

- Take the IDL file and use MIDL (Microsoft IDL) compiler to produce a C/C++ compatible header file that should be used when implementing or using the interface. 
- Generates proxy/stub code for remoting the interface and a file that defines the IID (GUIDs are represented as structures and need to be allocated).


## Using COM objects
      
- Creating the object (which exposes the interface) comes first.
- Notes:
  - Each interface is implemented on some object. 
      The object expresses other interface. 
      To get another interface the client must make a `QueryInterface()` call on its interface pointer to obtain a pointer to another interface on the same object.
  - Instead of using a delete operator, the client calls `Release()` instructing the object to destroy itself.
- e.g.

        HRESULT hr; 
        ICar    *pCar; 
        IEngine *pEngine; 
        hr = CoIntialize( NULL ); 
        
        assert( SUCCEEDED( hr ) ); 
        hr = CoCreateInstance( 
          CLSID_Car, 
          NULL, 
          CLSCTX_ALL, 
          IID_ICar, 
          (void**)&pCar ); 
        
        if ( SUCCEEDED( hr ) ) { 
          hr = pCar->QueryInterface( IID_IEngine, (void**)&pEngine ); 
          if ( SUCCEEDED( hr ) ) {
            pEngine->Start(); 
            Drive( pCar ); 
            pEngine->Stop(); 
            pEngine->Release(); 
          } 
          pCar->Release(); 
        }
        CoUnitialize(); 

- What the above code does:
  - Initialises a COM library through `CoInitialize()`.
  - Creates the object `Car` (`Car` is a coclass) and obtains its ICar interface.
  - Then asks for the IEngine interface.
  - Performs some operations and the `Release()`'s the interfaces and uninitialise the COM library.
- Note, The `Drive()` function, by laws of COM, should call `AddRef()` on the received pointer and call `Release()` when it finishes. 
  - But, because the argument interface pointer's lifetime is equal to the lifetime of the function call and is nested in the lifetime of the calling context, which holds the reference on the interface, it can be omitted.


### COM Client calling In-Process Component

- COM uses the registry to look up class ID from `<component_name>`.
- i.e.

        CLSID clsid;
        IClassFactory* pClf;
        IUnknown* pUnk;

        CoInitialize(NULL); // Initialise COM
        CLSIDFromProgId("<component_name>", &clsid);
        
- COM then uses class ID to look for a component in memory if component DLL is not loaded allready).
  - COM gets DLL filename from the registry.
  - COM loads the component DLL into process memory.
  - i.e.

              CoGetClassObject(clsid, CLSCTX_INPROC_SERVER, NULL, IID_IClassFactory, (void**)&pClf);
              if ( component_just_loaded ) {
                // Global factory objects are constructed
                // DLL InitInstance called (MFC only)
              }

  - Notes:
          - COM calls DLL's global exported `DllGetClassObject()` with the CLSID value that was passed to `CoGetClassObject()`.
          - `DllGetClassObject()` returns `IClassFactory*`.
          - COM returns `IClassFactory*` to client.

- Class factory's CreateInstance() function called (called directly through components vtable).
- i.e.

        pClf->CreateInstance(NULL, IID_IUnknown, (void**)&pUnk);

- COM calls DLL's global exported `DllCanUnloadNow()`.
  - if the DLL's object destroyed `DllCanUnloadNow()` will return true.
  - i.e.

          CoFreeUnusedLibraries();

- COM releases resources.
- i.e.

        CoUnitialize(); // COM frees DLL if DllCanUnloadNow()
                        // returns true

- Client exits.
- Window's unloads the DLL if it is still loaded and no other programs are using it.
        
      
    
  

        