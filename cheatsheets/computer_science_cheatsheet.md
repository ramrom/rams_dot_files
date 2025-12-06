# COMPUTER SCIENCE
- null character value, represented as ASCII code point zero, bits will all be zero value
- scalable vs elastic: scalable means it can handle greater capacity, elastic means it also dynamically adapts to current capacity
    - e.g. my systems can deploy 10x servers to handle 10x demand, but wont scale down, elasic would scale up/down to match load


## NUMERIC REPRESENTATIONS
### TWOS COMPLEMENT
- unlike one's complement, there is only one representation for zero
- first bit is sign bit (1 is negative, 0 is positive)
- arithmetic implementations can use both signed and unsigned values
- methods to negate:
    1. flip bits and add one, `0110` (6) -> `1001`(flip) -> `1010`(add one), we have -6
    2. right->left complementing each bit after first 1
### IEEE754 FLOAT
- has 2 representations for zero
### BASE2 REPRESENTATION OF BASE10
- cant reprent base10 `0.1` in base2 in finite way, in binary it repeats forever: `0.00011001100110011...`
    - types like java `BigDecimal` can represent these values
- floating point in any laungage of `0.1` is not exactly `0.1`
- https://www.educative.io/answers/why-does-01-not-exist-in-floating-point
- on using floats/double for currency: https://stackoverflow.com/questions/3730019/why-not-use-double-or-float-to-represent-currency


## MEMORY
- working set - amount of memory a process generally needs
    - often means the part of virtual memory that is in physical memory (versus paged to disk)
- MAU - minimally adressable unit
    - most platforms MAU is byte-addressing
- addressability - what is the size of the data that a address can point to
    - byte-addressing - each address points to a byte of data
    - word-addressing - each address points to a word of data, word size is platform dependent
- address space - a 32-bit systems can address 2^32 addresses
    - so if it's byte-addressable then a 32 bit system can address 4 GiB(gibibytes) of data
- dangling pointer - pointer pointing to memory that is invalid, e.g. memory was released or not owned by program
- `mmap` - C API but general idea of a system call in OSes that map files/devices directly into a processes virtual address space
    - allows process to access files as if they were regular memory, makes for efficient file IO
### PASS BY VALUE VS REFERENCE
- confusing and really not a good question or classification
- pass-by-refernce really means a language feature, very uncommon
- langs with pass-by-ref: visual basic `ByRef`, pascal `var`, C# `ref`, c++ reference parameter
- pass-by-reference in spirit is done by most languages with some indirection (pointers, "references", objects, arrays)
    - what this means is shared data, the caller can pass variable to reciever and receiver can modify it, caller sees changes
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
### ENDIANNESS
- the order in which data is trasmitted over a medium, particularly the bytes in a word
- little endian vs big endian - big endian means most significant byte of word stored at smallest memory address
    - digits/numbers in english are written big endian, most significant digits on left side
- network protocols inc modern internet related ones, are all big endian, often just called "network order"
- process/cpu architecture are generally little endian
### ALLOCATION
- ARENA(zone/area) allocation strategy
    - esentially allocating a very large contiguous chunk of heap memory and managing it yourself, then deallocating the entire thing
    - purported advantages are that many normal allocators (e.g. libc `malloc` and `free`) are slower and inefficient in some cases
    - an arena is very similar to stack allocation in this respect, except arenas can last longer than the stack frame
- SHARED MEMORY - 2 seperate processes sharing memory (e.g. for fast IPC) - https://en.wikipedia.org/wiki/Shared_memory
    - most OSes and langauges support this (e.g. python: https://docs.python.org/3/library/multiprocessing.shared_memory.html)
    - forking is a also common case, with copy-on-write parent and child share memory until a write
        - for linux `fork` only individual pages that are modified are copied-on-write
    - also shared dynamic libs - executables linking to same dynamic lib technically share the same memory
### GARBAGE COLLECTION
- generational
    - if objects survive GC cycle they get promoted to older generations
    - java, .NET, and others all employ the generational strategy
- Reference counting
    - have a count of refs for each object, when refs go to zero, deallocate object
- Tracing garbage collection
    - naive mark-and-sweep
         - mark phase that follows trees from root objects, and marks all reachable objects
         - sweep phase - scan all memory for each object, any object not marked is deallocated
         - drawback: GC cycle is long(stop-the-world), esp with large heap
    - tri-color mark-and-sweep
        - naive is stop-the-world in that entire program supsended for a GC cycle, can't modify working set
        - tri-color splits long cycle to smaller ones essentially
        - uses 3 colors: 
            - white - candidates for collection
            - black - reachable from root, have no refs to objects in white set, not candidates for collection
            - grey - reachable from root, not scanned for ref's to white objects yet


## CONCURRENCY
- 2015 good blog on async IO vs nonblocking IO and java - http://blog.omega-prime.co.uk/2015/09/03/asynchronous-and-non-blocking-io/
    - AIO(async IO) for OSX and linux really geared towards regular file IO, not sockets, b/c kqueue/epoll already are awesome
    - generally *nix AIO is not great, just use a dedicated thread pool and call blocking IO, for windows AIO is nice
- C10K problem - http://www.kegel.com/c10k.html
    - traditional thread/request model doesnt scale, 10000 threads will kill the best server
- 2016 - parking_lot lib - good article on mutexes/condvars https://webkit.org/blog/6161/locking-in-webkit/
    - inspired by futexes
- wait queue - linux kernel uses these to manage threads that are waiting for a condition to happen
    - blocked or sleeping threads are tracked this way in kernel
    - process/thread woken on the wait queue woken up when event occurs
- interesting blog on goto statements are bad: https://vorpus.org/blog/notes-on-structured-concurrency-or-go-statement-considered-harmful/
    - essentially need hierarcy in concurrent "threads", like actor model, he creates nursery lib for python
- arstechnica on hyperthreading - https://arstechnica.com/features/2002/10/hyperthreading/
### ASYNC
- quick blog on reactor/event-loop - https://guxi.me/posts/epoll-and-event-loop-just-enough-you-need-for-interview/
- linux epoll - https://jvns.ca/blog/2017/06/03/async-io-on-linux--select--poll--and-epoll/
- blocking vs non-blocking
    - best definition: waiting for something to become readable or writable
    - blocking generally means at thread level, blocking operations wont let thread do anything else until it's done
    - non-blocking means it yields and lets thread do other things if operation is blocked
- 2015 - nice blog on red/blue(sync/async) colored functions: https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/
    - golang is nice b/c no red/blue distinction, only one type and runtime handles it
- async regular file I/O
    - generally a regular file is always readable or writable and thus won't "block", unlike network socket IO
        - write call copies userspace buffer written to kernel buffer in call, kernel flushes later, so generally no block
            - maybe unless kernel buffer becomes full?
        - reading from disk is always available until it hits EOF, and can't really block
    - linux has bad support for it, but windows has good support for it
    - for linux many langs/frameworks use a pool of blocking threads for this I/O (e.g. rust tokio and GNU libc)
- STYLES
    - callbacks - get ugly arrowheaded programming, hard to read
    - `async`/`await` offers direct style programming, as opposed to callback-hell
### PROCESSES VS THREADS
- SO reply on process vs thread contex switch - https://stackoverflow.com/questions/7439608/steps-in-context-switching
- generally a process has many threads
- processes have thier own memory address space, threads of share the address space of other threads within their process
- both involve kernel intervention
- in process context switch (but not thread context switch)
    - virtual memory space is changed
    - cpu cache is flushed
    - TLB(translation lookaside buffer) is flushed
    - process control block is changed
- "kernel-thread" - confusing term but usually refers to a thread that only executes in the kernels context, no userland connection
- models
    - 1:1 - userland thread corresponds to one native thread
    - N:1 - many userland threads map to one native thread, and cant be moved to another native thread
    - M:N - many userland threads can be mapped to many native threads, userland scheduler is complex
### NON-NATIVE/NON-KERNEL THREAD
- GREEN THREAD - a "thread" managed by the userland process runtime, will run until preempted by the runtime scheduler
    - some definitions say managed by a "virtual machine", which is prolly much heavier than a runtime
    - really conflated or coined from java's green threads
- FIBERS - (term inspired from physical fibers that make up a physical thread)
    - cooperative multitasking, each fiber yields volutarily, then a scheduler then schedules next fiber to run
    - Fibers can implement coroutines by allowing each fiber to communicate to the scheduler which fiber should be run when it yields
- COROUTINE
    - cooperative multitasking, where pause/yields are specified by the programmer, no scheduler
    - used since 1958, defined by Knuth
        - generalization of subroutine, subroutine has beg and end, coroutines can be suspended in the middle and resume
        - most common definition/concept is: coroutine will yield and call another coroutine
    - coroutines can be used to implement fibers by always yielding to a scheduler coroutine
    - symmetric vs assymetric
        - symmetric coroutine often means coroutine can only yield to another coroutine
        - asymetric(or semicoroutine) - has a func to suspend/resume a coroutine, lua coroutines are an example of this
    - stackful vs stackless
        - stackful - uses an interface adapter on top of a threads stack, sometimes fibers are called this
        - stackless - compiler constructs a state machine data structure
- LIGHT-WEIGHT PROCESS
    - erlang is a popular example of using these, BEAM is the vm
    - often refers to userland threads associated with kernel-threads
### ACTOR MODEL
- erlang kind of invented the first version of the idea, modern examples are akka framework
- actor is a concurrent thing, generally operating as a userland "thread"
    - is **isolated**, can only talk to other actors via message passing to each actors mailbox
        - in erlang each actor has it's own head/stack/program-counter
- hierarchical, you have a parent/supervisor actor than manages it's child actors
    - supervisor responsible for handle a failed/erroring child actor
### CONDITIONAL VARIABLES
- conceptually a wait queue of threads, waiting for some event
- often waiting for a mutex to release, and notified/awakened when that happens
### MUTEX
- mutexes are generally implement with atomics at the low-level in order to aquire locks
    - https://en.wikipedia.org/wiki/Read%E2%80%93modify%E2%80%93write
- spin locks implementation is where thread will loop constantly to check if lock is unlocked, a type of busy waiting
- many mutex implementations will put a thread waiting for a lock to sleep
- read-share write-exclusive lock (often called RWLock) - multiple readers at one time or only one writer
    - "fair" RWLock, aka write-preferred lock, give preference to writer if a writer is waiting
        - one implementation is if writer is waiting, new readers are not allowed to aquire the lock and those readers wait
    - "unfair" RWLock, aka read-preferred lock, a waiting writer gets starved if tons of readers constantly aquiring the lock
#### FUTEX 
- Fast Userspace Mutex - kernel sys call used to create a lock - https://man7.org/linux/man-pages/man2/futex.2.html
- a kernel space wait queue attached to atomic integer in userspace
    - userspace allows process to avoid sys calls and is faster
- thread/processes go on kernel wait queue based on userspace value checking of the atomic integer
- linux kernel supports it since 2003 in ver 2.6.x, windows8 and winserver2012 with WaitOnAddress, openBSD in 2016
- often used to implement conditional variables
### BARRIERS
- a structure that lets multiple threads synchronize when they start or end
- e.g. [rust Barrier](https://doc.rust-lang.org/std/sync/struct.Barrier.html) or golang WaitGroups
### DEADLOCKS
- https://en.wikipedia.org/wiki/Wait-for_graph - technique to prevent deadlocks
    - a entity tracks shared resources and what entities want/hold them
    - every entity checks the graph before trying to aquire resources, graph detects if entity's request would cause a deadlock
    - cycles or knots in the graph indicate if a deadlock could happen


## ATOMICS
- use often for many non-blocking implementations of algorithms and data structures
- CAS (compare and swap) atomic operation requires exclusive access to memory location
    - really x86 arch has compare and exchange/swap, on ARM you have LDREX and STREX (load exclusive and store exclusive)
    - on ARM compare_and_exchange implemented with loop of LDREX and STREX
- memory ordering is usually tied to the use of atomics, as often times atomics aren't useful without instruction order gaurantees
- in multi-core/cpu systems atomics need to use MESI protocol to make guarantees when dealing with cache coherency
    - MESI is normally async (sync msgs sent later and other cores process messages later)
    - for various memory orderings(barriers) guarantees, MESI messages are sent/handled
- while a lock is held, it's nice to have memory location in shared state, versus exclusive (which is inefficient)
- most CPUs have built in instructions for doing fetch-add, fetch-sub, fetch-bitwise-and
### ORDERING
- good quick blog post: https://fy.blackhats.net.au/blog/2019-07-16-cpu-atomics-and-orderings-explained/
- jon gjengset 3hr rust vid: https://www.youtube.com/watch?v=rMGWeSjctlY&t=5188s&ab_channel=JonGjengset
- memory barriers are instructions that cause the CPU and compiler to enforce ordering


## DATA STRUCTURES
- nice complexity summary of data structs and algos: https://www.bigocheatsheet.com/
### STACK
- stack underlying data struct is almost always a simple array, but could also do linked list
- monotonic stack - items ordered in ascending or descending
### QUEUE
- queue underling data stuct is often a ring buffer, but could do linked list
### ASSOCIATIVE ARRAYS / MAPS
- **HASHMAP**
    - which use hash functions to find where a key goes
        - perfect hash function - injective function - maps a distinct set S to m integer with no collisions
            - used for lookup tables
            - basically needs knowledge of the set S in order to create a perfect hash function
    - https://en.wikipedia.org/wiki/Hash_table
    - two main collision resolution methods: chaining and open-addressing
    - CHAINING - create a linked-list or some collection to store all the colliding keys
        - each bucket is a linked-list
        - each bucket is a another hashmap (two-level hashmap)
    - OPEN-ADDRESSING - find a different location to store the key
        - probing is a very common open-addressing method
            - faster than chaining with low load factor: with no collision probe is 1 lookup, chain is 2 lookups
            - high load factor (> 0.8), chain is _much_ faster, tons of extra lookups b/c of constant collisions
                - typically 0.7-0.8 load factor is when back storage is resized/increased
                - want to avoid clustering and get even distribution
            - linear probing - each probe is 1 more
            - quadratic probing - each probe is n^2 (1,2,4...)
            - double hash - each probe intervals is computed by 2nd hash function
        - robinhood
- **TREEMAP** - store key/values in something like a binary search tree, when you want to access the keys in sorted order
    - insertion/deletion/lookup are all log(n) versus constant time for hashmap
    - java has TreeMap
### TREES
- trees are graphs where nodes have only one parent AND a root that has zero parents
    - this also implies there are no cycles
- k-ary -> node can have k branches/children
- BINARY TREE
    - complete - every level is full except maybe last one, and last level all must be left sided
        - b/c of these properties, particularly left sided compaction on last level, can be represented as an array
    - perfect - every level is full, perfect trees are always complete
    - full - every node has either 0 children or two
- QUADTREE
    - quadtree is a tree with exactly 4 children, often used to represent 2D structures
        - each 4 children represent one quadrant of 2D space
    - octtree - has 8 children, for 3D spaces, one for each of 8 quadrants
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
    - text editors using things like autocomplete search are much faster than hash tables or arrays
- QUADTREE - tree where each internal node has exactly 4 children
    - used to split a 2D square space into 4 pieces, good for indexing spatial data
    - fast location based insertion and seaches
- R-TREE - used for storing spatial data
    - R stands for rectangle, idea is to group things into minimum bounding rectangles and create B-Tree from it
    - common problem to solve: find all x within y distance of z
    - e.g. squares,polygons. but for any # of dimensions, so rectangular prisms(3D) and higher
### LINKED LISTS
- rust book - linked lists are generally dumb: https://rust-unofficial.github.io/too-many-lists/
- c++ founder says arrays better - https://www.youtube.com/watch?v=YQs6IC-vgmo&ab_channel=AlessandroStamatto
- linked lists are slow, even insertion/deletion are slower than array! worse as N gets bigger
    - the linear search through linked list dominates slowness, and for array moving n/2 items is not that slow (caches good at this)
- skip-list - multiple levels of linked lists that allow faster lookup of value versus linear search
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
- use a space of n bits and k hash functions, each item inserted we calculate k hash functions which sets k of n bits to 1
    - on a get for an item, if _any_ of they k bits are zero, its not present
    - if all are 1, then either it's in the set _or_ each one is a collision with some other item (false positive)
- can't remove an element - cant set the bit back to one b/c we dont know if other items have set this to one
- adding element never fails, every extra item means more collisions, and higher false positive rate
- COUNT MIN SKETCH - is a counting bloom filter - https://en.wikipedia.org/wiki/Count%E2%80%93min_sketch
    - instead of a bit(boolean), you have a integer counter
    - uses sub-linear space, innaccurate due to collisions
    - unlike boom filter can remove items, b/c u can decrement


## CACHE
- EVICTION POLICY - what to do when cache is full
    - TTL - time-to-live, evict when it expires
    - FIFO - evict based on order of insertion
    - LRU cache is prolly most common, use a hash table whose values are nodes in a doubly linked list
        - head of linkedlist is most recent, and tail is least recent
    - LFU - least frequently used, keep a count of hits for each cache entry
    - MRU - most recently used evicted first, good when oldest record is most accessed
        - good use case:  file is being repeatedly scanned in a looping sequential reference pattern
    - sliding-window
- INVALIDATION STRATEGIES
    - cahce-aside - app directly talks to cache and backing store
        - here we say data is "lazy loaded" into cache if not present
    - read-through - as opposed to cache-aside - app just talks to cache, and cache talks to backing store
    - write-through - write the data to the cache and backing storage, wait for this to finish before program can continue
        - it's slow but simple, and no cache coherency issues, good when use case is few write operations
    - write-back - update cache only, write to backing store done later
        - when cache line set to be replaced/expire, write the data to backing storage, often called lazy write
            - or periodically write-backed entries are written to backing store
        - this is much more complex to implement than write-through
        - in a distributed cache scenario, more dangerous as if cache goes down you lose more data
    - write-dirty - update backing storage, mark cache dirty
    - write-around - if cache miss for a write, write direclty to backing storage and skip cache
        - this is good when we dont expect subsequent reads
- MESI protocol talks about low-level coordination, deals with cache coherency, supports write-back caches
    - MESI is acronym for 4 states: **M**odify **E**xclusive **S**hared **I**nvalid
        - Modify - data in cache line is modified and guaranteed to only be in this cache, main memory not updated
        - Exclusive - data in cache line is unmodified, and only in this cache
        - Shared - data in cache unmodified, but copies in other caches
        - Invalid - cache line has invalid data
    - each cache line has its own state machine, no global statemachine, cores coordiate via async message passing
    - if cache line is Modify or Exclusive thread can write to it with low overhead, and delay write-back to main memory
        - if 2nd cpu thread reads from a 1st cpu Exclusive cache, then 1st cpu must downgrade cache to Shared
        - if 2nd cpu thread reads a cache in Modify, Modified cache is written to main memory, and downgrade to Shared
    - if cache line is Shared, and thread writes to it, it is marked Modified, and other Shared lines are marked Invalid
- Thrashing - when you never get a cache hit, constantly going to backing storage
    - in this case cache is counterproductive and makes system slower
- [redis](datastore_cheatsheet.md) and memcached are popular in-memory servers used for caching
#### DISTRIBUTED CACHE
- clustering: use replicas for HA and better read performance, sharding for more space and better write performance
- usually TCP/UDP used to talk to cache server/shards (b/c it's fast)
- cache server picking
    - client lib could do heavy lifting of maintaing list
    - proxy server, all client libs call proxy, and proxy figures out which cache shard to hit
    - client lib hits a random cache shard, and cache shard reroutes to proper shard, redis clusters do this
- usually use a client lib, it figures out which cache shard to hit
    - store all servers in sorted order, use binary search to find server
    - server discovery: 1. deploy-time file, 2. list in shared db that services call periodically to refresh
        - 3. use configuration service(e.g. aws zookeeper), cache shards send heartbeats to config server for health
            - services periodically talk to config service to udpate their server list
- which shard holds which keys
    - mod hashing - mod on hashkey is naive approach to determine cache shart to query (lots of misses when adding/removing shards)
    - consistent hashing is good algo, way fewer cache misses
- heirarchical cache strategy - service check a local cache (in-memory) before checking a distribted cache
    - often the cache client will implement the local cache


## LOAD BALANCING
- layer type
    - layer 3(network)
    - layer 4(TCP/UDP)
    - layer 7(e.g. HTTP)
- balancing strategies
    - round robin - easiest/simplest to implement, hit each one in order
        - DNS based strategy: a DNS entry can have many A records, and will round-robin each of those A records
    - rule-based: e.g. by node latency, node volume, node reliability, fewest acive connections, least bandwidth
        - can't use DNS method for this, need a server
    - consistent hashing - nice if you want to maintain each client going to the same node
- sofware vs hardware
    - software: AWS ELB(NLB/ALB), HAProxy, nginx, traefik
    - hardware: F5, cisco, barracuda, citrix
- HA/redundancy
    - active-active - multiple instances balancing traffic, heartbeats b/w them to stay informed of state
    - active-passive - passives dont serve traffic, just wait for active to die and them they promote
### FACEBOOK TRAFFIC LOAD BALANCING
- facebook load balancing (2016) - https://www.youtube.com/watch?v=LLBT70yexZo&ab_channel=USENIX
- user -> L3-ecmp(equal-cost-multipath) -> L4LB(ipvs) -> L7LB(proxygen) -> HHVM(hiphop vm that serves FE tasks)
    - L7lb does tls/ssl termination
    - L3->L4 and L4->L7 use consistent hashing(on socket 4tuple) to L7LB, must maintain same target to maintain TCP connections
        - ipvs = IP virtual server
        - if l4lb dies, the l4lb that takes the failover traffic uses same consistent hashing algo to send to same l7lb
        - if l7lb dies, tcp conn def breaks, l4lb consistenly hashes to new l7lb, remembers in it's local state if old l7 comes back
- one cluster: ~10s of L4 lb, ~100s of L7 lbs, ~1000s of HHVMs
    - final layer doesn't have to be HHVM, this is biz logic layer, could be dbs or some other backend service
    - all components(not l3 router) run on commodity x86 hosts/VMs with k8s/docker type system to deploy onto
- L3-ecmp advertises BGP routes to l4LB(yea they're not l3 routers) and l4LBs respond with VIP
- use service discovery(based on zookeeper) to keep track of l7LBs for l4LBs
- multiple clusters are a datacenter
- edge POPs - handle just TCP and TLS termination, no HHVM(or core stuff), nice compromise 
    - as fewer datacenters for HTTP/core stuff, but much lower response times (tcp + tls handshake are fast)
- Cartographer (DNS LB) - system that configures dns servers so optimal POP server is selected for that region
    - gets real-time data from POPs and data centers globally
    - Sonar - a system measure closesness to POP based on network address, test by sending pics and measuring route/time
    - also measure data center health and capacity(total rps, cpu util, network util, etc)
    - updates on a one-two minute cycle, then DNS maps are torrented to thousands of DNS servers


## ALGORITHMS
### TOKEN BUCKET
- sys design vid rate limiter - https://www.youtube.com/watch?v=FU4WlwfS3G0&ab_channel=SystemDesignInterview
- a buffer/queue with some capacity, items are "leaked" at a fixed rate
- if items are added faster than they are leaked, when capacity is reached, they are thrown away
- common algo used for rate-limiting, it's a great way to see if traffic conforms to some average rate or exceeds it
- used often in packet switched networks, ATM uses it
### LEAKY BUCKET
- outputs requests at a fixed rate, smoothes out traffic
    - token bucket allows bursty traffic
- generally handled at packet level, where packets are added to a queue on input, and emitted at a constant rate on other side
### BINARY SEARCH
- for non-exact closest match great or less
    - https://stackoverflow.com/questions/50692011/find-the-first-element-in-a-sorted-array-that-is-smaller-than-the-target
### CONSISTENT HASHING
- basic approach: split a space conceptually into a ring of N slots
    - hash the key and then mod by space size: `K = h(key) % N`
    - hash all the server IDs and mod by space size `S = h(serverID) % N`
    - then going clockwise, the first server slot you find is the server that handles the keys request
- issue: the circle is not split evenly b/w servers, so some take more load than other
    - solution: have a server appear multiple times on circle (virtual servers)
        - create multiple hash functions, one hash func for each new set of virtual servers
- bigger issue: domino effect, a server failure causes it's whole load to go to next shard, and that can snowball
- good algos: jump hash by google in 2014, or yahoo video platform proportional hashing
### SORTING ALGORITHMS
- bubble sort - O(n^2), really n^2 worst case (data in reverse sorted order)
- merge sort - divide and conquer, O(nlogn)
    - can be parralelized, worse and average is o(nlogn)
    - generally not done in-place so lots of extra space, _can_ be done in-place, but is hard
- quick sort - divide and conquer, O(nlogn), in-place (no extra space), worst case O(n^2), most implementations not stable
- heap sort - uses a heap, O(nlogn), not stable, in-place, worst case O(nlogn)
- quickselect - find the kth smallest element in an unordered list, also called Haore's selection algorithm
    - related to quicksort, done in-place
### NON-COMPARISON SORTING ALGORITHMS
- counting sort - sort by counting each value, with the value being the index in an array
    - this depends on a dataset of small positive integers
- bucket sort
    - 1.create array of "buckets" 2. put items in their buckets 3. sort each non-empty bucket 4. visit buckets and put them toegether
- radix sort (often conflated with bucket sort)


## SOFTWARE PATTERNS
- event-driven
    - martin fowler 2017 - https://martinfowler.com/articles/201701-event-driven.html
    - martin fowler 2005 event sourcing - https://martinfowler.com/eaaDev/EventSourcing.html
- iterative v and tracker-blockerss recursive
    - iterative is faster, no extra overhead for a function call
    - iterative uses less space, recursion adds stack frames for each function call
    - recursion will generally be fewer lines of code
- circuit-breaker - detect a recurrent failure and handle that failing element better
    - one general strategy is after some thresholds of failures stop attempting the expensive operation
- retry logic 
    - exponential back off - if we keep failing wait longer than the last time before trying
    - jitter - add random offset to retry so many entities retrying arent sync'd
- gang of four design patterns - https://en.wikipedia.org/wiki/Design_Patterns
- visitor pattern - seperate object from algorithm
    - a seperate algo/code handles the diff types of objects, versus each object type knowing how to handle itself
- composition - seperate types/classes for different behaviors, then compose them together in a new class
    - versus pure inherience approach where they are all related in the same inheritence tree
- dependency injection - A class accepts the objects it requires from an injector instead of creating the objects itself internally
- composition vs dependency injection
    - seem like very similar ideaas, but dependency injection is more decoupled
    - good SO example: https://stackoverflow.com/questions/21022012/difference-between-dependency-and-composition
        - `Address` is injected(it's **outside**) into `Employee`, user could inject a diff `Address` type, has access to it's API still
        - `Car` **internally** instantiates an `Engine` type, and is composed of it
            - in non-composition, functionality of `Engine` might be part of `Car` code or `Car` superclass code
            - it's not DI b/c we can't choose what `Engine` type to inject or access it's API
- decorator pattern - add functionality without modifying underlying type without changing type
    - really for classes, so don't create child class, but add a wrapper class for the target class
- adapter pattern - creating bridge code to combine two incompatible interfaces
    - e.g create class that implements old interface but it's implementation of old interface calls new interface under the hood
- RAII - resource acquisition is initialization - resources are tied to their objects and their lifetimes, released with the object death
- singleton - single global instance of class, class can have only one instance and has global scope
- observer pattern - registering many observers for state changes, state change notifies observers and their update logic is run
    - very similar to pub/sub in that it decouples 2 related entities, observer pattern is usually implemented intra-process
- strategy pattern - select the algorithm to use at runtime, code allows receiving a strategy/algo as a parameter/argument
- pooling
    - thread pool - spawning threads is expensive, reuse the same ones
    - object pool - dont alloc/dealloc all the time, reuse the same memory
        - same idea as thread pools and connection pools but for objects
    - connection pool
        - creating/destroying a connection like TCP is expensive
        - create a pool of persistent connection that are reused, and a entity that manages the pool and takes requests
- Dynamic programming - solving a problem iteratively or breaking it down into subproblems
    - often use memoization to store the solution of a subproblem
- Memoization - remembering/caching the output of a previous computation

## AI
see [ai cheat](artificial_intelligence_ai_cheatsheet.md)

## PROGRAMMING LANGUAGES
- fast cheatsheets for any PL: https://learnxinyminutes.com/
- not so bad even faster cheats on PLs: https://devhints.io/
- FORTRAN - old and math focused
- COBOL - invented in 1959, dominated in 1970
    - designed for large amounts of data, read like plain english so non-experts could learn (versus assembly)
    - tons of core systems: finance/banking, insurance(healthcare particularly), etc. use it today
        - 2024: 95% ATM machines, 43% banking systems, 80% in-person transactions, 60% healthcare records/dbs use COBOL
- ML (meta language) - functional
- OCaml - dialect of ML
- VHDL - VLSI(very large scale IC) Hardware Description Language
- Swift - created by Christopher Arthur Lattner, he convinced apple to convert from objectiveC over the course of 10 years
- LLVM/CLang - also created by Lattner
- Mojo - created by Lattner, to be a python successor, speed of C + expressiveness of python
- [Golang](https://go.dev/) - static, memory managed, fast and easy to learn, invented at google
- [Nim](https://nim-lang.org/) - static typed, system language, inspired from python, ada, modula
- [Rust](https://www.rust-lang.org/) - static, systems language, memory safe and fast
- [Zig](https://ziglang.org/) - speed of C but with modern nicities, allocators are first class, no macros but has comptime
    - compatible with C ABI, zig can directly compile C code
- [Carbon](https://github.com/carbon-language/carbon-lang) - tries to be a better c++, google invented
- [Erlang](https://www.erlang.org/) - uses BEAM, invented actor model
- Elixir - a new dialtect of Erlang, uses BEAM
- Gleam - even newer Erlang dialect, uses BEAM

## TYPES
- covariance/contravariance/invariance - https://en.wikipedia.org/wiki/Covariance_and_contravariance_(computer_science)
    - how do subtyping relationship between simple types correspond to their complex types
    - if `Dog` is subtype of `Animal`, and `List(Dog)` is subtype of `List(Animal)` then List type is covariant
        - true for OCaml lists, and Rust array and slices
    - if `func(Animal)->nil` is subtype of `func(Dog)->nil` then this function subtype is contravariant
        - `func(func(Animal)->nil)` can be passed in where `func(func(Dog)->nil)` but not the other way around
        - this is try in Ocaml functions, and in Rust for `Fn(T)->()`
    - in rust variance mostly affects lifetimes - https://doc.rust-lang.org/reference/subtyping.html
- generics - aka parametric programming - language that support abstracting a type a function/class/struct can take
- ADT - algebraic data types, [see functional programming section](#functional-programming)
- higher kinded types - [see functional programming section](#functional-programming)


## FUNCTIONAL PROGRAMMING
- decent vids on FP
    - https://learn.microsoft.com/en-us/shows/c9-lectures-erik-meijer-functional-programming-fundamentals/lecture-series-erik-meijer-functional-programming-fundamentals-chapter-1
- pure function 
    1. a function that returns same values for same input values
    2. no side-effects, no mutation of local static or global variables, no I/O
- referential transparency - when replacing an expression with the concrete value yields the exact same behaviour for the program
    - not fullfilling this means the code/expression is referentially opaque
    - there is a fair amount of disagreement on the definition by experts
- typeclasses - invented by haskell, essentially ad-hoc polymorphism
- core concept: dont mutate values, logic is an expression of many combined functions
    - data structures are copied, never mutated, or new data structures are created
    - versus imperative programming where you have objects and make statements that mutate
- mark waks: if you squint a little, monads are an abstraction of sequential behavior, applicatives of parallel behavior.
    - (And in practice, that's generally what they mean in code.)
### ALGEBRAIC DATA TYPES
- in type theory, it classifies composite types (types made of other types)
- main high level categories are sum and product types, and the names come from how we count the total values they can have
- SUM TYPE - total values that can be represented are the sum of the component types
    - e.g. tagged unions, enums
    - take enum { x: boolean, y: char }, char(ASCII) has 256 values, boolean has 2, total # of diff values for enum is sum: 2 + 256
- PRODUCT TYPE - total values that can be represented are the product of the component types
    - e.g. struct, records, tuples
    - take the tuple type: (char, bool, uint16) - char(ASCII) can have 256 values, bool 2, uint16 2^16
        - so the total # of diff values tuple can have is the product of the three: 256 * 2 * 2^16
### ALGEBRAIC DATA STRUCTURES
- kinda describe software patterns, but have formal mathematical definitions
- e.g. like Functor(has `map` which preserves outer functor type), Monoid, Monad, Applicative
- Functor -> unit(wraps a type) + map(apply func over inner type A -> B)
- Monad -> unit(wraps a type) + flatMap(apply func over inner type A -> F[B])
    - a Monad can be thought of as a subset of Functor (so not all Functors are Monads)
    - more pratically speaking it's a mechanism to describe sequential behaviour

## PHILOSOPHIES AND DESIGN
- Moore's law - transistor count will double every 2 years
- Amdahl's law - total perf gained by optimizing one part of system limited by fraction of total time part is used
- [SOLID](https://en.wikipedia.org/wiki/SOLID) - Robert C. Martin credited with coining it
    - SRP - single responsibility principle
    - interface segregation principle - Clients should not be forced to depend upon interfaces that they do not use
    - Liskov substitution principle 
        - Functions that use pointers/references to base classes must be able to use objects of derived classes without knowing it
    - open-closed principle - component should be open for extension, not modification
    - dependency inversion - depend on abstractions, not concretes
- seperation of concerns - each "concern" = feature, each component handles it's concerns
    - basically very similar in principle to SRP, keep system a set of loosly connected components
- inversion of control - app programer doesnt control low level flow of program, just programs modules that something else digests
    - often big "framework" (e.g. web frameworks) do this for example, like rails or django, both handle HTTP/low-level stuff
    - another exmaple is an event loop framework, app programmer might just write event handlers
- REST - representational state transfer
- batch processing - generally non-real time, usually store data to persistent store, then can slowly process it background
- stream processing - real-time crunching of data, generally no persistent data store step as data is received
- MapReduce and hadoop
    - hadoop designed to use cluster of commodity hardware to digest big data(consequence of internet) 
        - used in data warehousing, reccomendation systems, fraud detection, and more
        - can be combined with hive, pig, apache spark, flume, and other data processing engines
    - YARN - yet another resource manager - control plane that manages a hadoop cluster
        - want to perform mapreduce on data
            - application master requests the node manager, node manager approves/disapproves
            - if approved node manager asks resource manager
    - HDFS (hadoop distributed file system) - can store petabytes of data
        - a big file is split into many blocks, each on a diff storage node (block size 128MB by default)
        - blocks are replicated and stored on diff data nodes for durability
    - MapReduce - a task that you want to perform on set of big data
        - Split phase - file split into blocks and stored in HDFS
        - Map - in parrallel, each block is worked on my a map function, e.g. counting words and generate a key/value count
        - shuffle+sort phase - results from mapping from each block might be shuffled or sorted with each other
        - Reduce -> takes tuples from map/shuffle output and combines into smaller set of tuples
- CONSENSUS
    - Raft protocol - simple and efficient, protocol for leader/follower replication and election
        - kafka and etcd use raft
    - Paxos - predates Raft, more complex
- CAP - Consistency Availability Partition-tolerance
    - C in CAP is different from C in ACID
    - in a distrubted system if a partition fails, you can either have consistency or availability
        - take the system offline or stop processing requests until partiion is available
        - or keep processing requests, but lose consistency
            - e.g. async replication, partition causes replica to lose updates, master dies, replica promoted with outdated state
- eventual consistency - when a cluster eventually will all reach the same state
    - e.g. postgres replicas/followers are always behind to some degree, but will eventually get all the writes
- tunable consistency - e.g. cassandra offers this
- dead-letter queue - a store for when jobs cant be routed to their destinations
- Durability usually means does ur system preserve state/data when EVERYTHING fails (total power outage)
    - so often is your data backed up to persistent storage often
- backup 3-2-1 rule: at leaset 3 copies of data, on at least 2 different media types, and one in different location
- message queues (e.g. kafka, rabbitMQ)
    - comparison to service-to-service synchronous model:
        - advantage: can have many consumers receive same message, in p2p each "consumer" would have to be called by "producer"
        - advantage: can use fewer consumers to process same producer volume
        - advantage: lower latency, emitting event to queue is fast
        - advantage: more robust retry, consumer can reenqueue message if it failed
- [impedance mismatch](datastore_cheatsheet.md)
- distributed transactions
    - https://medium.com/@dongfuye/the-seven-most-classic-solutions-for-distributed-transaction-management-3f915f331e15
    - SAGA
    - 2 phase commit
### LAMBDA ARCHITECTURE
- uses stream processing and batch processing in parralel to ingest data
- data comming in is read-only and append only by timestamp
- batch layer aims at being very accurate, but is slow
    - Apache Hadoop was big original batch system, but others like Snowflake, Big Query, Redshift came along
- stream layer is real-time and fast but not accurate, doesnt process all the data
    - Apache Spark, Apache Storm, Kafka, Knesis
- serving layer - stores outputs from stream and batch layer for querying
- described by Nathan Marz in 2011, also introduced the CAP theorem

## LOGIC
- "switch" statements are often compiled to lookup tables or hash lists in most languages
    - this are faster than a if/else-if/else equivalent, but practically only for large numbers of cases
- comptime - an idea made popular by zig
    > Comptime allows the compiler to insert hardcoded values into the resulting 
    > compiled program that are written as expressions in source code.

## COMPILER
- lexer -> read a string and split into tokens
- parser -> take tokens from lexer and build a AST based on grammar
    - AST is then converted to native machine code
    - for iterpretted language, the target virtual machine. e.g. javac makes java bytecode for java virtual machine
- https://godbolt.org/ - badass tool to see assembly code compiled by many languages
- LLVM - highly modular
    - each lang has front end, front end transformed to IR(itermediate representation)
    - IR then can be transformed to backends, e.g. ARM, amd64, RISC-V, webassembly
- GCC - monolithic reliability, tightly coupled pipeline
    - C pipeline: C -> c preprocessor -> AST -> GENERIC -> GIMPLE -> GIMPLE SSA -> RTL -> assembly code
    - has stability, speed, and long-term compatibility with backend, thus linux uses it
### JIT VS AOT
- JIT(just-in-time) = dynamic compilation durning runtime,  AOT(ahead-of-time) = static compilation before runtime
- AOT has shorter startup time, generally has smaller binary size as it can elimiate unused code immediately
- JIT compilers can make optimziations based on runtime behaviour, which AOT can't
- java: JIT compiler means it'll find "hot spots" in java bytecode and compile those sections to machine code
    - next encounter of hot spot it will execute the whole section, instead of interpretting byte code one by one
    - AOT compiler enables java bytecode to be tranformed into native machine code b4 application is run
### TREESITTER
- a general fast incremental parsing for any lang/format intended for text editor
    - intended to be better than the regex-based systems that IDEs (including vim) use, faster and more accurate
- invented by github for atom editor in 2018
- official site - https://tree-sitter.github.io/tree-sitter/
- a grammar for a language/format is defined by rules in `grammar.js`, CLI read this and outputs C parser `parser.c`
- language parser creates CSTs(concrete syntax trees) in real-time and incrementally, which can be queried
    - sometimes we only need ASTs, treesitter has named and anonymous nodes, ASTs can just use named nodes
- module is something that does query on the CST, example modules:
    - syntax highlighting
        - generally more accurate and faster (especially since it's incremental) than regex highlighting that most editors use
        - can handle embedded/nested languages: https://tree-sitter.github.io/tree-sitter/syntax-highlighting#language-injection
    - formatting, e.g. indentation
    - folding
    - incremental selection
- parsing is restricted to just file, so LSPs will be way more accurate, but LSPs generally slower, treesitter is fast async c code
- 2024 most modern editors integrate it including: atom, neovim, zed, helix, emacs
- good article on it https://teknologiumum.com/posts/introductory-to-treesitter
    - it links to this good watch: https://www.youtube.com/watch?v=Jes3bD6P0To

## OPERATING SYSTEMS
- kernel vs userspace - many CPUs support different priviliege modes, higher privilige means they can run more instructions
    - oct2024 - dry but good vid: https://www.youtube.com/watch?v=H4SDPLiUnv4&t=1125s&ab_channel=CoreDumped
    - often a mode bit, if bit is set then it can run priviliedged instructions
    - privilege mode was designed for OS kernel, why it's often called kernel mode
    - priv mode lets u change MMU(memory manage unit), MMU controls which memory regions CPU has access to
    - OS exposes an API to userland, i.e. system calls, so that userland can ultimately do privilieged things
- interrupts - stop current process to do something, interrupts run in privileged mode
    - usually hardware that triggers interrupts like HID(mice, keyboards) or NICs
        - software can too, system calls by userland are interrupts
        - if software triggers interrupt, ISR must set mode bit back to non-privileged at the end
    - main program interupted, program counter points to ISR(interrupt service routine) and it runs
        - state of interrupted process saved, meat of interrupter logic happens, interrupt source resotred, return instruction calls
    - interrrupt used to also flip mode bit
- IPC
    - shared memory - diff processes sharing same memory space
        - e.g. chromium, 3 components, each seperate process: browsers, renderers, plugins. 1 renderer process per tab
    - network sockets
    - unix sockets
    - pipes

## DEPENDENCY MANAGEMENT
- see [build_dependency_tools_cheatsheet.md]

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
- not really cool but some silly ways to fizzbuzz - https://www.linkedin.com/pulse/efficient-way-solve-fizzbuzz-problem-denis-r/

## QA
- mock vs stub - https://stackoverflow.com/questions/3459287/whats-the-difference-between-a-mock-stub

## STORIES
- discord switch from golang->rust: https://discord.com/blog/why-discord-is-switching-from-go-to-rust
    - latency spikes due to GC pauses were a big issue
- whatsapp using erlang: https://thechipletter.substack.com/p/ericsson-to-whatsapp-the-story-of
- blog on why facebook migrated to mercurial from git: https://graphite.dev/blog/why-facebook-doesnt-use-git
- 2016 npm left-pad js microlibrary took down the world - https://en.wikipedia.org/wiki/Npm_left-pad_incident
### SECURITY
- heartbleed - openssl vulnerability found in 2014, buffer over-read attack
- xz utils backdoor - found in feb2024 - https://en.wikipedia.org/wiki/XZ_Utils_backdoor
    - jia tan was username doing this long con
- spectre - 2018 - cpu branch prediction attack - https://en.wikipedia.org/wiki/Spectre_(security_vulnerability)
