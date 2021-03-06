Categories: programming
Tags: c++

## Miscellaneous 

## Operators ##

### Pointers ###

#### `&`

- Address Of Operator
- Used to find a memory address.

        int* ptr = &anotherint;

#### `*`

- Indirection
- Used in 2 ways (declaration and dereferencing).
- e.g. declaration

        int* ptr = 0;

- e.g. dereferencing

        *ct = 10;

#### `.`

- Dot operator.
- Used to access data members of object.
- e.g. locally stored objects

        Cat* ptr = &old;
        ptr.age = 10;

- e.g. free store (must dereference object and call dot operator on object pointed to by pointer).

        Cat* ptr = new Cat
        (*ptr).setage(10);

#### `->`

- Points to operator.
- Shorthand notation for dereferencing object.

        Cat* ptr = new Cat
        ptr->setage(10);


### prefix Vs postfix

#### prefix

- Before the variable name. (`++age`).
- Evaluated before the assignment.
- Increment value and fetch.
            

#### postfix

- After the variable name (`age++`).
- Evaluated after the assignment.
- Fetch the value and increment the original.

        int x = 5;
        int a = ++x;   // a = 6, x = 6
        int b = x++;   // b = 6, a = 7

### Header Files

- Namespace `std` not backward compatible to old header files in which identifies in the C++ library are declared in the global scope.
- Standard header files no long have extensions.
- i.e. include statements for std header files now look like:

        #include <iostream>
        #include <string>

- How actual include statements are handled is implementation dependent, but it is the responsibility of the compiler to provide the mappings (i.e. from `.h`).
- `.h` is supported for backward compatibility.
- User defined header files should include a `.h` extension.

### Arrays

        //
        // Declaration
        //
        int arr[5];  // indexes from 0 to 4
        
        //
        // Initialisation
        //
        int arr[5] = { 1, 2, 3, 4 };
        int arr[]  = { 1, 2, 3, 4, 5};
        
        //
        // Array of Objects
        //
        Cat litter[5];
        litter[5].GetAge();
        
        //
        // Multidimensional
        //
        int board[5][2];   // 5 rows, 2 columns
        for ( int i = 0; i < 5; i++ ) {
          for ( int j = 0; j < 2; j++ ) {
            board[i][j] = 1;
          }
        }
        
        int arr[4][3] = {  { 1, 2, 3 },
                           { 4, 5, 6 },
                          { 7, 8, 9 },
                          { 1, 2, 3 } };

#### Pointer to Array Vs Array of Pointers

        Cat one[500];   // array of 500 Cat's
        Cat* two[500];  // array of 500 pointers to Cat
        Cat* three[500] = new Cat[500];  // pointer to an array of 500 Cat's

- Notes:  
  - `three` variant of `one` (address of `three` is the address of the first item in that array).
  - Array name is a constant pointer to the first element of the array.

              Cat one[50]; // one is a pointer to one[0] 
                           // i.e. the address of the
                           // first element in the array

  - When you create an array using: 

              new <class>[<size>]

  - you delete that array and free all its memory with the `delete[]`
      - Brackets signal to the compiler that an array is being deleted.
      - Leaving the brackets off, only the first element is deleted.


## Program Layout

- Ref: Compaq C++ User Documentation for Tru64 Unix

### Code that does not use templates

- Header Files (Declarations)
    - Class declarations
    - Global function declarations
    - Global data declarations
    - Inline function declarations

- Library Source Files (Definitions)
    - Static member data definitions
    - Out of line member function definitions
    - Out of line global function definitions
    - Global data definitions

e.g.

        // array.h
        #ifndef ARRAY_H
        #define ARRAY_H
        
        class array {
            private:
                int curr_size;
                static int max_array_size;
        
            public:
                array() : curr_size(0) { ; }
                array(int);
        };
        #endif
        
        // array.cpp
        #include "array.h"
        
        int array::max_array_size = 256;
        
        array::array(int size) : curr_size(size) { ..; }

### Code that does use templates

- Header Files - Declarations and definitions.
    - Declarations of global function templates
    - Declarations of class templates
    - Declarations of global function template specialisation's
    - Declarations of class template specialisation's
    - Definitions of out of line global function templates
    - Definitions of static member data of class templates
    - Definitions of out of line member functions of class templates

- Library Source Files - Specialisation's.
    - Definitions of global function template specialisation's
    - Definitions of static member data specialisation's of class templates
    - Definitions of out of line class member function specialisation's

- Note: These guidelines should also apply to non-template nested classes inside of template classes.

e.g.

        // array.h
        #ifndef ARRAY_H
        #define ARRAY_H
        
        template <class T> class array {
            private:
                int curr_size;
                static int max_array_size;
        
            public:
                array() : curr_size(0) { ; }
                array(T);
        };
        #endif
        
        // array.cpp
        template <class T> array<T>::max_array_size = 256;
        
        template <class T>
        array<T>::array(int size) : curr_size(size) { ; }
        
        // main.cpp
        #include "array.h"
        
        main() {
            array<int> ai;
            ..
        }


## Pre-Processor

- Runs before compiler.
- Looks for pre-processor instructions (begin with "#").
- Everything in pre-processor is not type safe.
      

### `#define`

- Defines a string substitution.
- DONT use for constants, makes a string substitution and does no type checking.

          #define BIG 512;
          int myArray[BIG];

### `#ifdef`

- If `true`, will execute everything up to the `#endif`.

### `#undef`

- Use `#undef` often to avoid leaving stray definitions in your code.

### Inclusion Guards

      // dog.h
      #include <animal.h>

      // cat.h
      #include <animal.h>

      // main
      #include <dog.h>
      #inlude <cat.h> // compile time error, illegal to declare a class (animal) twice

      //
      // Using an inclusion guard in animal.h
      //
      #ifndef ANIMAL_H
      #define ANIMAL_H // ANIMAL_H will only be defined once, 
                       // therefore the file will only be read once

      // animal.h code ..
      #endif

### Macro's

- Symbol created using #define that takes an argument (aka function).
- Disadvantages:
  - Confusing if macro's large.
  - Macro's expanded inline each time they are called.
  - Hard to debug.
  - Not type safe.
- e.g.

          #define TWICE(x) ( (x) * 2 )
          // calling in code
          TWICE(4)
          
          // macro with multiple parameters
          #deifne MAX(x, y) ( (x) &gt; (y) ? (x) : (y) )


## Constants

### Literal Constants 

- Value typed directly into the program.
- e.g.

          int val = 15; // 15 is a literal constant

### Symbolic Constants 

- Similar to literal, except once defined cannot be changed.
- e.g.

          // traditional C way, obsolete in C++
          #define numOfStudents = 10;
          
          // C++ way
          const unsigned short int numOfStudents = 15;

### Enumerated Constants 

- Used to define a type and restrict the type to a set of possible values. 
- Every enumerated constant has an associated integer value (enumerator values are `unsigned int`) and if not specified the enumeration starts at 0.   
- e.g.

        // declare enumeration COLOR
        // RED assigned 0, BLUE = 1 etc
        enum COLOR { RED, BLUE, BLACK, GREEN YELLOW }
        
        COLOR c;
        if ( c = RED ) {
         ..
        }
        
        // Define own integer values, remaining undefined constants 
        // will increment from the previously defined constant
        enum COLOR2 { RED=100, BLUE=200, BLACK }

## `static`

- Variables defined outside any function have global scope and are available from any function in the program (including main).
- Local variables defined with the same name as global variables hide the global variable for the life of the local variable.
- Note, should not apply "static" to variable defined at file scope, this is being deprecated. i.e. Use namespaces instead.
- e.g.

        class Cat {
          public:
            Cat();
            ~Cat();
            static int howManyCats;  // declaration
          private:
            // ..
        };
        
        int Cat::howManyCats = 0;        // definition
        // ..
        
        int main() {
          std::cout << Cat::howManyCats << std::endl; // i.e. must be fully qualify
        }

- Note, "declaration" does not assign storage space (since the variable is technically not part of the object), therefore must explicitly define he object.

## `const`

- If `const` appears to left of asterisk, whats pointed to is constant. 
- If `const` appears to the right of the line, the pointer itself is constant.
- If const appears on both sides, both are constant.
- e.g.

        char* p             = "Hello";  // non-const pointer, non-const data
        const char* p       = "Hello";  // non-const pointer, const data
        char* const p       = "Hello";  // const pointer, non-const data
        const char* const p = "Hello";  // const pointer, const data
      
-  Therefore, the following functions take the same parameter type `class Widget { ... }`

        void f1(const Widget* pw);   // f1 takes pointer to a const Widget
                                     // object
        void f2(Widget const *pw);   // so does f2
      
- Its often simpler to use a reference in preference to a const pointer (since references are inherently `const`). i.e.

        const T& rct = *pt;  // rather than const T* const
        T& rct = *pt;        // rather than T* const

- Further examples:

        const int* ptr;       // the value that is pointed to cannot be changed
        int* const ptr;       // the integer can be changed, but ptr cannot point to anything else
        const int* const ptr; // value that is pointed to cannot be changed, and ptr cannot be changed to anything else

- Look to the right of the constant declaration:
  - `variable` => Pointer variable itself that cannot be changed.
  - `type` => Value cannot be changed.

## Namespace

- Groups related items into a specific "named" area.
- Can have many occurrences of a namespace (i.e. can span multiple files).
        
        // header1.h
        namespace Window {
          void move(int x, int y);
        }

        // header2.h
        namespace Window {
          void resize(int x, int y);
        }

- As for classes, should separate namespace implementation from namespace declaration.
- Can only add new members to namespace within its body.
- Namespace functions cannot be inlined (i.e. if you define a function inside a namespace or apply the inline keyword, the function will not be inline.
- Cannot apply an access specifier within a namespace, all members within a namespace are public.

        namespace Window {
          private: // ERROR 
            void move(int x, int y);
        }

- Namespace can be nested within other namespaces, have to fully qualify.

        namespace Window {
          namespace Pane {
            void size(int x, int y);
          }
        }
        
        int main() {
          Window::Pane::size(10, 20);
        }

- Can nest classes within namespace.

        // 
        // declaration
        //
        namespace Window {
          const int MAX_X = 30;
        
          class Pane {
            public:
              Pane();
              ~Pane();
                void size(int x, int y);
            private:
              static int ct;
              int x, y;
          };
        }
        
        //
        // implementation
        //
        int Window::Pane::ct = 0;
        
        Window::Pane::Pane() : x(0), y(0) { }
        Window::Pane::~Pane() { }
        Window::Pane::size(int x, int y) {
          if ( x < Window::MAX_X) {     // only qualify MAX_X with Window
                                        // as Pane already in scope
            Pane::x = x; // qualify, because function also declares x
            // ..
          }
        }
        
        // 
        // main
        //
        int main() {
          Window::Pane pane;
          pane.move(20, 20);
          pane.show();
        }
 
## Namespace alias

- Shorthand way to refer to a namespace.

        namespace the_software_company {
          int val = 10;
          // ..
        }
        
        //
        // without alias
        //
        the_software_company::val = 20;
        
        //
        // with alias
        //
        namespace TSC = the_software_company; // alias
        TSC::val = 20;
        
- Note, alias cannot collide with an existing name.
        
## `using`

### `using` directive

- Pulls the names from a named namespace and applies them to the current scope.
- Scope of using directive begins at its declaration and continues to the end of the current scope (can be used at any scope level).
            
        namespace Window {
          int val1 = 20;
          int val2 = 30;
        }
        // ..
        Window::val1 = 40;
        
        // using directive
        using namespace Window;
        val2 = 30;

- Note, variable names declared within a local scope hide any namespace names introduced in that scope (similar to local/global) variables even if you introduce a namespace after a local variable (the local variable will hide the namespace name).


        namespace Window {
          int val1 = 20;
          int val2 = 30;
        }
        //..
        void f() {
          int val2 = 10;
          using namespace Window;
          std::cout << val2 << std::endl; // output=10
        }
          

### `using` declaration

- Similar to a using directive except using declaration provides a finer level of scope (i.e. can be used to declare a specific name from a namespace to be used in the current scope).
- Once a name brought into scope, visible until the end of that scope (like any other declaration).
- A using declaration may be used in the global namespace or within any local scope.

        namespace Window {
          int val1 = 10;
          int val2 = 20;
        }
        //..
        using Window::val2;   // bring val2 into current scope
        Window::val1 = 10;    // val1 must still be qualified

- Note, it is an error to introduce a name into local scope where a namespace name has been declared (the reverse is also true).

        namespace Window {
          int val1 = 20;
          int val2 = 30;
        }
        ..
        void f() {
          int val2 = 10;
          using Window::val2; // ERROR, multiple declaration

### Directive Vs Declaration

- A using directive brings all names from a namespace into the current scope.
- It is preferable to use a declaration over a directive because the directive effectively defeats the purpose of the namespace mechanism. 
- i.e. A using declaration will not pollute the global namespace.

## Classes

- Put declaration into header file with same name as class file.
- Put class function definitions into `cpp` file.
- e.g. 

        class <className> {
          public:
            <className>(type1, ..); // constructor
            ~<className>(); // destructor
        
            int var1;
            int var2;
            void setVar1(int var); // public accessor method
        
          private:
            int pVar1;
            int pVar2;
        };
        
        // main
        int main() {
          <className> obj1;  // class definition
        
          obj1.var1 = 50;    // access class data member
          obj.setVar1(10);   // access class function

- e.g.

        // class declaration and definition
        #include <iostream.h>
        
        class Cat { // class declaration
        public:
          int GetAge();
          void SetAge(int age);
          void Meow();
        private:
          int itsAge; // member value
        };
        
        int Cat::GetAge() {
          return(itsAge);
        }
        
        void Cat::SetAge(int age) {
          itsAge = age;
        }
        
        void Cat::Meow() {
          std::cout << "Meow." << std::endl;
        }
        
        // main
        int main() {
          Cat frisky;
          frisky.SetAge(5);
          frisky.Meow();
          return(0);
        }


## Pointer's and Reference's

### Notes

- Place `*` and `&` with the type name, not the object name (Ref: Boost C++ Coding Guidelines)
         
        char* p = "flop";
        char& c = *p;

- NOT

        char *p = "flop";
        char const *extract( .. );

- Don't return a reference to a local object (local object will go out of scope, when function returns all locally scoped objects are automatically destroyed).

        const Rational& operator(const Rational& lhs, const Rational& rhs) {
          Rational result(10); // create object on the stack
          return(result); // object on the stack
        }

- Don't return a reference to an object created on the heap (causes memory leaks, references cannot be null).

        const Rational& operator*(const Rational& lhs, const Rational& rhs) {
          Rational* result = new Rational(10); // object on the heap
          return(*result);
        }

- It is possible to write functions that return object in such a way that compilers can eliminate the cost of temporaries (return constructor arguments instead of objects).
         
        const Rational operator*(const Rational& lhs, const Rational& rhs) {
          return Rational(10);
        }

        // main

        Rational a = 10;
        Rational b(1);
        Rational c = a * b // operator * called

        /* Notes:
         * - Still have to pay for construction/destruction of temporary objects created inside the 
         *   and the construction/destruction of the object the function returns.
         * - Only some compilers can optimised objects out of existence.
         * - In above example, compiler allowed to eliminate the temp object insider operator* and 
         *   and the temp object return by operator* i.e. RETURN VALUE OPTIMISATION (if the compiler 
         *   does this, the total cost of calling operator* is 0 i.e. only pay for 1 constructor call, the one to create "c"
         */
      
### Pointers

- Store address of variables.
- A pointer whose value is `0` is called a null pointer.
- All pointers should be initialised to something (use `0` if you don't want to initialise it).

#### Address Of Operator

- Returns the address of a variable (even if not pointer).
- To store addresses, use pointers.

        int* aPtr = 0;
        int howOld = 50;
        
        aPtr = &howOld;  // if "&" not used, compile time error

#### Indirection Operator/ Dereference Operator

- When pointer "dereferenced", the value at the address stored by the pointer is retrieved.
- Dereference operator used in two ways:
  - To declare a pointer.
  - To retrieve the value (dereference) of a pointer.


        int* aPtr = 0;      // pointer initialisation
        *aPtr = 10;         // set value for pointer

        int howOld = *aPtr; // retrieve value for pointer

- When pointer declared, can be assigned an address only (or initialised to `0`).

        int val = 10;
        int* aPtr = &val;
        
        int* aPtr2 = 10;  // ERROR, cant assign int (10) to a pointer
      
#### `this` pointer

- Points to the individual object.
- Does not have to be included when accessing parameters (i.e. hidden parameter).

        // explicitly using "this"
        //
        class Rectangle {
          Rectangle();
          ~Rectangle();
          void setLength(int length) { this-&gt;itsLength = length; }
          int getLength() { return(this-&gt;itsLength); }
        
        private:
          int itsLength;
          int itsWidth;
        }

#### Static Pointers ####

        // declaration
        static Point* instance;   // canit initialise static no-integral types in declaration
        
        // implementation
        *Point::instance = NULL;

#### Pointers and exceptions ####

- If code generates an exception, must delete any associated pointers.

        int main() {
          Point* p1 = 0;
          Point* p2 = 0;

          try {
            ...
            delete p1;
            delete p2;
          } catch ( exception &e ) {
            delete p1;
            delete p2;
          } 

### `auto_ptr` ###

- Part of STL.
- Acts like a pointer and sits on the stack when an exception is thrown.
- Class works by stashing away real pointer and deleting that pointer in its own destructor.

          #include <iostream>
          #include <memory>     // contains auto_ptr
          
          class MyException {
          public:
            char* msg() { return "Oops.."; }
          };
          
          class Point {
          public:
            Point(int x, int y) : _x(x), _y(y) { cout << "Point constructor.." << endl; }
            ~Point() { cout << "Point  destructor.." << endl; }
          
          private:
            int _x;
            int _y;
          };
          
          class Rectangle {
          public:
            Rectangle(Point upperleft, Point lowerright) : 
              _upperleft(new Point(upperleft)), 
              _lowerright(new Point(lowerright)) { }
            // see below for pass by reference semantics
            Rectangle(auto_ptr<Point> upperleft, auto_ptr<Point> lowerright) :
              _upperleft(new Point(upperleft)), 
              _lowerright(new Point(lowerright)) { }
          
              int width() { return _lowerright->x(); }
              int height() { return _upperleft->y(); }
          
              void dangerous() { throw MyException; }
          private:
            auto_ptr<Point> _upperleft;
            auto_ptr<Point> _lowerright;
          };
          
          int main() {
            try {
              auto_ptr<Point> ul(new Point(0, 0));
              auto_ptr<Point> ur(new Point(20, 30));
          
              Rectangle rect(ul, ur);
              rect.dangerous();
            } catch ( MyException &e ) {
              cout << "Caught exception " << e.msg() << "\n\n" << endl;
            }
          }

- Notes:
  - Destructors called properly without having to call them from main, either in `catch` statement or not.
  - The `auto_ptr` manages memory for you, just pass in a pointer to the object and the `auto_ptr` does the rest.
  - `auto_ptr` can be used more or less like normal pointers.

#### Copying an `auto_ptr`

- Two ways to cause a pointer to be copied.
  1. Invoke the copy constructor:

            Point* ptr = ptr2;

  2. Invoke the assignment operator:
            
            Point* ptr;
            ptr = ptr2;

- Three choices for copying:
  1. Shallow Copy
      - If the copy goes out of scope, it deletes the object pointed to and the other pointer will become a wild pointer.
  2. Deep Copy
      - Bring additional overhead of constructing and destroying every copy.
  3. Transfer Ownership
      - What `auto_ptr` uses.

- When a pointer assigned, STL implementation of `auto_ptr` transfers ownership.

        auto_ptr<Point> newptr = ptr;
        // ptr no longer owns the Point object, and the Point objects is not called
        // when ptr goes out of scope
        // ptr can be considered a pointer to null

- Therefore when you pass `auto_ptr` into a function and don't want to transfer ownership, pass by reference.
  - i.e. for the example above

              Rectangle(auto_ptr<Point> & upperleft, auto_ptr<Point> & lowerright):
                _upperleft(new Point(*upperleft)),
                _lowerright(new Point(*lowerright)) { }


  - i.e. no copy of pointers is made, and the ownership of the `auto_ptr` is not transferred.
  - i.e.

              _upperleft(new Point(*upperleft)
              // not explicit call to copy constructor, auto_ptr is passed in by reference
              // in initialisation, pointer dereferenced returning the pointed to object (the Point)
              // Point then used to initialise a new auto_ptr, not calling the copy constructor
              // but the constructor that takes a pointer to the Point object

### References

- Alias, initialised with the the name of another object.
- Can then use reference as alternate name for the target.

        int &ref = someInt; // ref is a reference to an integer that
                            // is initialised to refer to someInt

- To access value of reference, simply refer to the variable name.

        int &ref = someInt;
        std::cout << "Value=" << ref << std::endl;

- To access address of reference, use address of operator (but really accessing the address of the alias).

        int &ref = someInt;
        std::cout << "Address=" << &ref << std::endl;

- You cannot access the address of a reference itself as it is not meaningful.
- References are initialised when created and always act as a synonym for their target, even when the address of operator is applied.
- A reference CANNOT be null (program becomes invalid with a null reference).
- What can be referenced:
  - Any object (including user defined types) can be referenced.
  - Can create a reference to an object but not a class.

            // primitive types
            int& ref = int;    // ERROR
            
            int a = 200;
            int& ref = a;      // CORRECT
            
            // objects
            Cat& ref = Cat;    // ERROR
            
            Cat frisky;
            Cat& ref = frisky; // CORRECT

- References to objects used just like the object itself.

#### Constant References

- References themselves can never be reassigned to refer to another object so they are always constant.
- Therefore don't differentiate between "constant reference to a `SimpleCat` object" and "reference to a constant `SimpleCat` object".
- If the keyword const is applied to a reference, it is to make the object referred to constant.

        const SimpleCat& aFunction( const SimpleCat& theCat) {
          //..
        }

- A reference to a non-const cannot be initialised with a literal or temporary value.

        void swap ( T& a, T& b) {
          //..
        }

        double& d = 12.3;        // ERROR
        swap( std::string("Hello"), std::string(" World") ); // ERROR

- Caveat: A reference to a const can be initialised with a literal or temporary value.

        const double &cd = 12.3; // OK

        template <typename T> 
        //..
        T add(const T& a, const T& b) {
          return(a+b);
        }


        const std::string &greeting = add(std::string("hello"),  
                                          std::string("world")); // OK

- Ordinarily, temporaries are destroyed (go out of scope and have their destructors called) at the end of the expression in which they're created. 
- However, when such a temporary is used to initialise a reference to const, the temporary exists as long as the reference that refers to it exists. 
- This refers to the return object in the above example.

#### Reference Reassignment

- You must initialise all references.
- You cant reassign a reference.
- References are not reassigned in the normal way.

        int a;
        int& ref = a;   // ref alias for a
        
        
        a = 5;          // ref = 5
        
        int b = 8;
        ref = b;        // exactly the same as a = b
                        // i.e. ref not reassigned, the value it
                        // references to changes now ref = 8
        
#### Reference Scope

- A reference is always an alias to some other object.
- If you pass a reference into or out of a function, be sure to ask yourself "what is the object that I am aliasing and will it still exist every time it is used".

        class MyClass {
          ..
        };
        
        void someFunction();
        MyClass& workFunction();
        
        //
        // Using references
        //
        MyClass& workFunction() {
          MyClass mc(5);  // object created on stack, when function
                            // returns, object is out of scope!!
          return(mc);
        }
        
        void someFunction() {
          MyClass& rc = workFunction();
          ..
          }
        
          int main() {
            someFunction();
          }
        
        //
        // Could create the MyClass on the heap.
        //
        
          MyClass& workFunction() {
            MyClass* pc = new MyClass(5);
            return(*pc);
          }
        
          void someFunction() {
            MyClass& rc = workFunction();
            MyClass* pc = &rc;  // get a pointer to the memory
            delete(pc); // ERROR, rc is a reference to a null object
                        // which is not allowed!

### When to use references and pointers ###

- References cannot be reassigned therefore if you need to point to multiple objects, must use references.
- References cannot be `null`, so if there is any chance the object in question may be null, you must use pointers.
- e.g. `new`
  - If `new` cannot allocate memory on the free store, returns a `null` pointer.
  - Since a reference cannot be `null`, must not initialise a reference to this memory location until you've checked that it is not `null`.


## Memory

- There are 5 areas of memory:
    - Global Namespace - Holds global variables
    - Free Store (Heap) - User defined memory
    - Registers -
    - Code Space - Code
    - Stack - Stores local variables and function parameters (automatically cleaned).

### Free Store

- Memory in free store remains until you explicitly free it.
- To allocate use the `new` keyword followed by the "type" of object (so the compiler knows how much memory to allocate).

        unsigned short int* pPtr;
        pPtr = new int;

- Notes:
  - If `new` cannot allocate memory on the free store it returns null (therefore must check the pointer is not null every time you use `new`).
  - Every time there is a call to `new`, there should be a corresponding call to `delete` to free the memory on the free store (and to prevent memory leaks).
  - Calling `delete` on a pointer once free's up the memory, calling `delete` again on the same pointer will cause the program to crash. 
  - When you delete a pointer, set it to `0` (`null`) since calling `delete` on a `null` pointer is safe.
  - Objects on the free store work in the same way as primitive types, except that the constructor and destructor of the object is called on `new` and `delete` respectively.

### Memory Leaks

#### Dangling Pointers

- Delete a pointer and then try to use the pointer again without reassigning it.
- The pointer will still hold the memory location, but the compiler is free to put other memory there.
- To avoid, always set the the pointer to `0` (`null`).


## Functions

- A function consists of:
  - Declaration/Prototype 
    - Tells the compiler the name, return type and parameters. 
    - Must be before the definition.
    - Parameter names are optional (i.e. not used by the compiler, but should be included for readability).
  - Definition 
    - Tells the compiler how the function works.

### Declaring Function

- Declaration called "function prototype"
- 3 ways to declare functions:
  - Write prototype into header file and `#include` it.
  - Write prototype into file in which function used (after include statements but before main).
  - Define the function before it is called (not recommended).
- Syntax:

        <return_type> <function_name> ( [ <type> [ <name> ]], ..);

- Notes:
  - Function prototype and definition must agree about all parameters.
  - Function prototype does not need to contain names of parameters (used for readability).
  - Function prototype is a statement, therefore must end with a `;`.

### Defining Function

    <return_type> <function_name> ( [<type> <name>], ..) {
      // statements
    }

### Constant Member Functions

- When member function declared constant, compiler flags error any attempt by that function to change data for the object to which it belongs.

        void aFunction(short var1) const;

### Function Parameters

- Unless you specify otherwise, function parameters are initialised with copies of actual arguments pushed onto the stack (i.e. pass by value), and function callers get back a copy of the value returned by the function.
- Always pass by reference:
  - Limit constructor/destructor calls.
  - Avoids "slicing problem" i.e. when a derived class object is passed as a base class object, all the specialised features that make it behave like a derived class object are "sliced" off and you are left with a simple base class object.

- **If you know that an object will never be null, use a reference, else use a pointer (because references cannot be `null`).**

- If you pass a reference into or out of function, as yourself "What is the object I'm aliasing and will it still exist every time the object is used?"
  - Don't try to overcome this by creating an object on the heap (i.e. pointer). 
  - This wont work because you will not be able to delete the object (because you cant call delete on a reference).

- It is dangerous for 1 function to create memory and another to free it.
  - If writing a function that needs to create memory and then pass it back to the calling, consider changing the interface.
  - i.e. have the calling function allocate memory and then pass it into your function by reference. Moves all memory management out of your program and back to the function that is prepared to delete it.

- When to use pointers and when to use references:
  - References cannot be reassigned, therefore if you need to point to multiple objects, you must use pointers.
  - References cannot be null, so if there is any change that the object in question may be null, you must use pointers.


            // using pointers - pass addresses into function
            void swap(int* px, int* py) {
              temp = *px;
              *px = *py;
              *py = temp;
            }
            
            // calling function
            int x = 5, y = 10;
            swap(&x, &y);
            
            
            // using references - pass object into function
            void swap(int& rx, int& ry) {
              temp = rx;
              rx = ry;
              ry = temp;
            }
            
            // calling function
            int x = 5, y = 10;
            swap(x, y);

### Default Values

- Any function can take default values.
- Choosing between default values and overloaded functions. 
- Use overloading when:
  - There is no reasonable default value.
  - You need to use different algorithms.

          typedef unsigned short int USHORT;
          enum BOOL { TRUE, FALSE };
          //...
          void DrawShape(USHORT aWidth, USHORT aHeight, BOOL useCurrentVals=FALSE) {
            ..
          }
          
          
          // function can the be called using
          DrawShape(width, height);
          DrawShape(width, height, TRUE);

### Returning Class object by value

- It is possible to return a copy of a local object (i.e. in the below example the local object sum is still destroyed (as per stack based objects) and a copy is returned to the calling function).

        Matrix operator+ (const Matrix& m1, const Matrix& m2) {
          Matrix sum;
          //..
          return(sum);
        }

- This function is "generally" transformed into the following pseudo-code:

        void operator+( Matrix & _retvalue, const Matrix& m1, const Matrix& m2) {
          Matrix sum;
        
          // invoke the default constructor
          sum.Matrix::Matrix();
          // ..
          // copy construct sum into return value
          _retvalue.Matrix::Matrix(sum);
        }

### Function return values

- Never return a pointer/reference to a local stack object, a reference to a heap allocated object, or a pointer or reference to a local static object if there is a chance that more than one such object will be needed.

### Static member functions

- Two alternatives:
  - Normal Functions 
    - i.e. as a wrapper for static data. 
    - Then you must have an instance of the class to access the static data.
  - Static Member Functions 
    - Don't exist in the object, but in the scope of the class.

              class Cat {
                public:
                  Cat();
                  ~Cat(); 
                  static int getHowMany() { return(howManyCats); }
                private:
                  static int howManyCats;
              };
              
              int Cat::howManyCats = 0;
              
              int main() {
                std::cout << "there are" << cat::getHowMany();
                //..
              }

- Static member functions do not have a "this" pointer, therefore they cannot be declared constant.
- Also, because member data variables are access in member functions using "this", static member functions cannot access any non-static member variables.
- Static member functions can be called in 2 ways:
  - Calling them on an object of the class (as with other functions).

              int howMany = theCat->getHowMany();

  - Calling without object by fully qualifying the class and method name.
    
              int howMany = Cat::getHowMany();

## Exceptions

- Catching Exceptions:
  - Exception thrown, call stack examined.
    - Call Stack - List of function calls created when one part of the program invokes another function.
  - Exception passed up the call stack to each enclosing block.
    - As stack unwound, destructors for local objects on the stack are invoked and the objects (on the stack) are destroyed.
  - After each try block is one or more catch statements.
    - If the exception matches one of the catch statement, it is considered to be handled by having the statements executed.
    - If it doesn't match any, the unwinding of the stack continues.
  - If the exception reaches all the way to the beginning of the program (main) and is still not caught a built in handler is called that terminates the program.

- Notes:
  - After exception handled (catch) program continues after the try block of the "catch" statement that handled the exception.
  - When exception thrown, control transfers to the catch block immediately.
- e.g.
        class Array {
          public:
            //..
            int& operator[](int offset);
          private:
            int* pType;
            int size;
        
        
             // define exception classes
          class xBoundary() { };
          class xInvalid() { };
        };
        
        int& Array::operator[](int offset) {
          if ( offset < 0 && offset > size ) {
            throw(xBoundary());
          } 
        
          int i = pType[offset];
          if ( i > 500000 ) {
            throw(xInvalid());
          }
        
          return(i);
        }
        
        
        int main() {
          Array arr(20);
          try {
            for ( int i = 0; i < 100; i++ ) {
              arr[i] = i;
            }
          } catch ( Array::xBoundary ) {
            std::cout << "Error";
          } catch ( ... ) {
            // default catcher, catch everything
            //..
          }
        }

## Class Operations

### Initialisation Vs Assignment

- Assignment occurs when you assign.
- All other copying you run into is initialisation, including initialisation a declaration, function return, argument passing and catching exceptions.
- For built in types, the difference in operation is not so obvious.

        int a = 12;   // initialisation, copy 0x000c to a
        a = 12;       // assignment, copy 0x000c to a

- For user defined types, assignment is like destruction followed by a construction. 
- For a complex user defined type, the target (left side, or this) must be cleaned up before it is reinitialised with the source (right side, or str in the example below).

        class String {
          public:
            String(const char* init);
            //..
            String& operator=(const String& that);
            String& operator=(const char* str);
            //..
          private:
            char* s_;
          };
        
        String::String(const char* init) {
          if ( !init ) init = "";
          s_ = new char[(strlen(init)+1];
          strcpy(s_, init);
        }
        
        // assignment operator
        String& String::operator=( const char* str) {
          if ( !str ) str = "";
          char* tmp = strcpy(new char[strlen(str)+1, str);
          s_ = tmp;
          return(*this);
        }

### Assignment

- All assignment operators `+=, -=, *=, =` should return a reference to this.

        class Widget {
          public:
            Widget& oeprator=(const Widget& rhs) {
            // return type is a reference to the current
            // class
            //...
            return(*this);
            }
            Widget& operator+=(const Widget& rhs) {
              //..
              return(*this);
            }
          private:
          //..
        };
 
### Copy Construction Vs Copy Assignment

- Copy construction and copy assignment are different operations. 
Technically, they have nothing to do with each other (but semantically they should perform similar operations).

        class Handle {
          Handle(const Handle&);   // copy constructor
          Handle& operator=(const Handle&); // copy assignment
        };
        
        Handle T, a;
        T temp(a); // T's copy constructor
        a = b;     // T's copy assignment


### Copy Constructor

- Compiler provides default copy constructor.
- Copy constructor called every time a copy of an object is made e.g. when you pass an object by value, either into a function or as a function return value, a temporary object is made.
- All copy constructors take 1 parameter, a reference to an object of the same class (good idea to make it constant because the object wont be modified).
- Default copy constructor performs a member wise (shallow) copy:
  - Copes each member variable from the object passed in as a parameter to the member variables of the new object.
  - Fine for most member variables, breaks for member variables that are pointers to objects on the free store since it copies the exact values of one objects member variables into another object, therefore pointers in both objects end up pointing to the same memory (a problem if the original object goes out of scope since the destructor will free up the memory creating a stray pointer).
- For objects with pointers, must create your own copy constructor and perform a deep copy.

        class Cat {
          Cat();             // default constructor
          Cat(const Cat&);   // copy constructor
          ~Cat();            // destructor
        
        
          int getAge() const { return *itsAge; }
          int getWeight() const { return *itsWeight; }
          void setAge(int age) { itsAge  age; }
        
          private:
            int *itsAge;
            int *itsWeight;
        };
        
        
        Cat::Cat() {
          itsAge = new int;
          itsWeight = new int;
          *itsAge = 5;
          *itsWeight = 10;
        }
        
        Cat::Cat(const Cat& rhs) {
          itsAge = new int;
          itsWeight = new int;
          *itsAge = rhs.getAge();
          *itsWeight = rhs.getWeight();
        }
        
        // main
        Cat frisky;
        frisky.setAge(6);
        
        Cat boots(frisky);  // copy constructor called

#### Implementation

- Always declare the pair (copy construction and copy assignment).
- For a class X, the copy constructor should be declared:

        X(const X&)

- For a class X, the (copy) assignment operator should be declared:

        X& operator=(const X&)

- Standard Format:

        X& X::operator=(const X& that) {
            if ( this != &that ) {
                // do assignment
                ..
            }
            return(*this);
        }

- Note,  You must check for assignment to self, because if you don't, you may end up deleting a member pointer to the same data.

        class Handle {
          public:
            Handle(const Handle&); // copy constructor
            Handle& operator=(const Handle&); // copy assignment
            void swap(Handle&);
            //..
          private:
            Impl* impl_;
          };
        
        inline void Handle::swap(Handle &that) { 
          // only need to swap the pointer data
          std::swap(impl_, that.impl_);
        }
        
        // copy and swap semantics .
        //
        Handle& Handle::operator=(const Handle& that) { 
          Handle temp(that);  // take a copy of that (rhs) data
          swap(temp);         // swap *this's data with the copy
          return(*this);
        }
        
        //
        // main
        //
        
        Handle a = ..;
        Handle b;
        
        b = a // b.Handle::operator=(a)

### Class Creation

- If you declare an empty class, the compiler will declare its own versions of a copy, constructor, assignment operator, destructor, a constructor and a pair of address-of operators.
- i.e. if you create:

        class Empty { };

- its the same as if you'd have written:

        class Empty {
          public:
            Empty();                             // default constructor
            Empty(const Empty& rhs);             // copy constructor 
            
            ~Empty();                            // destructor
            
            Empty& operator=(const Empty& rhs);  // assignment operator
            Empty* operator&();                  // address-of operator
            const Empty* operator&() const;
        
- Note, these functions are generated only if they are needed, but it doesn't take much to need them.

        const Empty e1;          // default constructor
                                 // destructor
        Empty e2(e1);            // copy constructor
        e2 = e1;                 // assignment operator
        Empty* pe2 = &e2;        // address-of operator (non-const)
        const Empty* pe1 = &e1;  // address-of operator (const)

#### Destructor

- nonvirtual, unless its for a class inheriting from a bas class that itself declares a virtual destructor.

#### address-of operator 

- Default, return the address of the object.

        inline Empty* Empty::operator&() { return(this); }
        inline const Empty* Empty::operator&() const { return(this); }

#### copy constructor 

- Default performs memberwise copy construction (assignment) of the nonstatic data members of the class.

#### Disallow Default 

- To disallow functionality automatically provided by compilers, declare the corresponding member functions private and give no implementations.

        class HomeForSale {
          public:
            //..
          private:
            //..
            HomeForSale(const HomeForSale&);
            HomeForSale& operator=(const HomeForSale&);

### Constructors

- No default constructor, compiler automatically creates one that takes no parameters and does nothing.
- If you create a constructor, no default constructor is created.
- Constructors can be overloaded.
- Constructors invoked in 2 stages: initialisation and body
- Cleaner, more efficient to initialise member variables at the initialisation stage.
            
        class Rectangle {
          public:
            Rectangle();
            ~Rectangle();
          private:
            int itsWidth;
            int itsLength;
          };

        // implementation
        // Format: <variable>(<expression_to_init>)
        Rectangle::Rectangle() : itsWidth(5), itsLength(10) { }

### Destructors

- Destructors should never emit exceptions. 
- If functions called in a destructor may throw, the destructor should catch any exceptions, then swallow them or terminate the program.

### Operator Overloading

#### Binary Operators

- Can be defined by either a non-static member function taking one argument or a non-member function taking two arguments.
- For a binary operator `@`, `aa @ bb` can be either interpreted as:

        aa.operator@(bb) or operator@(aa, bb)

- e.g.

        class X {
          public: 
            void operator+(int);
            X(int);
        };

        void operator+(X, X);
        void operator+(X, double);

        void f(X a) {
          a + 1;   // a.operator+(1)
          1+a      // ::operator+(X(1), a)
          a+1.0;   // ::operator(a, 1.0);
            
#### Unary Operators

- Whether prefix or postfix, can be defined either by a non-static member function taking no arguments or a non-member function taking one argument.
- For a unary operator `@`, `aa@ `can be interpreted as either:

        aa.operator@(int) or operator@(aa, int)

- e.g.

        class X {
          // members with implicit "this" pointer
          X* operator&();    // prefix unary & (address of)
          X operator&(X);    // binary & (and)
          X operator++(int); //postfix increment
        };
        
        // non-member functions
        X operator-(X);        // prefix unary minus
        X operator-(X, X);     // binary minus
        X operator--(X&, int); // postfix decrement

- Notes:
  - An operator function intended to accept a basic type as its first operator cannot be a member function. 
  - e.g. adding a complex variable `aa` to the integer 2: 
    - aa+2 can, with suitably declared member function, be interpreted as aa.operator+(2), 
    - but 2+aa cannot because there is no class int for which to define + to mean 2.operator+(aa).

### Examples

#### Prefix Increment Function - Increment and then fetch

        class Counter {
          public:
            Counter();
            ~Counter();
            void operator++ () { ++val };
        
          private:
            int val;
        };
        
        int main() {
          Counter i;
          i++;
          //..
        }


#### Prefix Increment Function with a return type

        class Counter {
          public:
            Counter();
            ~Counter();
            Counter& operator++ ();
        
          private:
            int val;
        };
        
        Counter& Counter::operator++() {
          ++val;
          return(*this); // dereference the "this" pointer
                           // and return it as an alias
        }  
        
        int main() {
          Counter i;
          Counter a = ++i;
          //..
        }

#### Postfix Increment Function - Fetch and then increment

        class Counter {
          public:
            Counter();
            ~Counter();
                // postfix takes an int to identify it as postfix,
                // actual parameter ignored.
                //
            Counter operator++ (int); 
        
          private:
            int val;
        };
        
        Counter& Counter::operator++ (int) {
          Counter temp(*this);
          ++val;
          return(temp);
        }  
        
        int main() {
          Counter i;
          ++i;
          //..
        }

## Templates

- Used to parameterise 1 or more types/values. 
- i.e. make a list of any type of "thing" (where the type differs among objects).
- e.g. the array class allows you to create an array for integers, another for doubles etc
- Lets you declare a parameterised type, and then specify what type of object each instance of the array will hold.

        template <class T>   // declare template and specify the parameter
                            // that changes with each instance
        class Array {
          public:
            Array(); 
            //...
        };

        Array<int> anIntArary;   // declare "int" instance of the parameterised array
        Array<Cat> aCatArray;    // declare "Cat" instance of the parameterised array

### An example, a queue class 

        template <class Type> class Queue {
          public:
            Queue();
            ~Queue();
            Type& remove();
            void add(const Type&);
            bool is_empty();
            bool is_full();
          private:
          //..
        };

        Queue<int> qi;
        Queue< complex<double> > qc;
        Queue<string> qs;        

### Template Declaration

        template <csv_template_parameters>

#### Template Parameters

- Template parameter list of class template (enclosed in < and > tokens).
- Cannot be empty.
- Can be either:
  - type parameter 
    - Consist of keyword `class` or `typename` followed by an identifier.  
    - `class` / `typename` have the same meaning in the template parameter list. 
    - Indicates the parameter name that follows represent built in or user definition types. 
    - Once declared, serves as type specified for the remainder of the class template definition.

              template <typename T, U> class Collection;

  - non-type parameter 
    - Consists of ordinary parameter declaration. 
    - Represents a constant in the class template definition.

              template <class T, int size> class Buffer;

- Class definition/declaration follows the template parameter list (exactly the same as a non-template class)
- e.g.

        // Type indicate the type of data member item
        // Type will be substituted with various built-in and user 
        // defined types.
        // This process of type substitution is called template instantiation
        // Name of template parameter can be used after it has been declared 
        // until the end of the template.
        
        template <class Type> class QueueItem {
          public:
              ..
          private:
            Type item;   // Type represents the type of a data member
            QueueItem* next;
        };

- If variable with same name as template parameter is declared in global scope the name is hidden. Following example, `item` os not of type `double`, its type is that of the template parameter.
- e.g.

        typedef double Type;
        template <class Type> class queueItem {
          public:
            //..
          private:
            Type item; // item is not of type double
            QueueItem* next;
        };

## STL

- 3 types of components:
  - Containers 
    - Manage collections of objects 
    - e.g. array, linked list etc
  - Iterators 
    - Step through elements of a collection.
  - Algorithms 
    - Process elements of collections 
    - i.e. search, sort, modify etc

### Containers

- Two general kinds of containers:
  - Sequence Containers 
    - Ordered collections.
    - Position depends on insertion order, but independent of the value of the element.
  - Associative Containers 
    - Sorted collections.
    - Position of element depends on the value of a certain sorting criterion.

#### Sequence Containers

- Ordered collections independent of the value of an element.
- The following sequence containers are defined in the STL:
  - vector 
    - Dynamic array, random access, try to insert/remove from the end.
  - deque 
    - Double ended queue (can grow in both directions). 
    - Try to insert/remove at either end.
  - list 
    - Doubly linked list. 
    - random access. 
    - Insertion/removal fast at any position. 
    - Parsing takes linear time.

#### Associative Containers

- Sort elements automatically according to certain ordering criteria.
- This criteria takes the form of a function.
- By default, containers compare elements or keys with the operator `<`, although can supply your own comparison function.
- Associative containers are typically implemented as binary trees (every element has 1 parent and 2 children).The following associative containers are pre-defined in the STL:
  - Sets 
    - Collection in which elements sorted according to their own values. 
    - Duplicates are not allowed.
  - Multisets 
    - Same as "Set"'s except
    - Duplicates are allowed.
  - Maps 
    - Contains element that are in key/value pairs. 
    - Each element has a key that is the basis for the sorting criteria and a value. 
    - No duplicate keys allowed. 
    - A map can also be used as an associative array, which is an array that has an arbitrary index type.
  - Multimaps 
    - Same as a Map except duplicates are allowed. 
    - i.e. can be used as a dictionary.

- In addition to the fundamental container classes, STL provides pre-defined container adapters that meet special needs (implemented using the fundamental container classes). 
- These pre-defined container adapters include:
  - Stacks 
    - Uses the LIFO (Last In First Out) policy.
  - Queues 
    - Uses the FIFO (First In First Out) policy i.e. an ordinary buffer).
  - Priority Queues 
    - Container in which elements have different priorities. 
    - Priority is based on a sorting criterion that the programmer may provide (operator `<` used by default). 
    - In effect, a buffer in which the next element is the element that has the highest priority inside the queue. 
    - If >1 element's have the highest priority, the order of these elements are undefined.

### Iterators

- An object that can iterate over elements.
- These elements may be all or part of the elements of an STL container.
- An iterator represents a certain position in a container.
- The following fundamental operations define he behaviour of an iterator (Note, these operations have exactly the same interface as pointers, although the implementation details are different  e.g. smart pointers may be used).

#### `operator*`

- Returns the element in the actual position. 
- If the elements have members, can use `->` to directly access those members.

#### `operator++`

- Lets iterator step forward to the next element.

#### `operator-`

- Most iterators also allow stepping backwards to the previous element.

#### `operator==` and `operator!=`

- Returns whether 2 iterators represent the same position.

#### `operator=`

- Assign the iterator (the position of the element to which it refers).


