Categories: programming
Tags: c

# C Programming

## Compilation ##

1. Preprocessing    
  - cpp 
  - Edits C program prior to compilation.
  - Performs automatic text replacement, i.e.:
    - Replacing comments by space.
    - Deleting backslash/newline pairs.
    - Expanding pre defined macros.
  - Also performs requested text replacement, i.e.:
    - Text transformations in response to compiler directives (e.g. `#define` and `#include`).

2. Compilation    
  - ccom    
  - Takes modified C file (from preprocessing) and produces an object file (i.e. unix .o)

3.  Assembly
  - as    
  - Produces assembly code.

4.  Linking / Loading ld    
  - Program links object files together to produce executable file.
  - Resolves references to external code / data (e.g. "extern" declarations are left until linking).

### Compiling ###


          # gcc -O -g -o [filename.exe] [filename.c]
          
          -O  Optimization.
          -o  Specify executable file name.
          -g  Generate code for the debugger.
          -c  Compile only.
          -Wunused    Compiler checks and warns about unused variables.
          -Wstrict    Display all error messages.
          -D<STRING>  Pass compile time options to compiler. e.g. -DDEBUG

- To run only the C preprocessor.

        # gcc -E [filename.c]

- In order to specify a library use `-l`.
  - Unix standard libraries are in `/lib`.
  - The linkage spec `-lx` searches for a standard library of the form `libx.a`

            # gcc -I incdir %1.c -o %1.exe -L libdir -lm
            
            -I    Specifies the path to the include .h files
            %1.c  Specifies the first command line argument with .c appended
            -L    Specifies the path to the library files
            -lm   Specifies the loading of the math library functions such as sin() from libm.a.

## Layout ##

- Note, if the compiler is C++ aware, then a single line comments can be used i.e. `//`.

        /* ---- includes---- */ /* # indicates preprocess directives */

        #include <stdio.h>    /* standard header files */
                              /* location system dependant */
        #include "myfile.h"   /* non std header files */

        /* ---- global vars and defines ---- */

        my_val 16;      /* global vars declared outside any program scope */
                        /* i.e. outside any braces "{ }" */

        #define CONSTVAL 16   /* can occur anywhere, but usually beginning */
        
        /* macro definitions, use preprocessing directive */
        /* #define macro_name(identifier, … , identifier) tokenstring;
         * tokenstring specifies an option.
         * No space between first identifier and left parenthesis.
         * No semicolon at end of #define.
         * Can be difficult to debug.
         */
        #define PRINT_INT(x) printf(#x " = %d\n", x); // Note the "#" operator converts the macro argument to an int string.

        /* ---- function prototypes ---- */

        /* Functions must be declared before they can be used.
         * Used to tell the compiler number and type of arguments to be passed to function
         * and type of return value.
         */

        /* external functions:
           return_type function_name (parameter_list); 
           Note:  Identifiers not used in prototypes.
                  Must end with a semi colon
         */
        extern void someFunct(long);

        /* ---- main program ----- */

        int main (int argc, char *argv[]) {
          /* argc - argument count.
           * argv - array of char pointers to command line arguments.
           * Can use double indirection i.e. char **argv
           * Or array of pointers to char i.e. char *argv[]
           * argv[0] is the command itself.
           * Therefore if command has arguments argc >= 1.
           */
           // do something
           return 0;     /* returned to OS, usually not used */
        }
  
        /* ---- functions ---- */
        
        return_type function_name(parameter_list) {
        /*  return_type   "void" or legal data type NOT ARRAY.
         *                can only be 1 return value.
         *                can be >= 1 return statement in function.
         *  call by value     arguments to functions always passed by value.
         *                    the variables passed as arguments to
         *                    functions are "not changed" in the calling
         *                    environment (i.e. a copy is passed)
         *                    unless pointer (aka call by reference)
         *  actual parameters   parameters in main function passed to function
         *  formal parameters   parameters used within function
         */
          /* local vars */
          // do something
          return 1;
        }

## API Layout

### `stackarr.h`


        typedef int element;            // ADT Stack = seq ElementType
        typedef struct StRec *StRecPtr;
        typedef StRecPtr Stack;         // concrete data type
                                        // this is the opaque type
        
        /*  function prototypes  i.e. operations on stack (ADT)  */

### `stackarr.c`
        
        #include "stackarr.h"
        struct StRec  {
          ElementType items[MAX];
          int Top;
        }
        
        int IsEmpty(Stack st) {
          return (st->Top);
        }
        
        Stack Create(void)  {
          st = (Stack)malloc(sizeof(struct StRec));
        }
        
        /* other function definitions */

### `teststack.c`
        
        #include "stackarr.h"
        
        int main(void) {
          Stack st;
          // do something with a stack
        }


## Preprocessor Directives

- ONLY USED on ANSI compliant servers.
- Error handling using compiler built in macros.

          #include <stdio.h>
          #include <stdlib.h>

          __FILE__      filename        %s  C preprocessor macro for file (module) name.
          __LINE__      line in file    %d  C preprocessor macro for line number within module.
          __DATE__      Mmm dd yyyy     %s
          __TIME__      hh:mm:ss        %s

## Datatypes ##

- Integral types (used to hold integral values).

          unsigned char     char        signed char
          short             int         long
          unsigned short    unsigned    signed long

### Boolean ###

- There are no inbuilt boolean types, therefore use:

          #define FALSE 0
          #define TRUE  1

### char ###

- holds characters, small ints.
- usually 1 byte = 8 bits = 256 distinct values.
- signed char -128 - 127, unsigned char 0 - 255

### int ###

- usually 2 or 4 bytes.
- Stores natural numbers.
- Short and long used special purposes.
- e.g. When having storage concerns use `short`.
- e.g. When required to store very large reals use `long`.

### float ###

- Holds reals.
- Default type is `double`.
- Suffix appended floating constant to specify type.
- i.e. for float use `f` or `F`
- i.e. for double use `l` or `L`
- e.g.

          3.7F
          3.8L

## Datatype Functions ##

### `typedef` ###

- Used to create new types.
- Explicitly associate type with identifier.
- Appear before variable declarations.

### sizeof()

- Unary operator, returns number of bytes needed to store object.

## Structured Types

### Enumerated Types

- Used to enumerate subsets of ints/chars.
- Similar to defining constants using `#define`.
- Syntax:

          enum name  {  list, of, names } variable-list;
          name              Reference (declare variables of type 'name').
          list, of, names   List of constant names (members of enumerated type).
                            Defined starting at 0.
          variable-list     If omitted, declares new enumerated type used to declare variables of that type.

- The underlying representation is integer (i.e. provides integer mappings to values).


### Arrays

- Array name is pointer to location in memory where elements stored.
- Can only have array containing values of the same type.
- Arrays are initialised at variable declaration to 0 (unless otherwise specified).
- 1D array syntax:

        element-type array-name[size]
        element-type    Any type (integral, struct).
        size            Used to allocate space.
                        i.e. space allocated for size element array.

- where:

        lowerbound  0       array-name[0]
        upperbound  size-1  array-name[size-1]

- 2D array syntax:

        element-type array-name [size-i][size-j]

- Note, when passing array in function (passed by reference) don’t include size in array declaration.

### Strings

- Array of characters terminated by null character `\0`.

#### Static Initialisation ####

    char string-name[string-length]

- Note, must include space for the null character `\0`.

#### Dynamic Pointer Initialisation

    char *str = "a string";     // declaration
                                // modifiable
    str = "a string"            // string constant
    
    char *str;
    str = malloc(length-of-string);

### Structures

- Syntax (to define):

        struct struct-name {       /* tag name */
          field-type-1  field-name-1;   /* member 1 */
          field-type-2  field-name-2;   /* member 2 */
        } [instance-name];         /* instance-name is optional */

- Syntax (to declare):

        struct struct-name instance-name;

- Note must be declared after struct type declaration.
- Use dot notation to access.


#### Using `typedef`

- Declaration:

        typedef struct struct-name new-type-name;   // declares a new type

- Using:

        new-type-name new-instance



### Pointers

- Address of object in memory.

#### `&`
- Address of operator (used to specify what pointer points to).
- System calculates address of variable.
- For arrays, char pointers, points to start of pointer in memory used only as rValue.
- e.g.

        int x, *ptr1, *ptr2;
        ptr1 = &x;          // pointer points to address of variable x
                            // i.e. changing x will change pointer

#### `*`

- Indirection / dereferencing operator (unary).
- Used to initially create pointer type.
- Note, cannot deference an uninitialized pointer.
- Also used to access actual value pointed to by pointer.
- i.e.

        lValue - Set pointer value.
        rValue - Copy pointer value.

- Legal values for pointer type:
  - Address of variable of associated base type.
  - `NULL` which indicates reference to nothing.
    - Defined as constant `0` in `stdlib.h` and `stdio.h`.

- e.g.

        int x = 10, *ptr1, *ptr2; // allocates addresses of pointers 
                                  // &ptr1 = 7548888 (i.e. the memory address)  
                                  // &ptr2 = 7548884 (i.e. the memory address)

        ptr = NULL;               // initialise pointer
                                  // must do this before the next operation below.

        *ptr1 = 10;               // &ptr1 = 7548888  *ptr1 = 10

        ptr2 = ptr1;              // addresses unchanged, *ptr2 = *ptr1 = 10

        &ptr2 = ptr1;             // ALSO &ptr2 = ptr1, &ptr2 = &ptr1

        ptr1 = &x;                // changes what ptr1 points to (NOT address of
                                  // of ptr1)
                                  // i.e. doesn’t change &ptr1, changes ptr1

        /** the following are NOT allowed **/
        *ptr2 = ptr1              // NOT ALLOWED (*ptr2) of type int whereas
                                  // ptr1 of type pointer to int
        ptr2 = *ptr1;             // NOT ALLOWED, (*ptr1) int
        ptr2 = &ptr1;             // NOT ALLOWED, incompatible pointer types

- i.e.

        ptr1      // what ptr1 points to either value (*ptr = x) or address (ptr1 = &x)
        *ptr1     // changes the actual value of the pointer
        &ptr1     // location in memory where pointers contents stored (never changes)

- For struct pointers (i.e. a pointer pointing to a struct) can use the dereferencing operation (`->`) to access members of the struct. 
- e.g.

        ptr1->field-name        // treated as a variable

#### Dynamic Allocation

- Can statically allocate pointers.
- e.g.

        int *p, num;
        num = 10;
        ptr = &num;     // Although NOT recommended.

- Must acquire memory locations from the heap using `malloc()`, `calloc()` and `realloc()` from `stdlib.h`.
- e.g.

        int *p;
        p = (int *)malloc(sizeof(int));

- e.g.

        typedef struct {
          char name[20+1];
          double gpa;
        } Student;

        short num_students = 10;
        Student *records;   // pointer to student record struct's

        records = (Student *)malloc(num_students*sizeof(Student));
                      // |_ points to             |
                      //                          |_ how many it points to

        // working

        free(ptr_records);

#### Call by Reference

- Used when function required to change variable in calling code.
- Process (function pass by reference):
  - Function must take as input parameter, a pointer to the variable in the calling code.
  - The call to the function passes the address of the variable you want to change.
  - Code inside the function must dereference the pointer (formal parameter) to access the variable in the calling code (actual parameter).

#### Deleting Pointers ####

- Illegal to delete a pointer that has already been deleted.
- Therefore set all deleted pointers to `0` (`null`), it is safe and legal to delete a `null` pointer.


## Datatype Storage Class

Every variable and function 2 attributes : type and storage class.

1. automatic (auto)  

  - Variables within function/blocks "auto" by default.
  - When block entered:
    - System automatically allocates memory for "auto" variables within that block, "auto" variables considered local to that block.
  - When block exited:
    - System releases memory that set aside for "auto" variables and therefore values are lost.
  - If block reentered:
    - System allocates memory, but previous values unknown.
    - i.e. each invocation of block sets up new environment.

2. external (extern) 

  - External variable exists for the life of the program.
  - `extern` used to tell compiler to look for it elsewhere (either in this file or some other file).
  - For variables
    - Considered global to all functions declared after it.
    - Upon exit from block / function, external variable remains in existence.
  - For functions 
    - All functions have an external storage class/
    - MUST use in function definition and prototype.
  - External variables are not recommended (error prone).

3. register (register) 

  - Tells compiler that associated variable should be stored in register provided physically/semantically possible to do so.
  - Defaults to automatic, whenever compiler cannot allocate an appropriate physical register.
  - Usually used on loop variables and function parameters.
  - Try to declare as close as possible to its place of use, to allow for maximum availability of physical registers.

4. static

  - Three uses:
  
    1. Allow local variable to retain its previous state when block reentered.
      - i.e. ordinary automatic variables loose values upon exit.
      - If declared within function, remains private to that function.
      - If global, other functions can access.
        
    2. In connection with external declarations.
      - Static external variables used to restrict scope of external variables to remainder of the source file in which they are declared.
      - i.e. unable to functions defined earlier in file or functions  defined in other file (even if these functions attempt to use external).
    
    3. As a storage class specifier for function definitions and prototypes.
      - i.e. static functions only visible within the file in which they are defined (useful for private modules).

- Note, if a storage class is specified, but the types is absent, default type int both external and static initialised to zero by system (if programmer hasn't done it) automatic and register variables are not initialised by system.

## Memory Layout ##

        |-----------------------------------------------------|
        |   Code                                              |
        |   Static Data (e.g. constants, global variables)    |
        |   Run Time Stack                                    |
        |   Heap                                              |
        |-----------------------------------------------------|
        
### Run Time Stack

- When function called the function code executed on data provided (formal parameters/local local function variables) at the time of call.
- These values stored on the Run Time Stack (RTS).

The runtime stack:

- Consists of stack frames.
- When function called, new stack frame pushed onto RTS.
- Stack frames not homogeneous (different number and types (size) of parameter record for different functions).

#### Activation Record

- aka stack frame for function call.
- Provides the environment in which function executes.
- Stores parameters passed, local variables and return variables.
- Keeps track of the previous frame using:
    - Program Counter (PC)
      - Current instruction being executed.
    - Stack Mark
      - Return code address (PC) and return stack address (BP register).
    - Top
      - (bottom) of stack is the SP register value.


                  |-----------------------------------------------------|     |
                  |   Activation record for function 1                  |     |   Stack grows downward
                  |   Activation record for function 2                  |     \/
                  |-----------------------------------------------------|
                  
                  |-----------------------------------|
                  |                                   |
                  |   Return Value                    |
                  |   Second Parameter                | 
                  |   First Parameter                 |
                  |                                   |   __ 
                  |   Return Code Address (old PC)    |     |   Stack Mark
                  |   Return Stack Address (old BP)   |   __|
                  |                                   |   __    New BP
                  |   Local Variable 1                |
                  |   Local Variable 2                |
                  |-----------------------------------|   __    New SP

#### When function called

- Space pushed onto the RTS to allow the return value to be stored parameters are pushed (in reverse order).
- Return address to the calling code (current value of the PC register) is pushed.
- Return address to the top of the previous stack mark (the current value of the BP register) is pushed.
- Local variables are pushed.

#### When function returns

- Local variables are popped from the RTS.
- Value of the old BP is restored (giving access to the previous stack frame).
- Return code address is popped into the PC allowing the program to continue at the next line of code.
- Function parameters are popped.
- Return value of the function is assigned to the variable / expression.

Notes:

- Function completes execution and its environment erased before the calling code can continue (therefore all functions local variables / parameters accessible only when activation record for function).
- These values only accessible from inside the function itself or inside any function it calls (from a stack frame after it in the RTS).

## Operators ##

### Type Conversions ###

- For expression mixed type promotion of lower type promoted to higher.
- i.e.

          int < unsigned < long < unsigned long < float < double  

- Note, any `char` or `short` is promoted to `int`.

### Arithmetic

        % (modulus), +, /, -, *

### Relational

        ==, !=, >, >=, <, <=

### Logical

- Short circuit evaluation.

        &&, ||, !

- Note, use single `&` and `|` for bitwise `and` and `or`.

### Increment/Decrement

- Can use both [pre|post]fix.

        x++   // increment x, return OLD x
        x--   // decrement x, return OLD x

        ++x   // increment x, return NEW x
        --x   // decrement x, return NEW x

### Extended Assignment

        +=, -=, *=, /=, %=

- In general:

        x = x op value is equivalent to x op= value

## Control Statements ##

### if/else ###

    if ( expression ) {
      /* statements */
    } else {
      /* statements */
    }

### while ###

    while ( expression ) {
      /* statements */
    }

### for ###

    for ( expr1; expr2; expr3 ) {
      /* statements */
    }
    
    expr1   Initial assigment.
    expr2   Test condition.
    expr3   Increments/decrements stored value.

which is equivalent to:

    expr1;
    while ( expr2 ) {
      /* statements */
      expr3;
    }

### switch

    switch ( expression ) {
      case value1: {
        /* statements */
        break;
      }
      case value2: {
        /* statements */
        break;
      }
      
      default {
        /* statements */
      }
      
    }


## `stdio.h` ##

### int printf(const char* format, ....);

- Consists of a control string and arguments.
- Control String:

        Conversion Spec "%" + Conversion Chars

- Conversion Chars:

        %c    Character
              Single quotes used to designate char constants
        %d    Decimal integer.
        %e    Floating point (scientific notation).
        %f    Floating point.
        %s    String.
        %x    Hexadecimal.
        %o    Octal.

        %m.ne Print float in "e" format in "m" spaces total with "n" digits to
              right of the decimal point.

- Formatting:
  - Used field width (specifies minimum number of characters printed).
  - Placed between conversion spec "%" and conversion character.
  - e.g.

            printf("%5c\n", 'c');

- Non Printing Characters:
  - Used within control string.

            \n    new line
            \t    horizontal tab
            \r    carriage return

- Returns number of characters printed or error.

### int scanf("control-string", list, of, addresses);

- Analogous `printf`, but used for input.
- Control String:
  - Formats way characters in input string are to be interpreted.
- List Of Addresses:
  - Addresses of locations to store values.
- Returns number of accomplished conversions accomplished or system defined end of value
- Notes:
  - When reading in numbers, `scanf()` will skip white spaces (blanks, newlines, tabs) but when reading in a character white space is not skipped.
  - Since buffered input, must `fflush(stdin)`.



## File IO ##

- Using the `stdio.h` buffer.
- Only written to disk when the buffer is full (manually must call `fflush()`).
- 3 files opened at start of program:
  - stderr - For errors.
  - stdout - Normal output.
  - stdin - Normal input.
- To open file:

            FILE *fopen(char *filename, char *mode);
            FILE *    File descriptor.
            mode      r - read, w - write, a - append.
                      For write an append, if file doesn't exist, is created.
            
- To test file opened:

        if (myfile == (FILE *)NULL)

#### `close void fclose(FILE *);`

#### `fgetc fgetc(FILE *);`

- Read a character from file.

#### `fgets(char *string, int n, FILE *fd);`

- Read from file descriptor into string until n-1 characters have been read or newline is encountered and append a `null` character.

#### `int fscanf(FILE *fd, "format", &args);`

- Read from file descriptor values for `&args` of appropriate format.
- Returns:
  - 1 - successful.
  - 0 - format conversion fails.
  - -1 - if eof encountered.

#### `fputc(FILE * fd);`

- Write a character to the file descriptor.

#### `fputs(char *string, FILE *fd);`

- Write `<*string>` to file descriptor.
- Neither the terminating null nor new line is appended to the file.

#### `fprintf(FILE *fd, "format", args);`

- Write the values of args to file descriptor in the appropriate format.


## `stdlib.h`

### `exit()`

      void exit (int val)

where `val`:

      nonzero   Error.
      0         Normal exit.

### `system()`

      int system(const char *command)

- Run a command from within a C program.
- Function executes command as shell command (uses default shell `sh`).
- Searches directories in `PATH` for location of command.
- Must wait until the sub program terminates before continue execution of parent process (calling program).
- Returns `-1` on error otherwise status of shell process.


## Optimization

### Generating Assembly

- Use `-S` switch to interleave assembler code in C source file.
- To generate the assembler `asm` file use:

        # gcc -S asmeg.c -o asmeg.asm

### Compiler Optimisation

- e.g. Using optimisation level 1 in GNU C.

        # gcc -01 file.c -o file.exe

### Constant Folding

- Performing calculations which reduce to constant values at compile time.
- e.g.

        r = 4*5;

- reduces to:

        movw $20, -8(%ebp)

### Constant Propagation

- e.g.

        short result, tmp = 34;
        some_function(tmp);

- reduces to:

        movw $34, -4(%ebp);
        movswl -4(%ebp), %eax
        push %eax
        call _some_function

- Passing the constant `34` is reduced to:

        pushl $34
        call _some_function


### Strength Reduction

- Reducing time consuming operations (e.g. arithmetic operations) with simpler logical operations.
- e.g.

        r = r*9

- reduces to:

        sall $3, %eax
        addl %edx, %eax

- i.e. shift left by 3 bits (multiply of 8) followed by addition.
- i.e.
      
        *9 equiv to *(8+1)

- Otherwise integer multiplication required as in:

        r = r*r

- reduces to:

        imulw -8(%ebp), %ax

### Dead Code ###

- i.e. code used during debugging phase.
- Efficient code should be able to detect some dead code (e.g. using `-Wstrict`)

### Registers

- Storing frequently used vars in registers rather than in memory (the default).

        for (i = 0; i <4; i++) {
          k = 6;
        }

- reduces to:

        mov $0, -4(%ebp)
        L3:
          cmpw $3, -4(ebp)
          jle L6
          jmp L4
        L6:
          movw $6, -6(%ebp)
        L5:
          incw -4(%ebp)
          jmp L3

- i.e. var `i` stored in memory location `-4(%ebp)`.
- Instead use `register` qualifier to request compiler to use registers (rather then memory).
- e.g.

        register short i, k, r;

- reduces to:

        xor %edx, %edx
        L3:
          cmpw $3, %dx
          jle L6
          jmp L4
        L6:
          movl $6, %ecx
        L5:
          incl %edx
          jmp L3
        L4:

- var `i` stored in register `dx`.
- Note that `register` declaration is a suggestion to the system (as registers limited) and depends on availability.
- does not require use register

### Loop Unrolling

- e.g. 

        for (i = 0; i <4; i++) {
          k = 6;
        }

- reduces to:

        mov $0, -4(%ebp)
        L3:
          cmpw $3, -4(ebp)
          jle L6
          jmp L4
        L6:
          movw $6, -6(%ebp)
        L5:
          incw -4(%ebp)
          jmp L3

- i.e.  at each iteration of loop theres in increment (`incw`), test (`cmpw`) and branch (`jle`) which form the loop overhead.
- Small loops may be replaced by direct copies of the code executed within the loop
- e.g. use:

        r = r + i * some_val

- and optimise, end up with no loops

        _some_function:
          push %ebp
          movl %esp, %ebp
          movl 8(%ebp), %eax
          movl %eax, %edx
          addl #32400, %edx
        
          movl %eax, %ecx
          addl %eax, %ecx
          addl %ecx, %edx
          addl %eax, %ecx
          addl %ecx, %edx
        
          movswl %dx, %eax
          leave
          ret


### Use of pointers

- Loops often used to iterate over data stored in array the array index must be calculated at compile time.
- Using a construct such as `myClass[student_num].age = 0;` forces the compiler to calculate the offset as:

        memory address of myClass+
        student_num+
        bytes occupied by student struct+
        offset of age element
  
        on each iteration.

- pointer alternative simple increments by a fixed amount (size ofstudent struct) at each iteration (which is more efficient).

### Loop Invariance

- Calculations/memory transfers which are coded inside a loop but which can be performed outside the loop.
e.g.

          for (i = 0; i < 4; i++) {
            s = i+k*j;
          }
 
- In the example above the value `k*j` could be pre-calculated and assigned to a variable prior to the loop entry.


### Function Inlining

- Each function has entry code (prolog) and exit code (epilog).
- i.e. set up stack frame / restore stack
- Function inlining replaces small functions with verbatim copies of the functions code, thus removing overhead for entry/exit code.
- The only disadvantage is the executable code becomes longer.


### Data Alignment

- For processors with 32/64 bit memory buses, accessing an 8 bit structure still takes one memory access.
- Using data structure containing a mixture of 1 or 2 byte quantities means that for the most efficient memory usage, quantities should be packed together.
- Note, byte quantities may straddle a 32/64 bit boundary.


### Memory Allocation

- Memory allocation may be done dynamically.
- e.g temporary buffer used for calculation, processing of data records etc
- Use `malloc()` and free memory using `free()`.
- Memory is guaranteed to be contiguous.
- Notes for `malloc()`.
  - Must include `stdlib.h`.
  - Always check return variable from `malloc()`.
      - If `NULL`, the system was unable to find a contiguous block.
  - Writing to memory beyond the allocated block will result in a "memory protection fault".
      - If `malloc()` given size of N bytes allowable byte offsets are 0 to N-1.
  - Don't change the pointer returned from `malloc()`.
  - Incorrectly declaring a pointer type for the allocated block or not type casting the returned pointer former cause fatal errors latter causes compiler warnings.
  - Must call `free()` when finished using memory (else memory leaks).
  - Don't use memory after `free()` has been called.

- Disadvantages:
  - Amount of free memory available to other applications reduced.
  -  Array size would need to be compiled into program.

### Memory Copying and Searching

- Fast and efficient memory copying is very important function use library function `memcpy()`.
- e.g.

          #include <string.h>
          #define IO_BUFLEN   1024

          int main(void) {
            char src[IO_BUFLEN];
            char dst[IO_BUFLEN];
            memcpy( (void *)dest, (void *) src, (size_t)IO_BUFLEN);
            ....
          }

- `memcpy()` takes void pointers, therefore can copy any arbitrary block irrespective of actual data type.
- There is also `memset()` to set block to particular value and `memchr()` to search block for particular `char`.
         
    
  
