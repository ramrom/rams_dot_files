# C

## MEMORY
- stack is smaller than heap, and bytes constantly resused, thus almost always on CPU cache, making it fast
### MAJOR TYPES
- static - initialized at program start, released when program ends, global scope generally
    - compile time allocation
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
    - under the hood these call `mmap` and `mmunmap` system calls that manipulate virtual memory
    - null returned if cant allocate
    - void pointer if success (and should cast to typed pointer)
- `calloc` - like malloc, initializes memory to zero value
- `realloc` - change existing allocation, increase size, remain contiguous
- `free` - request to deallocate some memory
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

## DATA STRUCTURES
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
        int abc[2][2] = {1, 2, 3 ,4 }  /* Valid declaration*/
        int abc[][2] = {1, 2, 3 ,4 }  /* Valid declaration*/ 
        int abc[][] = {1, 2, 3 ,4 }   /* Invalid declaration – you must specify second dimension*/
        int abc[2][] = {1, 2, 3 ,4 } /* Invalid because of the same reason  mentioned above*/
        ```

## IO
- print int - `int v = 1; printf("%i\n",v);`
- print string - `char *s = "hi"; printf("%s\n",s);`

## LIBS
- `stdlib` 
    - memory allocation (`malloc`/`alloc`/`realloc`/`free`)
    - process control (`exit`, `getenv`, `system`)
    - conversions (string-to-int e.g. `atoi`)
- `stdio` - `printf`
