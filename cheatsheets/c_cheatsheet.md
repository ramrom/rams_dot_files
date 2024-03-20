# C
- linux torvalds on good C code with removing a node in linked list
    - https://github.com/mkirchner/linked-list-good-taste
- nice quick overview - https://www.w3schools.com/c/index.php

## HISTORY
- C99 standard - released 1999
    - IEEE 754 floating point support, `float` single precision (IEEE 32bit), `double` (64bit), `long double` (IEEE extended precision)
- C11 standard - releases 2011, replaced C99
    - multi-thread support - create/manage, mutexes, thread-specific storage, atomics
    - better unicode support

## COMPILER
- `restrict` keyword - https://en.wikipedia.org/wiki/Restrict - tell compiler pointer is only "owner", no other pointers to data

## SCOPE
```c
void foo() {
    int i = 1;
    { int p = 1; }   // code blocks are scoped, p will be dropped when scope ends
    p = 3;          // will fail
}
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
- `memcpy` - mem copy, copy raw bytes from one memory location to another regardless of types
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
        -  heap - `int *age = malloc(sizeof(int)); *age =3;`
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
- strings
    - C String - 1D array of chars terminated by a null character( `\0` )
        - array init: `char greeting[6] = {'H', 'e', 'l', 'l', 'o', '\0'};`
        - shortcut array init: `char greeting[6] = "hello";`
        - C lib get length - `strlen(greeting);`
- arrays - `int *myarr` is essentially equivalent to `int myarr[]`
    - under the hood passing around `a[]` is really just passing `*a`
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
    - static alloc - `int a[3][3];`
        - can initialize - `int A[3][3]={{1,2,3},{4,5,6},{7,8,9}};`
        - entirely occupies one contiguous area of memory, so for 3x3, `a[0][2]` is right before `a[1][0]` in memory location
    - dynamic alloc
        - `int *a = mallco(3 * 3 * sizeof(int));`
            - efficient, one `malloc` call, contiguous in memory
            - _but_ cant use `a[x][x]` indexing syntax, can do `a[i*M + j]`
        - `int **a; a = malloc(sizeof(int *) * N); for (i = 0; i < N; i++) { two_d_array[i] = malloc(sizeof(int) * M); }`
            - many mallocs, not contigous memory

## IO
- print int - `int v = 1; printf("%i\n",v);`
- print string - `char *s = "hi"; printf("%s\n",s);`

## LIBS
- `libc` - core lib - on many archs
    - API for most syscalls
    - memory management(`malloc`, `free`,etc)
    - also io, string, math
- `stdlib` 
    - memory allocation (`malloc`/`alloc`/`realloc`/`free`)
    - process control (`exit`, `getenv`, `system`)
    - conversions (ASCII(string)-to-int e.g. `atoi`)
- `stdio` - `printf`
