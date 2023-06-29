# C

## MEMORY
- `malloc` - dynamic request (stored on the heap) contiguous amount of memory
    - null returned if cant allocate
    - void pointer if success (and should cast to typed pointer)
- `calloc` - like malloc, initializes memory to zero value
- `realloc`
- `free` - request to deallocate some memory

## LIBS
- `stdlib` 
    - memory allocation (`malloc`/`alloc`/`realloc`/`free`)
    - process control (`exit`, `getenv`, `system`)
    - conversions (string-to-int e.g. `atoi`)
