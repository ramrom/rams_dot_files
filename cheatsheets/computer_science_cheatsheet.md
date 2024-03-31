# COMPUTER SCIENCE
- null character value, represented as ASCII code point zero, bits will all be zero value


## NUMERIC REPRESENTATIONS
### TWOS COMPLEMENT
- unlike one's complement, there is only one representation for zero
- arithmetic implementations can use both signed and unsigned values
### IEEE754 FLOAT
- has 2 representations for zero
### BASE2 REPRESENTATION OF BASE10
- cant reprent base10 `0.1` in base2 in finite way, in binary it repeats forever: `0.00011001100110011...`
    - types like java `BigDecimal` can represent these values
- floating point in any laungage of `0.1` is not exactly `0.1`
- https://www.educative.io/answers/why-does-01-not-exist-in-floating-point


## MEMORY
### PASS BY VALUE VS REFERENCE
- refers to the nature of variables
    - pass-by-value means value is pass to the function
    - pass-by-reference means the reference to the variable is passed to the function
- java is really pass by value, variables hold object "references"(really pointers), and _those_ are copied
```java
class Foo { int data; Dog(int i) { this.data = i;} }

public static void testmodify(Foo f) { f = Foo(2); }  // try to change the reference

public static void main(String[] args) {
    Foo bar = Foo(1);
    testmodify(bar);
    System.out.println(bar.data);       // this prints 1 in java, if java was pass-by-ref it would print 2
}
```
### MEMORY ALIGNMENT
- n-byte (where n is a power of 2) alignment means the address has a minimum of log2(n) least-significant zeros when represented in binary
### ALLOCATION
- arena(zone/area) allocation strategy
    - esentially allocating a very large contiguous chunk of heap memory and managing it yourself, then deallocating the entire thing
    - purported advantages are that many normal allocators (e.g. libc `malloc` and `free`) are slower and inefficient in some cases
    - an arena is very similar to stack allocation in this respect, except arenas can last longer than the stack frame


## CONCURRENCY
### PROCESSES VS THREADS
- both involve kernel intervention
- in process context switch (but not thread context switch)
    - virtual memory space is changed
    - cpu cache is flushed
    - TLB(translation lookaside buffer) is flushed
    - process control block is changed
### MUTEX
- mutexes are generally implement with atomics at the low-level in order to aquire locks
    - https://en.wikipedia.org/wiki/Read%E2%80%93modify%E2%80%93write
- spin locks implementation is where thread will loop constantly to check if lock is unlocked, a type of busy waiting


## ATOMICS
- MESI protocol talks about low-level coordination, deals with cache coherency, supports write-back caches
    - MESI is acronym for 4 states: **M**odify **E**xclusive **S**hared **I**nvalid
    - its a state machine for describing the memory and cache
    - each cache line has its own state machine, no global statemachine, cores coordiate via async message passing
    - basically says memory location(really cache location) can be in shared state or exclusive state
- compare_and_exchage atomic operation requires exclusive access to memory location
    - really x86 arch has compare and exchange/swap, on ARM you have LDREX and STREX (load exclusive and store exclusive)
    - on ARM compare_and_exchange implemented with loop of LDREX and STREX
- while a lock is held, it's nice to have memory location in shared state, versus exclusive (which is inefficient)
### ORDERING
- good quick blog post: https://fy.blackhats.net.au/blog/2019-07-16-cpu-atomics-and-orderings-explained/
- jon gjengset 3hr rust vid: https://www.youtube.com/watch?v=rMGWeSjctlY&t=5188s&ab_channel=JonGjengset


## DATA STRUCTURES
### TREES
- BST - binary search tree, a binary tree but ordered
- B-Tree - stores sorted data, self-balancing
    - has order m, meaning a node can have up to m children, every node except for root and leaves must have at least m/2 children
        - BST is special case of B-Tree with 2 children
    - most common data struct used in database indexes
- red-black trees - stored ordered data, self-balancing
    - nodes have a color property, red or black, that help with balancing
    - red nodes can only have black children
- splay trees
### LINKED LISTS
- rust book - linked lists are generally dumb: https://rust-unofficial.github.io/too-many-lists/
- linked lists are slow, even insertion/deletion are slower than array! worse as N gets bigger
    - the linear search through linked list dominates slowness, and for array moving n/2 items is not that slow (caches good at this)
- see c++ founder - https://www.youtube.com/watch?v=YQs6IC-vgmo&ab_channel=AlessandroStamatto
### BLOOM FILTERS
- probabilistic data struct that quickly and space efficiently finds if item is part of a set
- it is a fixed size but can represent a set with arbitrarily large number
- can return false positive not not false negative, i.e. "item maybe part of the set or definitely is not part of the set"
- adding element never fails, but the more you add the higher the false positive rate
- can't remove an element beause that might remove more elments that just that one b/c of how it's represented

## SORTING
- bubble sort - O(n^2), really n^2 worst case (data in reverse sorted order)
- merge sort - divide and conquer, O(nlogn)
    - can be parralelized
    - generally not done in-place so lots of extra space, _can_ be done in-place, but is hard
- quick sort - divide and conquer, O(nlogn), in-place (no extra space)

## PROGRAMMING LANGUAGES
- ML (meta language) - functional
- OCaml - dialect of ML
- VHDL

## SOFTWARE PATTERNS
- iterative vs recursive
    - iterative is faster, no extra overhead for a function call
    - iterative uses less space, recursion adds stack frames for each function call
    - recursion will generally be fewer lines of code
- circuit-breaker - detect a recurrent failure and handle that failing element better
    - one general strategy is after some thresholds of failures stop attempting the expensive operation
- dependency injection - A class accepts the objects it requires from an injector instead of creating the objects directly
- object pool - dont alloc/dealloc all the time, reuse the same memory
    - same idea as thread pools and connection pools but for objects
- RAII - resource acquisition is initialization - resources are tied to their objects and their lifetimes, released with the object death
- singleton - single global instance of class, class can have only one instance and has global scope
- observer pattern - registering many observers for state changes, state change notifies observers and their update logic is run
    - very similar to pub/sub in that it decouples 2 related entities, observer pattern is usually implemented intra-process

## FUNCTIONAL CONCEPTS
- pure function 
    1. a function that returns same values for same input values
    2. no side-effects, no mutation of local static or global variables, no I/O
- referential transparency - when replacing an expression with the concrete value yields the exact same behaviour for the program
    - not fullfilling this means the code/expression is referentially opaque
    - there is a fair amount of disagreement on the definition by experts

## PHILOSOPHIES AND DESIGN
- [SOLID](https://en.wikipedia.org/wiki/SOLID)
    - SRP - single responsibility principle
    - interface segregation principle - Clients should not be forced to depend upon interfaces that they do not use
    - Liskov substitution principle 
        - Functions that use pointers/references to base classes must be able to use objects of derived classes without knowing it
    - open-closed principle - component should be open for extension, not modification
    - dependency inversion - depend on abstractions, not concretes
- REST - representational state transfer

## LOGIC
- "switch" statements are usually compiled to lookup tables or hash lists in most languages
    - this are faster than a if/else-if/else equivalent, but practically only for large numbers of cases

## HARDWARE
- FPGA - field programmable gate arrays
    - can program/change the logic
        - LE(logic elements), a LE describes flip-flops(sequential logic), LUT(lookup table) for combinatorial logic
            - also describe memory storage and arithmetic
        - I/O blocks for interfacing with external devices
        - interconnects describle how LEs and I/O blocks are wired into a circuit
    - commonly write VHDL or verilogic HDL to program them
    - great for parrallel tasks, often used for DSPs, high performance compute, crypto
- ASIC - application specific integrated circuit
    - underlying logic gates are "hard-wired" and can't be changed, much faster than FPGA
    - very exspensive to design/test/validate b/c you are designing a new chip to fab
        - an programming error means u have to redesign and refab, versus FPGA u just re-program
    - bitcoins are usually mined with ASICs now, use way less power than FPGAs
- microcontroller
    - used for small embedded systems
    - geared to run a single task, each one has hardware that's far more specific
        - b/c they are specialized, they will consume less resources like battery power
    - often write the code with C, way easier than VHDL
- SoC - system on chip, not a well defined term, but generally always means more sophisticated than microcontroller
    - good rule is they can run a full OS on them

## COOL ALGOS
- jon carmack fast inverse square root `1/sqrt(x)` calc: https://www.youtube.com/watch?v=p8u_k2LIZyo&ab_channel=Nemean
- linus on clever remove from linkedlist with double pointer: https://github.com/mkirchner/linked-list-good-taste

## STORIES
- discord switch from golang->rust: https://discord.com/blog/why-discord-is-switching-from-go-to-rust
    - latency spikes due to GC pauses were a big issue
- whatsapp using erlang: https://thechipletter.substack.com/p/ericsson-to-whatsapp-the-story-of
