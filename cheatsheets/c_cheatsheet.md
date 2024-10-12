# C
- linux torvalds on good C code with removing a node in linked list
    - https://github.com/mkirchner/linked-list-good-taste
- nice quick overview - https://www.w3schools.com/c/index.php

## HISTORY
- ANSI C99 standard - released 1999
    - IEEE 754 floating point support, `float` single precision (IEEE 32bit), `double` (64bit), `long double` (IEEE extended precision)
- ANSI C11 standard - releases 2011, replaced C99
    - multi-thread support - create/manage, mutexes, thread-specific storage, atomics
    - better unicode support

## COMPILER
- `restrict` keyword - https://en.wikipedia.org/wiki/Restrict - tell compiler pointer is only "owner", no other pointers to data
    - this is similar to how rust's main rule is to only have one owner per value

## SCOPE
```c
void foo() {
    int i = 1;
    { int p = 1; }   // code blocks are scoped, local varible p will be dropped when scope ends
    p = 3;          // will fail
}
```

## CONTROL STRUCTURES
- for small number of conditionals if/else-if/else logic is same speed as switch
- compiler in many cases will use jump tables for switch statements, if/else will always be compare and branch
    - jump tables are much faster than comparison but you dont see perf gains until the # of conditions is large

## TYPE SYSTEM
- pointers constants vs constant pointers
    ```c
    const int* ptr;         // the pointer ptr points to a constant value, so the value it points to can't change
    const int a = 10;
    const int* ptr = &a;  
    *ptr = 5;  // fails, value cant change
    ptr++;    // works, the pointer can point to something else

    int * const ptr;        // the pointer ptr is constant itself, so you cant change what the pointer points to
    int a = 10;
    int *const ptr = &a;
    *ptr = 5; // works, the value can change
    ptr++;    // fails, cant change what pointer points to
    ```
- has function pointers but not really first class functions
```c
#include <stdio.h>

int add(int a, int b) { return a + b; }
int subtract(int a, int b) { return a - b; }

int main() {
    int (*operation)(int, int);  // Function pointer declaration
    operation = add;
    printf("Result of addition: %d\n", operation(5, 3));
    operation = subtract;
    printf("Result of subtraction: %d\n", operation(5, 3));
    return 0;
}
```

## TYPES
### PRIMITVE TYPES
- byte, char - 8bits
- short, short int, signed short, signed short int - 16bits
- long - 32bits
- long long - 64bits
- float - 32bits, double - 64bits
### STRUCTS
- structs are pass by value, they get copied when passed into a function or assigned to a different var
```c
struct foo { int val; char name[10]; };
typedef struct foo foo;     // use typedef to declare foo as a formal type

struct foo g;       // no init, global/static-global/static-local/static-member, it's initialized to zero values

int main() {
    struct foo f;           // no initialization, in local scope will have garbage/random values
    struct foo f2 = { 3, "hi" }   // initialize with initializer list
    struct foo f3 = { .name = "hi", .val = 3 }   // initialize with designated initializer list, can be out of order
    struct foo f4 = f2;               // this makes a copy of struct f2

    foo f5; // because we typedef'd foo we dont need the struct keyword
}

// this will throw an error, as a recursive struct would be infinitely sized
typedef struct Recur {
    int val;
    Recur r;
} Recur;
```

## CONCEPTS
### NULL POINTER
- when a pointer is being compared to integer literal zero, `0`, compiler is checking if it's a null pointer
- `NULL` is a macro defined for human readability that represents null pointer
- a null pointers bit representation depends on the OS/architecture
    - bit representation for null pointer could be anything, e.g. `0xDEADBEEF`, compiler's job to know
    - i.e. it's not the same bit representation for the unsigned integer literal zero

## MEMORY MANAGEMENT
- stack is smaller than heap, and bytes constantly resused, thus almost always on CPU cache, making it fast
- `memcpy` - mem copy, copy bytes/char from one memory location to another
    - since byte/char is smallest unit of data to operate on, can copy any other type this way, usually using `sizeof(sometype)`
### MAJOR TYPES
- text - where the program itself is stored
- static - initialized at program start, released when program ends, global scope generally
    - compile time allocation, usually live in same memory where executable code lives
- automatic - initialized at start of block of code, and automatically removed at end
    - runtime allocation
    - all vars declared in a block are automatic
    - have local scope
    - stored on stack
        - in C can be static (lives lifetime of program, but scoped to local)
- dynamic - request to create memory and must request to deallocate memory (`malloc` and `free`) 
    - runtime allocation
    - stored on the heap, slower than stack b/c u have to follow a pointer to access i
    - in other manual memory management langs like cpp you'd call `new` and `delete`
    - in langs like java a GC does this for you
### DYNAMIC
- `malloc` - dynamic request (stored on the heap) contiguous amount of memory
    - rought algo:
        1. search process' assigned memory to find unused block
            - if satisfactory unused block found, mark it used and return it
        2. if unused memory to satify allocation cant be found a `sbrk`/`brk` (or newer `mmap`) syscall is made for more memory
            - `brk`/`sbrk` in kernel adjust `struct_mm_struct` for process in kernel, so process' data segment is larger
            - at first no physical memory assigned to this new virutal memory
        3. when process touches new virtual memory for first time, a fault handler kicks in, trap to kernel to assign physical memory
    - under the hood these call `mmap` and `mmunmap` system calls that manipulate virtual memory
    - null returned if cant allocate
    - void pointer if success (and should cast to typed pointer)
- `calloc` - like malloc, initializes memory to zero value
- `realloc` - change existing allocation, increase size, remain contiguous
- `free` - request to deallocate some memory, essentially updates the data struct that tracks used/free heap memory
    - generally freed memory will be in the "free list" and not given back to the OS, one reason is syscalls are expensive
- heap vs stack example allocs
    - array
        - `int myarray[5]` -> automatic variable, on the stack
        - `int * myarray = malloc(5 * sizeof(int));` -> dynamic variable, on the heap
    - int
        - stack - `int age = 30`
        - heap - `int *age = malloc(sizeof(int)); *age =3;`
    - struct
         `struct myStruct { int number; };`
        - heap 
            - `struct myStruct *struct1 = malloc(sizeof(struct myStruct)); struct1->number = 500;`
        - stack
            - `struct myStruct struct1; struct1.number = 1;`
- general stack size is platform dependent but like 2MB - 8MB
    - e.g. 2022 mbp `int foo[2000000]` was ok, but `int foo[2100000]` segfaulted
### ALIGNMENT AND PADDING
- generally the fields in a struct are stored in the same order in memory
- compiler will pad in order to ensure memory alignment in order to minimize memory accesses
    - e.g. `struct foo { char x; int i; }` 
        - for 32bit cpu, x is 1byte, i is 4bytes, no padding the int would span two 32bit words and cause 2 cpu cyles to fetch
        - compiler will prolly pad 3 bytes after char, so int i will be aligned with word boundary
        - `sizeof(foo)` will return 8
- minimize padding by choosing good field order
    - `struct bar { char x; int i; char y; }` - `sizeof(bar)` returns 12
        - b/c int is ordered after x, and must be aligned, we have more padding
    - `struct bar { char x; char y; int i; }` - `sizeof(bar)` returns 8
        - with this order the 2 chars can be put in the first word b/c getting each is still one word memory access
- sometime you want memory space efficiency
    - can force compiler not to padd by using `#pragma pack(1)` directive
    - can use `_attribute__((packed))`
    - can use `memset`

## DATA STRUCTURES
### STRINGS
- main lib `string.h`
- C String - 1D array of chars terminated by a null character( `\0` )
    - array init: `char greeting[6] = {'H', 'e', 'l', 'l', 'o', '\0'};`
    - shortcut array init: `char greeting[6] = "hello";`
    - C lib get length - `strlen(greeting);`
### ARRAYS 
- `int *myarr` is essentially equivalent to `int myarr[]`
- under the hood passing around `a[]` is really just passing `*a`
- arrays have a known size at compile time, e.g. `int arr[3]` is diff type than `int arr[4]`
    - thus an array type doesnt store metadata about it's size, b/c the size is known at compile time
    - `sizeof()` is not a real function call in runtime, it is replaced at compile time with the known size
- array passing to a function e.g. `void foo(int arr[1])`, (or `int *arr`), your really copying a pointer
    - thus funtion is still modifying the same underlying array data
    - to force pass by value semantics, declare wrapper struct for array, and pass that in func
        - e.g. `struct ArrWrap { int arr[1]; }; void foo(struct ArrWrap a) { ... }`
- array syntax does have some type checking
    ```c
    struct S;
    void foo(struct S *a); // OK
    void bar(struct S a[]); // ERROR
    ```
- multi-dimensional arrays
    ```c
    int abc[2][2] = { { 1, 2 }, { 3, 4 } }  /* Valid declaration, preferred*/
    int abc[2][2] = { 1, 2, 3 ,4 }  /* Valid declaration*/
    int abc[][2] = { 1, 2, 3 ,4 }  /* Valid declaration*/ 
    int abc[][] = { 1, 2, 3 ,4 }   /* Invalid declaration – you must specify second dimension*/
    int abc[2][] = { 1, 2, 3 ,4 } /* Invalid because of the same reason  mentioned above*/
    ```
- 2D array - `a[i][j]`
    - static(stack) alloc - `int a[3][3];`
        - can initialize - `int A[3][3]={{1,2,3},{4,5,6},{7,8,9}};`
        - entirely occupies one contiguous area of memory, so for 3x3, `a[0][2]` is right before `a[1][0]` in memory location
    - there is dynamic stack allocation in C99 - `void creatarr(int size) { int arr[size]; }`  , `arr` is dynamically size on stack
        - https://stackoverflow.com/questions/27859822/is-it-possible-to-have-stack-allocated-arrays-with-the-size-determined-at-runtim
        - it's apparently not a good idea for various reasons
    - dynamic(heap) alloc
        - `int *a = mallco(3 * 3 * sizeof(int));`
            - efficient, one `malloc` call, contiguous in memory
            - _but_ cant use `a[x][x]` indexing syntax, can do `a[i*M + j]`
        - `int **a; a = malloc(sizeof(int *) * N); for (i = 0; i < N; i++) { two_d_array[i] = malloc(sizeof(int) * M); }`
            - many mallocs, not contigous memory
- allocation
    - an array of structs will have a known size since structs have a known size
    - it will be allocated in one contguous virtual address space
    - if it's a small size the virtual address space will probably map to a contiguous physical address space
    - and generally the allocator will probably fit the address space to span as few page boundaries as possible

## CONCURRENCY
- main lib `threads.h`
- also `pthreads.h` - this is POSIX concurrency library (also has mutexes, condvars, rwlocks, spinlocks, barriers)
    - it's an iterface and how pthreads is implemented under the hood depends on platform
    - very portable b/c POSIX is a widely used standard on many platforms, see https://en.wikipedia.org/wiki/Pthreads
    - e.g. linux2.6, spawning a pthread is a NPTL, a 1x1, a pthread corresponds to a kernel thread
         - prior to 2.6 a pthread was implemented as a [LinuxThread](https://en.wikipedia.org/wiki/LinuxThreads)

## IO
- print int - `int v = 1; printf("%i\n",v);`
- print string - `char *s = "hi"; printf("%s\n",s);`

## LIBS
- APIs for library are declared in header files
### C STANDARD LIBRARY
- comparisons of diff version: https://www.etalabs.net/compare_libcs.html
- "C standard library" usually means some implementation of ANSI C Standard
    - see https://en.wikipedia.org/wiki/C_standard_library
    - C POSIX library is a superset of C standard library, where there is conflict C standard lib take precedence over POSIX
        - some new additions are `fctnl.h`(fd io),  `unist.d`(POSIX OS API, e.g. `fork`, `pipe`,`read`) and `pthreads.h`
    - API for most syscalls
    - memory management(`malloc`, `free`,etc), io, string, math, macros
- `libc` - name of c standard lib on many archs
- `glibc` - GNU libc, what linux uses
- `stdlib` - part of standard library
    - memory allocation (`malloc`/`alloc`/`realloc`/`free`)
    - process control (`exit`, `getenv`, `system`)
    - conversions (ASCII(string)-to-int e.g. `atoi`)
- `stdio` - part of standard library, funcs like `printf`
