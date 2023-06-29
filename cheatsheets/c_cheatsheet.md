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
## LIBS
- `stdlib` 
    - memory allocation (`malloc`/`alloc`/`realloc`/`free`)
    - process control (`exit`, `getenv`, `system`)
    - conversions (string-to-int e.g. `atoi`)
- `stdio` - `printf`
