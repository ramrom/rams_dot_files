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
- SHARED MEMORY - 2 seperate processes sharing memory (e.g. for fast IPC) - https://en.wikipedia.org/wiki/Shared_memory
    - most OSes and langauges support this (e.g. python: https://docs.python.org/3/library/multiprocessing.shared_memory.html)
    - forking is a also common case, with copy-on-write parent and child share memory until a write
    - also shared dynamic libs - executables linking to same dynamic lib technically share the same memory


## CONCURRENCY
- wait queue - linux kernel uses these to manage threads that are waiting for a condition to happen
    - blocked or sleeping threads are tracked this way in kernel
    - process/thread woken on the wait queue woken up when event occurs
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
- FUTEX (Fast Userspace Mutex) - kernel sys call used to create a lock
    - a kernel space wait queue attached to atomic integer in userspace
    - thread/processes go on kernel wait queue based on userspace value checking of the atomic integer
    - linux kernel supports it since 2003 in ver 2.6.x, windows8 and winserver2012 with WaitOnAddress, openBSD in 2016
- https://en.wikipedia.org/wiki/Wait-for_graph - technique to prevent deadlocks
    - a entity tracks shared resources and what entities want/hold them
    - every entity checks the graph before trying to aquire resources, graph detects if entity's request would cause a deadlock
    - cycles or knots in the graph indicate if a deadlock could happen


## ATOMICS
- in multi-core/cpu systems atomics need to use MESI protocol to make guarantees when dealing with cache coherency
- CAS (compare and swap) atomic operation requires exclusive access to memory location
    - really x86 arch has compare and exchange/swap, on ARM you have LDREX and STREX (load exclusive and store exclusive)
    - on ARM compare_and_exchange implemented with loop of LDREX and STREX
- while a lock is held, it's nice to have memory location in shared state, versus exclusive (which is inefficient)
### ORDERING
- good quick blog post: https://fy.blackhats.net.au/blog/2019-07-16-cpu-atomics-and-orderings-explained/
- jon gjengset 3hr rust vid: https://www.youtube.com/watch?v=rMGWeSjctlY&t=5188s&ab_channel=JonGjengset
- memory barriers are instructions that cause the CPU and compiler to enforce ordering


## DATA STRUCTURES
### TREES
- trees are graphs where nodes have only one parent AND a root that has zero parents
    - this also implies there are no cycles
- k-ary -> node can have k branches/children
- BINARY TREE
    - complete - every level is full except maybe last one, and last level all must be left sided
        - b/c of these properties, particularly left sided compaction on last level, can be represented as an array
    - perfect - every level is full, perfect trees are always complete
    - full - every node has either 0 children or two
- BST - binary search tree, a binary tree but ordered
- B-TREE - stores sorted data, self-balancing
    - has order m, meaning a node can have up to m children, every node except for root and leaves must have at least m/2 children
        - BST is special case of B-Tree with 2 children
    - most common data struct used in database indexes
- RED-BLACK trees - stored ordered data, self-balancing
    - nodes have a color property, red or black, that help with balancing
    - red nodes can only have black children
- SPLAY trees
- TRIE - sometimes called a prefix tree
    - type of k-ary search tree, a tree data structure used for locating specific keys from within a set
    - each node stores one part of the key, a key is constructed from the sum of the parts from the root to it's leaf
    - one application is build entire dictionary of a language, e.g. english, to see if word is valid
        - could do a hash map, but trie tells you if a word is a prefix of another valid word quickly
### LINKED LISTS
- rust book - linked lists are generally dumb: https://rust-unofficial.github.io/too-many-lists/
- linked lists are slow, even insertion/deletion are slower than array! worse as N gets bigger
    - the linear search through linked list dominates slowness, and for array moving n/2 items is not that slow (caches good at this)
- see c++ founder - https://www.youtube.com/watch?v=YQs6IC-vgmo&ab_channel=AlessandroStamatto
### HEAP
- a tree data struct that fullfills the heap property
    - for a min heap, parent node value is less than it's child nodes values. for max heap it's greater than
- most often a binary tree, and a complete one
- can be constructed and stored in an array, usually an array is used b/c it's fast(no pointer follows to children)
    - parent and children indices are defined based on complete and left-filled leafs properties
- it is used to implement priority queues (often conflated with heaps)
- PERFORMANCE
    - deletion -> `O(1)` for removing root, then take right most leaf put it at root, and bubble down, `log(N)` worse case to bubble down
        - bubble: if larger(min heap) than either child, then swap with smaller of two children
    - insertion -> add node to last leaf, then bubble up until it's greater than parent(min heap), `log(N)` worst case bubble to root
    - removing top k items -> takes `Nlog(k)` time, better than `Nlog(N)` for full sort of data and then get top k
        - the next item is the root, which will have the highest or lowest value guaranteed by the heap structure
- heapsort uses a heap and runs in `O(Nlog(N))`
### BLOOM FILTERS
- probabilistic data struct that quickly and space efficiently finds if item is part of a set
- it is a fixed size but can represent a set with arbitrarily large number
- can return false positive not not false negative, i.e. "item maybe part of the set or definitely is not part of the set"
- adding element never fails, but the more you add the higher the false positive rate
- can't remove an element beause that might remove more elments that just that one b/c of how it's represented
- Count min sketch is a counting bloom filter - https://en.wikipedia.org/wiki/Count%E2%80%93min_sketch
    - uses sub-linear space, innaccurate due to collisions


## CACHE
- LRU cache is prolly most common, use a hash table whose values are nodes in a doubly linked list
    - head of linkedlist is most recent, and tail is least recent
- cache updating
    - write-through - write the data to the cache and main memory, wait for this to finish before program can continue
        - it's slow but simple, and no cache coherency issues, good when use case is few write operations
    - write-back(write-deferred) - update cache, dont immediately write to main memory, mark it dirty
        - when cache line set to be replaced/expire, write the data to main memory
    - write-around - write direclty to main memory and not touch the cache (used when data wont be used again)
- MESI protocol talks about low-level coordination, deals with cache coherency, supports write-back caches
    - MESI is acronym for 4 states: **M**odify **E**xclusive **S**hared **I**nvalid
        - Modify - data in cache line is modified and guaranteed to only be in this cache, main memory not updated
        - Exclusive - data is cache line is unmodified, and only in this cache
        - Shared - data in cache unmodified, but copies in other caches
        - Invalid - cache line has invalid data
    - each cache line has its own state machine, no global statemachine, cores coordiate via async message passing
    - if cache line is Modify or Exclusive thread can write to it with low overhead, and delay write-back to main memory
        - if 2nd cpu thread reads from a 1st cpu Exclusive cache, then 1st cpu must downgrade cache to Shared
        - if 2nd cpu thread reads a cache in Modify, Modified cache is written to main memory, and downgrade to Shared
    - if cache line is Shared, and thread writes to it, it is marked Modified, and other Shared lines are marked Invalid
#### DISTRIBUTED CACHE
- usually TCP/UDP used to talk to cache server/shards (b/c it's fast)
- usually use a client lib, it figures out which cache shard to hit
    - store all servers in sorted order, use binary search to find server
    - server discovery: 1. deploy-time file, 2. list in shared db that services call periodically to refresh
        - 3. use configuration service(e.g. aws zookeeper), cache shards send heartbeats to config server for health
            - services periodically talk to config service to udpate their server list
- which shard holds which keys
    - mod hashing - mod on hashkey is naive approach to determine cache shart to query (lots of misses when adding/removing shards)
    - consistent hashing is good algo, way fewer cache misses
        - disadvantages: the circle is not split evenly
        - disadvantage: domino effect, a server failure causes it's whole load to go to next shard, and that can snowball
        - simple mitigations: have a server appear multiple times on circle
        - good algos: jump hash by google in 2014, or yahoo video platform proportional hashing
- heirarchical cache strategy - service check a local cache (in-memory) before checking a distribted cache
    - often the cache client will implement the local cache
- cache server picking
    - client lib could do heavy lifting of maintaing list
    - proxy server, all client libs call proxy, and proxy figures out which cache shard to hit
    - client lib hits a random cache shard, and cache shard reroutes to proper shard, redis clusters do this


## SORTING
- bubble sort - O(n^2), really n^2 worst case (data in reverse sorted order)
- merge sort - divide and conquer, O(nlogn)
    - can be parralelized
    - generally not done in-place so lots of extra space, _can_ be done in-place, but is hard
- quick sort - divide and conquer, O(nlogn), in-place (no extra space), worst case O(n^2), most implementations not stable
- heap sort - uses a heap, O(nlogn), not stable, in-place, worst case O(nlogn)
### NON-COMPARISON
- bucket sort
    - 1.create array of "buckets" 2. put items in their buckets 3. sort each non-empty bucket 4. visit buckets and put them toegether
- radix sort (often conflated with bucket sort)

## PROGRAMMING LANGUAGES
- ML (meta language) - functional
- OCaml - dialect of ML
- VHDL

## TYPES
- covariance/contravariance/invariance - https://en.wikipedia.org/wiki/Covariance_and_contravariance_(computer_science)
    - how do subtyping relationship between simple types correspond to their complex types
    - if `Dog` is subtype of `Animal`, and `List(Dog)` is subtype of `List(Animal)` then List type is covariant
        - true for OCaml lists, and Rust array and slices
    - if `func(Animal)->nil` is subtype of `func(Dog)->nil` then this function subtype is contravariant
        - `func(func(Animal)->nil)` can be passed in where `func(func(Dog)->nil)` but not the other way around
        - this is try in Ocaml functions, and in Rust for `Fn(T)->()`
    - in rust variance mostly affects lifetimes - https://doc.rust-lang.org/reference/subtyping.html


## SOFTWARE PATTERNS
- iterative vs recursive
    - iterative is faster, no extra overhead for a function call
    - iterative uses less space, recursion adds stack frames for each function call
    - recursion will generally be fewer lines of code
- circuit-breaker - detect a recurrent failure and handle that failing element better
    - one general strategy is after some thresholds of failures stop attempting the expensive operation
- retry logic 
    - exponential back off - if we keep failing wait longer than the last time before trying
    - jitter - add random offset to retry so many entities retrying arent sync'd
- dependency injection - A class accepts the objects it requires from an injector instead of creating the objects directly
- RAII - resource acquisition is initialization - resources are tied to their objects and their lifetimes, released with the object death
- singleton - single global instance of class, class can have only one instance and has global scope
- observer pattern - registering many observers for state changes, state change notifies observers and their update logic is run
    - very similar to pub/sub in that it decouples 2 related entities, observer pattern is usually implemented intra-process
- strategy pattern - select the algorithm to use at runtime, code allows receiving a strategy/algo as a parameter/argument
- token bucket
    - sys design vid rate limiter - https://www.youtube.com/watch?v=FU4WlwfS3G0&ab_channel=SystemDesignInterview
    - a buffer/queue with some capacity, items are "leaked" at a fixed rate
    - if items are added faster than they are leaked, when capacity is reached, they are thrown away
    - common algo used for rate-limiting, it's a great way to see if traffic conforms to some average rate or exceeds it
    - used often in packet switched networks, ATM uses it
- leaky bucket
    - outputs requests at a fixed rate, smoothes out traffic, token bucket allows bursty traffic through and is more flexible
- thread pool - spawning threads is expensive, reuse the same ones
- object pool - dont alloc/dealloc all the time, reuse the same memory
    - same idea as thread pools and connection pools but for objects
- connection pool
    - creating/destroying a connection like TCP is expensive
    - create a pool of persistent connection that are reused, and a entity that manages the pool and takes requests

## FUNCTIONAL CONCEPTS
- pure function 
    1. a function that returns same values for same input values
    2. no side-effects, no mutation of local static or global variables, no I/O
- referential transparency - when replacing an expression with the concrete value yields the exact same behaviour for the program
    - not fullfilling this means the code/expression is referentially opaque
    - there is a fair amount of disagreement on the definition by experts
- eventual consistency - when a cluster eventually will all reach the same state
    - e.g. postgres replicas/followers are always behind to some degree, but will eventually get all the writes
- tunable consistency - e.g. cassandra offers this
- dead-letter queue - a store for when jobs cant be routed to their destinations

## PHILOSOPHIES AND DESIGN
- Moore's law - transistor count will double every 2 years
- Amdahl's law - total perf gained by optimizing one part of system limited by fraction of total time part is used
- [SOLID](https://en.wikipedia.org/wiki/SOLID)
    - SRP - single responsibility principle
    - interface segregation principle - Clients should not be forced to depend upon interfaces that they do not use
    - Liskov substitution principle 
        - Functions that use pointers/references to base classes must be able to use objects of derived classes without knowing it
    - open-closed principle - component should be open for extension, not modification
    - dependency inversion - depend on abstractions, not concretes
- REST - representational state transfer
- batch processing - generally non-real time, usually store data to persistent store, then can slowly process it background
- stream processing - real-time crunching of data, generally no persistent data store step as data is received
- MapReduce and hadoop
     - Map -> takes data and breaks it down into smaller key/value pairs(tuples)
     - Reduce -> takes tuples from map output and combines into smaller set of tuples
     - HDFS (hadoop distributed file system) - can store petabytes of data
### LAMBDA ARCHITECTURE
- uses stream processing and batch processing in parralel to ingest data
- data comming in is read-only and append only by timestamp
- batch layer aims at being very accurate, but is slow
    - Apache Hadoop was big original batch system, but others like Snowflake, Big Query, Redshift came along
- stream layer is real-time and fast but not accurate, doesnt process all the data
    - Apache Spark, Apache Storm, Kafka, Knesis
- serving layer - stores outputs from stream and batch layer for querying
- described by Nathan Marz in 2011, also introduced the CAP theorem
- CAP - Consistency Availability Partition-tolerance
    - C in CAP is different from C in ACID
    - in a partitioned distrubted system if a partition fails, you can either have consistency or availability
- Durability usually means does ur system preserve state/data when EVERYTHING fails (total power outage)
    - so often is your data backed up to persistent storage often
- backup 3-2-1 rule: at leaset 3 copies of data, on at least 2 different media types, and one in different location
- message queues (e.g. kafka, rabbitMQ)
    - comparison to service-to-service synchronous model:
        - advantage: can have many consumers receive same message, in p2p each "consumer" would have to be called by "producer"
        - advantage: can use fewer consumers to process same producer volume
        - advantage: lower latency, emitting event to queue is fast
        - advantage: more robust retry, consumer can reenqueue message if it failed

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
