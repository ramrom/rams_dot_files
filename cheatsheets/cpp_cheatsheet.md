# CPP CHEATHSEET
- C++ invented by Bjarne Stroustrup in 1985
- main docs: https://en.cppreference.com/w/

## MEMORY
- allocations/frees mainly done with `new` and `delete`

## TYPE SYSTEM
- templates are really metaprogramming that enable generics

## FEATURES
- supports proper pass-by-reference semantics, using the `&` modifier on a parameter
- c11 to c14 - added shared pointers and unique pointers
- many say older versions b4 c14 were just bad
- JFS++ standard - strict subset used by aerospace/defense industry
    - removes majority of C++ features
    - JFS = joint strike fighter, the initial project JFS++ created for
    - some big rules are:
        - can't use exception handling, too risky to have unhandled exceptions, also costly/latency
        - can't use recursion, prevent stack overflow
        - can't alloc or de-alloc memory during program, prevent memory leaks and fragmentation
        - can't do multiple inheritence

## LIBRARIES
- [redpanda](https://redpanda.com/) - kafka-compatible streaming data platform that's faster
