# COMPUTER SCIENCE
- null character value, represented as ASCII code point zero, bits will all be zero value

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

### BASE2 REPRESENTATION OF BASE10
- cant reprent base10 `0.1` in base2 in finite way, in binary it repeats forever: `0.00011001100110011...`
    - types like java `BigDecimal` can represent these values
- floating point in any laungage of `0.1` is not exactly `0.1`
- https://www.educative.io/answers/why-does-01-not-exist-in-floating-point


## NUMERIC REPRSENTATIONS
### TWOS COMPLEMENT
- unlike one's complement, there is only one representation for zero
- arithmetic implementations can use both signed and unsigned values
### IEEE754 FLOAT
- has 2 representations for zero

## MEMORY ALIGNMENT
- n-byte (where n is a power of 2) alignment means the address has a minimum of log2(n) least-significant zeros when represented in binary

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
    - basically says memory location(really cache location) can be in shared state or exclusive state
- compare_and_exchage atomic operation requires exclusive access to memory location
    - really x86 arch has compare and exchange/swap, on ARM you have LDREX and STREX (load exclusive and store exclusive)
    - on ARM compare_and_exchange implemented with loop of LDREX and STREX
- while a lock is held, it's nice to have memory location in shared state, versus exclusive (which is inefficient)
### ORDERING
- good quick blog post: https://fy.blackhats.net.au/blog/2019-07-16-cpu-atomics-and-orderings-explained/
- jon gjengset 3hr rust vid: https://www.youtube.com/watch?v=rMGWeSjctlY&t=5188s&ab_channel=JonGjengset

## COOL ALGOS
- jon carmack fast 1/sqrt(x) calc: https://www.youtube.com/watch?v=p8u_k2LIZyo&ab_channel=Nemean
- linus on clever remove from linkedlist with double pointer: https://github.com/mkirchner/linked-list-good-taste

## STORIES
- discord switch from golang->rust: https://discord.com/blog/why-discord-is-switching-from-go-to-rust
    - latency spikes due to GC pauses were a big issue
- whatsapp using erlang: https://thechipletter.substack.com/p/ericsson-to-whatsapp-the-story-of
