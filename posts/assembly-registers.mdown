Categories: assembly
Tags: registers
      addressing

## Assembly Registers

### General Purpose Registers

        EAX       Accumulator     IO Transfers
        EBX       Base Register   Base address pointer
        ECX       Count Register  Indexing (many instructions automatically decrement
                                  count register).
        EDX       Data Register   Sometimes additional I/O register.

### Base and Index Registers

        ESP       Stack Pointer   Indicates top of stack (never write).
        EBP       Base Pointer    Used as pointer to base of stack.
                                  e.g. when calling procedures
        ESI       Source Index    Used to keep track of locations in arrays.
                                  e.g. string processing, copying arrays, FIFO transfers etc
        EDI       Destination Index "As Above"

### Status and Control Registers

        EIP       Instruction Pointer   Address of next instruction in code segment.
        EFLAGS    Flags                 Flags register. cf, pf, zf, sfetc.

### Segment Registers

        CS        Code Segment          Holds instruction program codes.
        SS        Stack Segment         Used to temporarily store information.
        DS        Data Segment          Store data processed by instructions in CS.
        ES        Extra Segment         Extra data segment.
        DS2       Data Segment Pointer 2
        DS3       Data Segment Pointer 3

### Addressing Modes

- EA - Effective Address
- PA - Physical Address

#### 1. Immediate Addressing

- Source operand constant.
- Can be used to load any registers except segment registers.
- i.e. must move a general purpose register first
- e.g.

        MOV ax, 2550h
        EA = Location in main memory where data stored.

#### 2. Direct Addressing

- Address of operation provided with instruction.
- Therefore address offset address in data segment.
- e.g

        MOV dl, [2400h]
        [ ] - memory location
        EA = Constant

#### 3. Register Addressing

- Uses registers (not data) to hold data to be manipulated.
- i.e. fast (since memory not accessed).
- Note, size of operations must match.
- e.g.

        ADD ax, bx
        EA = Register

#### 4. Register Indirect Addressing

- Address memory location where operand resides held by register.
- Address calculated at runtime.
- Can use defaults, or override (see below)
- e.g.

        MOV ax, [bx]
        EA = {[BX], [DI], [SI]}
        PA = DS + {[BX], [DI], [SI]}

##### Default offset registers and allowed overrides for segment

        Segment Register    Default Segment   Allowed Overrides     Purpose
        CS                  IP                -                     Instruction Pointer
        SS                  BP                SP                    Stack Address
        DS                  BX                DI, SI                Data Address
        ES                  BX                DI, SI                String destination address.

#### 5. Register Relative Addressing

- Base registers (bx and bp) or index registers (si or di) and displacement value (8/ 16 bit) used to calculate effective address
- Note, can use defaults or overrides
- e.g.

        MOV cx, [bx] + 10
        which is equivalent to:
        MOV cx, [bx + 10]
        MOV cx, 10[bx]"
        EA = {[BX], [BP], [SI], [DI]} + {disp 8/ 16 bit}
        
        PA = DS + {[BX], [BP], [SI], [DI]} + {disp 8/ 16 bit} (if using defaults)

#### 6. Based Indexed Addressing

- One base register (bp/ bx) and one index register (di/ si) to indirectly address memory.
- e.g.

        MOV dx, [bx + bp]
        which is equivalent to:
        MOV dx, [bx][di]"

#### 7. Relative Based Indexed Addressing

- Least used.
- Combines based indexed and relative addressing modes.
- e.g.

        MOV [bx][si + 4]
        EA = {[BX], [BP]} + {[SI], [DI]} + {disp 8/ 16 bit}