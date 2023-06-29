# C

## MEMORY
- major types
    - static - initialized at program start, generally global scope, released when program ends
    - automatic - initialized at start of block of code, and automatically removed at end, generally stored on stack
    - dynamic - request to create memory and must request to deallocate memory (`malloc` and `free`) 
        - in other manual memory management langs like cpp you'd call `new` and destructor
        - in GC languages like java it's, the runtime GC does this
### DYNAMIC
- `malloc` - dynamic request (stored on the heap) contiguous amount of memory
    - null returned if cant allocate
    - void pointer if success (and should cast to typed pointer)
- `calloc` - like malloc, initializes memory to zero value
- `realloc` - change existing allocation, increase size, remain contiguous
- `free` - request to deallocate some memory
- heap vs stack for array
    - `int myarray[5]` -> automatic variable, on the stack

## LIBS
- `stdlib` 
    - memory allocation (`malloc`/`alloc`/`realloc`/`free`)
    - process control (`exit`, `getenv`, `system`)
    - conversions (string-to-int e.g. `atoi`)
- `stdio` - `printf`
