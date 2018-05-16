Categories: visual c++
Tags: definition
      unmanaged
      managed
      hungarian

# Visual C++ Definitions

## Definitions

### Unmanaged Code

- Runs directly under windows.
- Does not require the .NET runtime to be installed.
- Is generally faster than managed.

### Managed Code

- Runs in the .NET runtime.
- i.e. compiles to an Intermediate Language (IL) and runs in the Common Language Runtime (CLR).
- Managed code provides: Memory Management, Security, Threading, Exceptions,
- Interoperability between languages, Interoperability to and from COM
- Is possible to run unmanaged code in the CLR (classes and objects used in that code will all be unmanaged data) but the code will compile to IL and run.

### Microsoft Foundation Classes (MFC)

- Set of pre-defined classes upon which Windows programming with visual C++ is built. i.e. encapsulates the Windows API.
- All classes in MFC have names beginning with C (e.g. `CDocument`/`CView`)

### Hungarian Notation

| Prefix | Description |
| ---- | ---- |
| b | BOOL (equivalent to int) |
| by | unsigned char (i.e. "by"te) |
| c | char |
|dw |  DWORD (unsigned long) |
|fn | function |
|h | handle (used to identify something e.g. an int value) |
|i | int |
|l | long |
|lp | long pointer |
|n | int |
|p | pointer |
|s | string |
|sz | zero terminated string |
|w | WORD (uunsigned short) |
| m_ | Data member of class e.g. m_lpCmdLine is a data member of type pointer to long. |

### File Types

| File Type | Description |
| ---- | ---- |
| .obj | Compiler produces object files containing machine code from your program source files. Used by the linker, along with files from the libraries to produce the .exe file. |
| .ilk | Used by linker to rebuild project. Allows linker to incrementally link the object files produced from the modified source code into the existing .exe file. |
| .pch | Pre-Compiled Header file. Code which is not subject to modification (e.g. machine generated code) can be processed and stored in the .pch file  reduces build time). |
| .pdb | Contains debugging info used when you execute program in debug mode. |
| .idb | Contains additiona debug information. |
| .rc/.ico | Contain definitions for the specification of menus/toolbar buttions etc Tracked automatically by Visual C++. |
| .rgs | Contains information entered in the system registry for a COM object. |
| .def | For DLL's, used by Visual C++ during compilation. Contains name of DLL. |