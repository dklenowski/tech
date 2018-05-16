Categories: unix
Tags: memory

## Introduction ##

- Programs (and data) must be in main memory during execution.
- Memory shared among processes, therefore requires management.
- Memory management depends on hardware, therefore management algorithm requires hardware support.
- OS memory non-functional requirements:
  - Allocate memory for address space of process, which consists of:
      - Text.
      - Initialised/Uninitialised data.
      - Stack for procedure calls and return values.
      - Heap for dynamically allocating variables.
  - Deallocate memory when process deleted.
  -  Manage physical memory for multiple user processes.
- OS memory functional requirements:
  - **Address Binding** - Determine physical address for each memory reference in program.
  - **Sharing Physical Memory** - Between multiple user processes.
  - **Memory Protection** - From illegal access (from processes).
  - **Efficient User** - Of physical memory (e.g. minimising memory fragmentation).
  - **Fast Access** - To memory.

## Terms ##

### Address Binding ###

- Binding of instructions/data to memory addresses.
- Binding of user programs (instructions+data) into memory addresses can be done at different places:
  - a. compile time
      - i.e. source to object module.
      - Usually binding is not done here (an exception would be MSDOS .com files).
      - Absolute Code - If memory locations known.
      - Relocatable Code - If memory addresses not known.
  - b. load time
      - logical address = physical address (logical address space starts at 0 in program).
      - i.e. object to load module (linker) or load module to in memory executable (loader).
      - If relocatable, final bindings performed here.
      - If starting addresses change, program must be reloaded (less restrictive than compile time where a recompile is required).
      - i.e. Bindings cannot be changed at runtime.
  - c. runtime/execution time
      - aka dynamic relocation
      - logical address != physical address
      - Memory bindings performed at runtime.
      - When process required to be moved during execution time between memory segments.
      - Requires Memory Management Unit (MMU), i.e. a hardware device that supports a relocation register.

### Dynamic Loading ###

- Routine not loaded into memory until called (required).
- All routines kept on disk in relocatable load format.
- OS provides library routines to implement dynamic loading.
- Advantages:
  - Improved memory utilisation (unused routines not loaded, entire program does not need to be loaded into memory).

### Dynamic Linking ###

- System language libraries combined by loader into binary program image (like object files).
- Postpones actual linking until runtime.
- Uses **stubs**:
  - Included in executable image for each library routine reference code, indicates how to locate appropriate memory resident library routine (or how to load it if not present).
  - Stub then replaces itself with the address of the routine, and is executed.
  - Once replaced, the next time the code segment is executed, library routine executed directly (no cost)).
- Used in **shared libraries**:
  - More than 1 version of library loaded into memory.
  - Distinguished by version information.
- Requires support from OS (esp. when accessing another processes memory).

### Queues ###

#### Input Queue

- Processes that are on disk, waiting to be brought into memory.

#### Ready Queue

- Processes whose memory images are in backing store awaiting to be run.

### Overlays ###

- Only instructions and data that are needed at any given time are loaded into memory.
- When new instructions/data are required, are loaded into space where the previous instructions were (and are no longer needed).
- Some compilers support overlays.
- Was used in MSDOS, when a program was bigger than the size of physical memory.

### Swapping ###

- Process temporarily swapped out of memory into disk backing stored.
- Swapped back in when process ready to be executed.
- Usually processes swapped out and back into the same memory space that it previously occupied (this is dictated by the type of address binding).
- e.g. using a paradigm like **roll out, roll in swapping**
  - Used in priority based scheduling.
  - Higher priority process arrives, memory manager swaps out lower priority process.
- Context switching overhead can be high (reading from disk).
- Process must be completely idle for swapping (e.g. pending io).

## Memory Management

- Generally, programs not loaded into same place in memory (e.g. processes changed order that loaded) and therefore cannot have absolute addresses.
- All memory references (e.g. JMP / MOV) are relative to the beginning of the program.
- 6 basic functions that memory manager must support
  1.  memory location
  2.  multilevel storage
  3.  address mapping
  4.  memory protection
  5.  memory sharing
  6.  memory extension

### Runtime

- Part of OS.
- Relocating Loader
  - Adjust each memory reference to suit the particular location where it is loaded at this time.
- Static Relocation   
  - Done one each time program loaded only on single user machine.
  - Inefficient on multiuser machines (with many processes and pieces of memory).

### Memory Protection 

- One user not read / write memory space of another or OS
- Every memory reference checked at run time by memory manager (with hardware help) (for user supplied input).
- Memory references also checked by compiler,

### Memory Sharing    

- More than one process access same memory area.
- e.g. number processes executing the same application program some applications (e.g. compiler) able to share code (even if different data sections).

### Memory Extension  

- Physical address space limited by hardware and cost (e.g. bus width, number of expansion slots available and the power supply).
- Logical address space size of a program is limited by the number of address bits in an instruction.
- Logical address space can be larger than the installed memory by using virtual memory.


## Addressing ##

### Logical Address ###

- aka Virtual Address
- Generated by CPU (read from program).

### Physical Address ###

- Address loaded into memory register of memory unit.
- i.e. "real" addresses of the instructions and data.
- **physical address space**
  - Set of all physical addressees corresponding to logical addresses.

## Memory Management Unit (MMU)

- Hardware device.
- Performs runtime mapping from virtual (logical) to physical addresses.
- e.g. simple MMU scheme (generalisation of base register scheme):

        CPU, logical address 346 --> relocation register |1400|, physical address 14346 --> memory

- Notes:
  - User program never sees real (physical addresses), only uses logical addresses.
  - Only when it is used as memory address is it relocated relative to the base register (i.e. final location not determined until reference is made).


## Compilation Process

### 1. Compiler/Assembler ###

- Generates object modules from source code.
- Object module contains:
  - Header - Sizes and offsets of all sections.
  - Code - Text of the program.
  - Initialised Data - e.g. static constants.
  - Symbol Table - External information.
  - Relocation Information - If relocatable.

### 2. Linkage Editor ###

- Load time.
- Generates load module form object module.
- Performs 2 main actions:
  - Relocating object modules (code+data) to form a single code and data section.
  - Resolving and linking external references.
- The load module contains:
  - All object modules (text+data).
  - All external references are resolved.
  - Has a single address space starting from 0.
- Linking and relocating algorithm:
  1. Create empty load module and empty global symbol table.
  2. Read next object module.
      - Insert code+data.
      - Relocate addresses in its symbol table.
      - Merge its symbol table with the global symbol table and for each undefined symbol:
          - If symbol defined in global symbol table write its address.
          - Otherwise mark the reference, so it can be resolved when known.
  3. Repeat step (2) for each module.
- **Symbol Table**
  - Used for linking external references.
  - Contains external symbols.
  - Types of symbol references:
    - Defined Symbols
      - Symbols defined in this object module that may be referenced in other modules.
      - Address of symbol recorded in symbol table.
    - Undefined Symbols
      - Symbols defined in other modules and referenced in this module.
      - The address at which used recorded in symbol table.


### 3. Loader

- Copies the text and initialised data into memory.
- Expands the uninitialised data section.
- Creates a stack.
- Creates a hep for dynamically allocated variables.

## Memory Allocation ##

- Memory divided into 2 partitions:
  1. Resident OS
      - Usually placed in lower memory.
      - Includes an interrupt vector.
  2. User Processes
      - Usually placed in higher memory locations.

### Single Partition Allocation ###

- Single process is loaded into memory at a time.
- OS protection using relocation register with limit register.
  - **Relocation Register** - Value of smallest physical address.
  - **Limit Address** - Range allowable for logical addresses.
- logical address < limit register.
- MMU maps dynamically adding relocation register:
  1. CPU selects process for execution (scheduler)
  2. Dispatcher loads relocation and limit registers as context switch.
  3. Every address generated by CPU checked against registers (limit and relocation).
- Advantages: 
  - Simplicity
- Disadvantages:
  - CPU cycles wasted.
  - Main memory not fully utilised.

### Multiple Partition Allocation ###

- Memory divided into fixed size partitions (for multiple user processes).
- Each partition holds 1 process (OS keeps table memory usage).
- Partitions can vary in length.
- Initially all memory considered "hole".

#### Basic Algorithm ####

- Find hole to match job from input queue.
- Split hole and return unused (smaller) portion back to the list.
- Merge adjacent holes when the job is complete.

#### Algorithms for finding holes

- First Fit
    - Allocate first whole that is big enough.
    - Search stopped as soon as hole found.

- Best Fit
    - Allocate smallest hole that is big enough.
    - Produces a smaller leftover hole.
    - Must search entire list.

- Worst Fit
    - Allocate the largest hole.
    - Must search entire list
    - Produces larges leftover hole.

- First Fit and Best Fit best in storage utilisation.
- First Fit generally fastest.


### Fragmentation ###

#### External Fragmentation ####

- Enough memory to satisfy requirements, but not contiguous.
- Occurs as processes loaded/removed from memory and free memory split into little pieces.
- All hole searching strategies suffer form external fragmentation (Worst Fit is generally worst).
- Solution is to use **compaction**:
  - Move address space (shuffle) to form large hole.
  - Not always possible (e.g. statically allocated processes).
  - Compaction strategies difficult to implement and costly (in terms of performance).
- Can combine swapping with compaction to improve compaction results.

#### Internal Fragmentation ####

- Allocated memory larger than requested memory, the memory is memory internal to process but not being used. 
- e.g. hole 18 464 bytes, but process requests 18 462 bytes (2 bytes leftover).
- Overhead to keep track of hole larger than hole itself.
- General approach to allocate small holes as part of larger request, therefore allocated memory slightly larger than requested memory.
- difference is internal fragmentation (in e.g. 2 bytes internal fragmentation).


## Paging ##

- Mechanism for mapping logically addresses to physical addresses.
- Advantages:
  - Eliminates external fragmentation by allowing logical address space of process to be non contiguous (page frames of address space do not have to be contiguous).
  - Eliminates need for compaction.
- Requires fast address translation (page table can be large and usually remains in memory).

### Concepts ###

### Frames ###

- Physical memory broken into fixed size blocks called frames.
- Normally powers of 2 (for easy translation).
- e.g. for an address space size of 2K bytes

        Page Frame Size = 2N bytes (N < K).
        This turns a linear address, a, into a pair (f, d) where:

        f - frame number
        d - displacement (page offset)

        f = a div 2K (K - N bits)
        d = a mod 2K (N bits)

### Pages ###

- Logical memory broken into blocks of the same size as frames called pages.
- Powers of 2 (ranging from 512 bytes - 16 MB)

        Address space size = 2M bytes (logical address space)
        Page Size = 2N bytes (N < M)
        Turning liner/logical address, l, into pair  (p, d) where:

        p - page number
        d - displacement
        p = l div 2K (M - N bits) i.e. high order M - N bits = p
        d = l mod 2K (N bits) i.e. low order N bits = d

### CPU Support ###

- Every address generated by CPU is divided into 2 parts:
  1. Page Number (p) - Used as index into page table.
  2. Page Offset (d)
- **Page Table**
  - Maps page number (p) to frame number (f).
  - Contains the base address of each page in physical memory.
- The base address (in page table) combined with the page offset to define the physical memory address.
- The resultant address is sent to the memory unit.

          Logical Address
              |          -----------------
              |          |               \/
        CPU -------> p | d --------> f | d ---------> physical memory
                     |               /\
                     |               |
                     |    _________  |
                     |--> |_______| -|
                          |__ f __|
                          |_______|
                          Page Table

### Paging Implementation

- Given a logical address `l`:
  1.  Extract the page number (`p`) from the logical address (`l`).
  2.  Extract the displacement / page offset (`d`) from the logical address (`l`).
  3.  Map the page number (`p`) to the frame number (`f`) using the page table.
  4.  Assemble the physical address (`a`) using the equation:

            (f, d) = (f*page_size)+d

- Pseudocode for when a process starts:

        determine page size of process (pages)
        check that required amount of frames available
        if frames available
          first page process loaded into first allocated frame
          frame number put into page table
          frame table entry for frame updated
          update user process page table

- **Frame Table**
  - Used by OS to keep track of free/allocated frames and if allocated which page of which process/es maps to which frame.
- **User Process Page Table**
  - Used by OS to maintain page table for each user process.
  - Whenever the OS performs the mapping manually (logical to physical) a system call needs to be executed (involves context switch).
- **Page Table Structure**
  - A page table allocated by the OS for each process.
  - Pointer stored with other register values in the PCB.
  - Dispatch must then reload registers and define the correct page table values.

#### Example ####


        page size = 4 bytes
        physical memory = 32 bytes (8 pages)
        
        
        logical memory                                    physical memory
        -----------------                                 -----------------
        |   0       a   |                                 |   0           |
        |   1       b   |       page table                |   ..          |
        |   2       c   |       -----------------         |   4       i   |
        |__ 3       d   |       |   0       5   |         |           j   |
        |   4       e   |       |   1       6   |         |           k   |
        |   5       f   |       |   2       1   |         |           l   |
        |   6       g   |       |   3       2   |         |   8       m   |
        |__ 7       h   |       -----------------         |           n   |
        |   8       i   |                                 |           o   |
        |   9       j   |                                 |           p   |
        |   10      k   |                                 |   12          |
        |__ 11      l   |                                 |   ..          |
        |   12      m   |                                 |   16          |
        |   13      n   |                                 |   ..          |
        |   14      o   |                                 |   20      a   |
        |   15      p   |                                 |           b   |
        -----------------                                 |           c   |
                                                          |           d   |
                                                          |   24      e   |
                                                          |           f   |
                                                          |           g   |
                                                          |           h   |
                                                          |   28          |
                                                          |   ..          |
                                                          -----------------
                                                          
        logical address 0 => page 0, offset 0
          a. page number (p)            p = 0
          b. page offset (d)            d = 0
          c. indexing into page table   page 0 = frame 5
          d. physical address (a)       a  = (f * page_size) + d = 20
          
        logical address 4 => page 1, offset 0
          a. page number      p = 1
          b. page offset      d = 0
          c. indexing into page table   page 1 = frame 6
          d. physical address   a = (f * page_size) + d = 24
          
        logical address 13 => page 3, offset 1
          a. page number      p = 3
          b. page offset      d = 1
          c. indexing into page table   page 3 = frame 2
          d. physical address   a   = 9


### Multilevel Paging

- A single page table can be excessively large.
  - e.g. system with 32 bit logical address space and page size is 4 Kb
     - 212 pages to map logical address space.
     - Page table may consist 1 million entries (232/212).
     - If each entry 4 bytes (4 Mb of physical address space for page table alone) which cant be allocated contiguously.

#### 2 level paging scheme

- Page table itself is also paged.
- e.g. for 32 bit logical address space with page size = 4 Kb
- The logical address is divided into:

        page number                              |  page offset
        (20 bits)                                |  (12 bits)
        page 2 number(p1)  |  page 2 offset(p2)  |  "as above"
        (10 bits)          |  (10 bits)

- where:
  - Page 2 number index into the outer page (`p1`).
  - Page 2 offset displacement within the page of the outer page (`p2`).

- 64 bit systems require a 4 level paging scheme.
- SPARC architecture (32 bit addressing) supports 3 level paging mechanism.


### Paging hardware support

- Paging Disadvantages:
  - Suffers from internal fragmentation.
    - Worst case, requires n pages + 1 byte (n + 1 frames) (almost entire frame wasted).
    - Therefore usually use small pages (even though overhead for each page table entry).
    - e.g. page sizes typically 2 or 4 Kb.
  - 2 memory accesses required for each logical address (which can be rectified using hardware support mechanisms).
- In the simplest case, page table implemented as a set of registers:
  - satisfactory if page table small (< 256 entries).

#### page table base register (PTBR)

- Page table kept in main memory, PTBR points to the page table.
- Therefore changing page table requires changing only 1 register (the PTBR) which reduces context switching time.
- Disadvantages:
  - Increased time to access a user memory location.
  - i.e. 2 memory accesses needed to access a single byte
    1.  Memory access to index into page table (using PTBR) which provides the frame number.
    2.  Accessing the desired place in memory (using actual address found in 1).


#### Translation Look-Aside Buffers (TLBs)

- aka Table Look-ahead Buffers / associative registers.
- Special small, fast lookup hardware cache using fast associative memory (registers).
- Each register consists key and a value  (page number, frame number) (p, f) i.e. addressed by contents.
- Contain only a few page table entries (varies between 8 and 2048).
- Pseudocode:

          logical address generated by the CPU
          page number passed to the TLB
          associative registers presented with the item (page number)
          compare with all the keys simultaneously
          if ( found ) /* TLB hit translation exists */
            corresponding value filed (frame number) is output
            frame number is immediately and used to access memory
          else /* TLB miss no translation exists */
            a memory reference to the page table must be made
            when found, add page number and the frame number to 
            the TLB (enables quick find on next reference)

- If TLB full of entries when a new page used, OS must select an entry for replacement.
- Every time a new page table selected (i.e. at each context switch) the TLB must be flushed (erased) to ensure that next executing process does not use the wrong translation information.
- **Hit Ratio**
  - % times that page number is found in the associative registers.
  - e.g. 80 % hit ratio, find desired page in TLB 80 % of the time.
  - Hit ratio directly related to the number of associative registers.
- **Effective memory access time (ea)**

        ea = H * (ta + ma) + (1 - H) * (ta + 2ma)
        where:
        H - TLB hit ratio (in decimal)
        ta - TLB table lookup time
        ma - memory access time

### Memory Protection

- Purpose, to control access mode of a page frame.
- Protection bits associated with each entry of page table (and kept in page table).
- i.e. at the same time that the physical address is checked, protection bits also checked.
  - Bit 1 
      - define whether page read and write or read only
  - Bit 2 (valid/invalid bit)
      - valid - indicates that associated page in the processes logical address space therefore legal/valid page.
      - invalid - page not in processes logical address space.

#### page table length register (PTLR) 

- Supported on some systems.
- indicates the size of the page table.
- value checked against every logical address to verify address in valid range (used as alternative to valid/invalid bit).

#### Memory Protection Fault

- Trap sent to kernel if:
  - Protection bits violated (e.g. attempt to write to a read only page).
  - Illegal address (address outside the logical address space).










