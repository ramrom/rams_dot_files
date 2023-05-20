# RUST
- source files use `.rs` extension
- created by mozilla teams with a main goal of correctness/reliability/speed
    - driven by massive tech debt of fixing bugs and issue
- by many measures it's as fast as C
    - oftentimes compiles to identical assembly as C
    - smart memory management unsing ownership/borrow/lifetime mechanic, no runtime garbage collector
- zig and carbon aim to be a better C, but rust doesnt try to be like C
- pre 1.0 rust at one point had a GC and threading runtime
- major editions: 2015, 2018, 2021
    - https://doc.rust-lang.org/edition-guide/editions/
    - all editions use the same internal representation
- good for kernel code, kernels don't/can't raise exceptions, generally return magical values in pointers that callers check
- https://crates.io/ is a central default registry for tools/programs in rust

## LEARNING RESOURCES
### DOCS
- https://www.rust-lang.org/
    - quick ref: https://doc.rust-lang.org/rust-by-example/index.html
    - walkthrough of concepts: https://doc.rust-lang.org/stable/book/title-page.html
    - technical referece: https://doc.rust-lang.org/reference/introduction.html
- rust in Y minutes: https://learnxinyminutes.com/docs/rust/
- `rustup doc` - open local copy of docs in browser
    - `rustup doc --std` to jump straight to std lib
    - `rustup doc --book` to jump straight to "The Rust Programming Language" book
### REPL
- https://github.com/google/evcxr
- https://docs.rs/papyrus/latest/papyrus/
### OTHER
- playground: https://play.rust-lang.org/

## COMPILER
- `rustc` uses LLVM
- `rustc somerustsourcefile.rs` -> successful compile will generate a executable bin file
    - use `cargo build` instead, which handles everything else including getting deps
- compile targets: https://doc.rust-lang.org/rustc/platform-support.html
    - can compile to asm.js, but WASM support is waaaay better/faster and every browser basically supports WASM
- compiler explorer: https://rust.godbolt.org , will show compiled assembly code!
- HIR - High level Intermedidate Representation
    - AST created after parsing, macro expansion, and name resolution
    - THIR - Typed High-Level Intermediate Representation
- MIR - Mid level Intermediate Representation, compiled from HIR
    - here we do the borrow-checking, optimization, and code gen
    - has no nested-expressions, all types are fully explicit
- LLVM IR - the lower level representation that LLVM sees
- FFI(foreign function interface) - has C-compatible calling conventions
    - can generally take rust object files and use with C, and C can also use rust code
- BORROW CHECKER
    - validates lifetimes - a borrower cant outlive what it borrows
- prelude - https://doc.rust-lang.org/std/prelude/index.html#
    - set of things that rust automatically imports (`use`s) into every program
### LINKING
- can produce dynamically or statically linked libraries

## BUILD TOOLS
- `rustup` installs and manages toolchain
    - `rustup update` - update/upgrade `rustc`, `cargo` and other tools including docs, clippy
    - `rustup show` - show rustc ver, rustup home dir, host arch
- `rustc` is compiler bin
- [cargo](#CARGO) is main dependency manager and build tool(fetch deps, compile/build, run, test, bench, lint)
- `rustfmt` - formatter, invoked by `cargo fmt`
    - docs on rules: https://rust-lang.github.io/rustfmt/
    - `cargo fmt` - apply formatting rules to source files
    - `cargo fmt --file=/path/to/file` - format just one file
    - `cargo fmt --check`  - print diff of format changes to shell
- `rust-analyzer` - Rust LSP

## CARGO
- native package manager
- `~/.cargo` dir contains source code for crates, bins, cached artifacts, and more
- a package consists of many crates and is defined by a `Cargo.toml` file
- package versions of a crate cant be deleted, they can be yanked
    - this means lock files with yanked versions can still be used, but new projects cannot use this version
### CRATE
    - compiling a source file, rust considers that a crate
    - composed of a tree of modules
        - modules needed by the source file will be compiled and linked in
    - a binary crate has a `main` functions, library crates don't
    - generally when someone says a crate they mean a library crate
- a path means a namespace for where things live
- `cargo install --list` - print all gobally installed crates
- `cargo install --version 0.3.10 someprogram` - install version x of program
- `cargo install someprogram` - will install _and_ upgrade(as of rust 1.4.1) a program
- `cargo tree` - print dependency tree
- `cargo build -v` - show exactly what commands it's running
- `cargo build --manifest-path /path/to/Cargo.toml` - specify `Cargo.toml` file in another location
- using a create in a project
    ```rust
    extern crate old_http;  // rust 2015
    use old_http::SomeType;


    use old_http::SomeType;  // rust 2018 and 2021
    ```

## GRAMMER
- in C/C++ methods are invoked with `.` on object, and `->` operator on pointers
    - in rust the `.` operator works on pointers or direct struct/object, pointers are automatically dereferenced
- if a expression is followed by semicolon `;`, then it'll discard the result and become a statement
### LOOPS
- `loop { ... }` - infinite loop
    - use `break` conditions internally to terminate
    - use `continue` to skip to next iteration
- `while bool_expre { ... }` - while loops
- `for_iter` can yield any of `T`, `&T` or `&mut T`, use `iter` or `iter_mut` for explicit refs
- for loops
    ```rust
        let foo = vec![1,2];

        for i in foo { println!("{i}"); }  // passes ownership, foo becomes invalid

        for i in foo.iter() { println!("{i}"); } // explicitly calling iter passes ref, &T
        for i in &foo { println!("{i}"); } // same as foo.iter()

        for i in foo.iter_mut() { println!("{i}"); } // passes &mut T
        for i in &mut foo { println!("{i}"); } // same as iter_mut

        foo.iter().map( |x| println!("{x}") ) // iterators are lazy, maps just returns another iterator with the closure
        foo.iter().map( |x| println!("{x}") ).filter( |x| x > 1 ) // iterator adapters are useful for chaining
        foo.iter().map( |x| println!("{x}") ).filter( |x| x > 1 ).collect() // collect will execute iterator and return collection
                                                                            // adapters are efficient, no intermediate collection is made!
        foo.iter().for_each( |x| println!("{x}") )  // for each side effects, executing on the iterator
        foo.iter().for_each( |x| x + 1 )  // fails compile, for_each must return a unit (), so last line is staetment, not expression
    ```
- adapters - `Iterator`s that return `Iterator`s, main examples: `map`, `filter`, `enumerate`, `take`, `zip`, `flatten`
- consumers - methods that consume `Iterators`, e.g. `collect`, `fold`, `reduce`, `sum`, `all`, `any`, `max`, `min`, `count`, `find`
- unrolling - means to flatten a loop, compiler does this optimization often if it's a small number of known iterations
    - e.g. `for i in (1..5) { ... }`

## REFERENCES/OWNERSHIP
- references are a "pointer" to data, and in rust they also mean borrowing the data from an owner
- 2 main rules of references
    - a owner can lend out one mutable reference
    - a owner can lend out multiple immutable references
    - can _not_ lend out a mutable reference and an immutable reference
- Dereference coersion - convert a type that implements `DeRef` into a reference when passed in as func param
    - e.g. `String` implements `DeRef` and `deref` method produces `&str` so a `&String` can be passed into a arg of type `&str`
    - multiple nested `DeRef` types be called, e.g. `Box<String>>` passed into arg taking `&str`
        - `Box<String>` derefs to `String`, `String` derefs to string slice `&String`, `&String` derefs to `&str`
- why aren't multiple mutable references allowed in a single threaded context
    - https://www.reddit.com/r/rust/comments/95ky6u/why_arent_multiple_mutable_references_allowed_in/
- `Box<T>` - pointer to heap allocated data, single ownership and can mutate contents
    - implements `DeRef` and `DeRefMut` so can be used as reference, mutable too
    - implements `Send`, so can tx ownership to a different thread
    - can create recursive types using Box: e.g. `enum E { Nil, Cons(i32, Box<E>) }`, or `struct S { a: i32, b: Option<Box<S>> }`
- `Rc<T>` - reference counter heap allocated data, multiple ownership, tracks # of references, and cleans up when count is zero
    - it is only used for single-threaded scenarios
    - it's immutable for same reason as borrow rules allowing one mutable reference, prevent data races/inconsistencies
    - you could use references, but that requires specifying lifetimes and might mean tons of data lives for long unneccessary times
    - implements `DeRef` but not `DeRefMut`, so can't mutate it's contents, read only
    - doesn not implement `Send`
    - usage `let a = Rc::new(1); let b = Rc::clone(&a)`
        - can also do `let b = a.clone()` but not idiomatic, `Rc::clone` wont deep-copy
        - get count `Rc::strong_count(&a)`
- `RefCell<T>` - interior mutability that's checked at runtime
    - single ownership like `Box<T>`, except borrowing rules enforced at runtime, and will panic if borrow rules violated
    - `let r = RefCell::new(1); *r.borrow_mut() = 2`
    - `let r = RefCell::new(1); let r1 = r.borrow_mut(); let r2 = r.borrow_mut(); *r1 = 2; *r2 = 3`
        - will panic in runtime!, no comile time error
### LIFETIMES
- references are tracked by lifetimes and lifetime annotatinos are needed in cases in order to help the compiler/borrow-checker
- a parameters with an annotation has a input lifetimes, a return values have output lifetime
- output lifetimes cant outlive input lifetimes, that's a dangling pointer/reference
- `'static` lifetime means reference lives for the entire duration of program
- lifetime elision rules are cases where lifetime annotations are not needed because the compiler can infer them correctly
    - 3 main rules to determine if no lifetime annotations are needed on func/method
        - multiple inputs each get a different lifetime parametes
        - if only one input then the output gets the same lifetime
        - if multiple inputs and one is `&self` or `&mut self` then output get the lifetime of `self`


## LIBS
- `std` relies on OS primitives
- `core` relies on nothing
- `alloc` requires on a memory allocator
    - most collections in this crate, except hashmap which relies on random data, so its in `std`

## COLLECTIONS
- https://doc.rust-lang.org/std/collections/index.html
- may2023 - good vid on collections - https://www.youtube.com/watch?v=EF3Z4jdD1EQ&list=WL&ab_channel=JonGjengset
    - many collections need to use unsafe code(raw pointers) in order to be feasible/performant, borrow checker couldnt reason about it well
### STRINGS
- `String` and `&str` are UTF-8
- string literals (preallocated text) - declared in code like `let s = "string lit"`
    - are refered to with string slices (also immutable reference) `&str`
    - they are stored in a special read-only memory of executable
- `String`
    - is a heap-allocated `Drop` type, it's mutable/growable
    - it's really a wrapper around a `Vec<u8>` of bytes
    - indexing/iterating
        - you cant index (`s[1]`) because it's confusing/ambiguous, for UTF8 is it byte value? scala value? grapheme cluster value?
        - can slice the bytes, `s[0..4]`, but if bytes fall outside of char boundary it will panic
        - can specify byte or char with iterator
            - `for c in "Зд".chars() { println!("{c}"); }`
            - `for b in "Зд".bytes() { println!("{b}"); }`
            - grapheme clusters are harder, so no stdlib func provided, but crates do exist
    - initalizing
        - `let s = String::new()`
        - `let s = String::from("literal string")` or `let s = "literal string".to_string`
    - mutating
        - appending a string slice - `s.push_str("append")`
        - append a single char - `s.push('f')`
        - concat
            - `s = String::from("hi"); s2 = String::from("there"); s3 = s + &s2`
                - `s` is moved here to `s3`, `s` cant be used after
                - `+` operator is defined as `fn add(self, s: &str) -> String {`
                - `s3` takes ownership over `s`, and copy of `s2` gets appended to `s3`
            - `s1 = String::from("tic"); s2 = String::from("tac"); s3 = String::from("toe"); s = format!("{s1}-{s2}-{s3}")`
                - `format!` is more succinct for concat of many strings
                - doesnt take ownership of any of the params
- `eprintln!` is macro to print to stderr
### ARRAYS
- static and cannot change size
- function argument type annotation: unsized `[T]`, sized `[T, 3]`
- indexing starts at zero, e.g. `a[0]` is first element
- stored in contiguous sections of memory on the stack
    - if array is too large, at runtime will get stack overflow
- len/size
    - `a.len()` - get length
    - `mem::size_of_val(&[1,2]))` - get num bytes in memory
- `let a = [ 1, 2 ]` - declaration
    - example type annotation declaration `let xs: [i32; 5] = [1, 2, 3, 4, 5];`
    -  initialize size 500 array with value zero - `let ys: [i32; 500] = [0; 500];`
### VECTORS
- essential a struct with 3 properties: capacity, length, and pointer to base
    - generally vector struct on stack, and data in heap
- are mutable heap allocated arrays: `let a = vec![1 2]`
- stored in a contiguous section of memory
- initialize `Vec::with_capacity(n)`, for large n, instead of `new`, if you know u will push tons of items
    - this avoids a lot of copies and allocations
- it implements `Debug`, but not `Display`, and can be printed with `let v = vec![1, 2]; println!("{v:?}");`
- `VecDeque` - basically a ring buffer that uses a beginning and end pointer
    - good for queues and stacks, esp queue, u can append to beginning without having to move all items in array
    - overhead: gotta check if at end of allocation and wrap when indexing
    - disadvantage: cant turn into slice (no `DeRef` into slice), slices needs to be contiguous memory
    - disadvantage: cpu's do memory readahead optimizations for things like loops, and they dont know the ring buffer's termination
### SLICES
- like arrays but size not known at compile time
- 2 word object: 1st word is pointer to data, 2nd word is length of slice
- allow us to borrow arrays
- shared/immutable type signature `&[T]`, e.g. `&[i32]`
- mutable type signature `&mut [T]`
- `let a = [1 ,2, 3, 4]; let s = &a` - `s` is a reference and immutable borrow here, `&a` is slice containing all of `a`
    - `let s = &a[0..2]` - borrow just first and second of `a`, ending index is non-inclusive
### HASHMAP
- `HashMap<K, V>` associative arrays, heap allocated
    - `K`, `V` are generic types, key and value must be one type (homogenous)
    - no macros to build them
    - backed by a vector with buckets and linear probing
    - linear probing: for insert, if bucket is taken compute hash with occupying key + insertion key, goto that bucket, repeat till vacancy
        - newest imp uses `hashbrown::hash_map` create (google invented hash, swisstable, uses quadratic probing and SIMD, very fast)
            - hashbrown doesnt require random num generation for `Hasher`, so can be used in more places (embedded systems, kernels)
            - saturation is around 60-70%, when it hits this level it allocates more mem for more buckets
    - `new` will probably create a 64-128 sized initial array
    - std lib hashing functions is fast but not fastest, it uses a slower cryptographic hash function, a tradeoff for security
        - e.g. webserver that hashes user data, malicious user could DoS by choosing keys that fully collide, making hash very slow
        - cryptographic hash will also use a random seed (`RandomState`)
    - when map gets full, a new backing array is created, and more than mem copy b/c hash func output will be different due to modulus
        - thus it's more work than a straight memcopy, key/values will have to be reinserted
- need to `use`
    ```rust
    `use std::collections::HashMap;`

     // for Copy types like i32, it's copied, for Drop/owned traits like String, HashMap will take ownership
     // if key or value is ref type &T, hashmap needs to live shorter than all the referees
     let mut scores = HashMap::new();
     scores.insert(String::from("Blue"), 10);
     scores.insert(String::from("Yellow"), 50);

     // iterate over key/vals
     for (key, value) in &scores {  println!("{key}: {value}"); }

     // will overwrite the old value of 10
     scores.insert(String::from("Blue"), 25);

     // entry returns Entry enum that indicates if it might exist, here with or_insert we insert if it doesn't exist
     scores.entry(String::from("Yellow")).or_insert(50);
     scores.entry(String::from("Blue")).or_insert(50);
     ```
- `get` method that returns `Option<V>`, `None` if key not found
- - `BTreeMap` uses a B-Tree and keys are ordered (`HashMap` they are not)
    - in std lib size of B is 6
### SETS
- `BTreeSet` and `HashSet` use `HashMap` and `BtreeMap`
    - since maps keys are unique, that is leveraged for sets, the values of the maps are moot/unit-structs
### BINARY HEAP
- `BinaryHeap` - backed by vector, inserts(push) very fast, pop always extracts highest value item
    - use for priority queues, need to order jobs by priority and process them by priority


## FUNCTIONS
- no variadic args but an argument can be a slice, which is effectively the same
- no default values for arguments (some peeps like to use `Option<T>` and pass in `None` as a pattern to trigger default)
    - can use `Default` trait https://doc.rust-lang.org/std/default/trait.Default.html (can use `[#define]` attrib too)
    - can use struct update syntax with the default
    - some peeps like using the builder pattern
- no keyword arguments
    - discussion to add it - https://internals.rust-lang.org/t/pre-rfc-named-arguments/16413
- no function overloading
    - apr2023 - there is a `overloadable` crate in nightl build - https://docs.rs/overloadable/latest/overloadable/
- fully supports higher-order/first-class functions
    - `fn twice(f: fn(T) -> (), i: T) -> () { f(i); f(i); }`
### CLOSURES
- are anonymous functions that can capture their environment
- compiler auto-implments each closure into 3 traits
    - `FnOnce`- can only be run once, basically if ownership is transfered, aka moved out of it's environment
        - all closures can be called at least once so they all implement this
    - `FnMut` - will mutate captured values, dont move them
        - e.g. trait `Iterator`'s method `map` takes a `FnMut` closure, b/c a closure is called many times on a collection
    - `Fn` - will only read captured values, dont move them, or dont even capture values from env
- if a closure implements `Fn` it will also implement `FnMut` and `FnOnce`, if closure implements `FtMut` it also does `FnOnce`
- so a function that takes a `Fn` closure as an argument, compiler would error if a `FnOnce` or `FnMut` closure was passed in
- a named function also implements all these three as well
     - e.g. an `Option<Vec<T>>` could call `unwrap_or_else(Vec::new)`
```rust
let closure_annotated = |i: i32| -> i32 { i + outer_var };    // with annotations
let closure_inferred  = |i     |          i + outer_var  ;    // inferrerd types
let one = || 1;         // closure takes zero args, single line expressions dont need curly braces
```

## TYPE SYSTEM
- contants, `const` keyword - cannot be mutable, type must be annotated, can declare in global scope
    - can use constant expressions, but not expression that evaluate at runtime
    - naming convention is to use upper snake case
    - `const MY_CONST: i32 = 1; const CONST_EXP: i32 = 10 * 10 * 3600;`
- static, similar to `const` but can be mutated, lives in a static memory space, have static lifetime (so forever)
    - type must have `Sync` to be shared for multi-threaded access
- `enum` in rust is really a tagged union or algebraic sum type, other languages it's a thin layer on a list of integers
- `Option<T>` - generic enum which can be `Some<T>` or `None`
    - `unwrap_or(x)` -> retrieve value `T` if `Some<T>`, if `None` return `x`
- `Sized` - trait, known size at compile time, doesnt change size
     - for enums compiler uses size of largest variant
- `Copy` - trait, value is always copied(memcpy, so direct bit by bit copy)
    - cannot be implemented on `Drop` types
    - these itmes are generally simple, have a known size, and allocated on the stack
    - they copy on new variable assignments vs tx of ownership `x = 1; y = x` (`y` is a copy of `x` with value 1, no ownership transfer)
    - e.g. `i32`, `char`, `bool`, references themselves like `&T` and `&mut T`
        - arrays `[T; N]` are `Copy` type too if elements if `T` is `Copy` type
- `Drop` trait, types that drop/free when they go out of scope, so need ownership tracking
    - compiler will essentially insert the `drop` on a `Drop` type at the end of it's scope
    - trait has one method `drop` that you can't call explicitly on a `Drop` type
        - otherwise compiler cant gaurantee memory safety, double drops or dangling pointers
    - for manualy drop you can call `std::mem::drop`, e.g. `drop(somevar)`
- Monomorphization: generics are expanded and defined for each type used at compile time, so no perf hit for using generics
### TRAITS
- follows orphan rule
    - cannot implement _external_ traits on _external_ types
    - **can** implment _internal_ trait on _external_ type and _external_ trait on _internal_ type
    - without rule, 2 crates could implement same trait on same type, this is a conflict and rust wouldnt know which to pick
- blanket implementations - can implement a trait if a type conditionally implements another trait (using generics)
    - `impl<T: Display> ToString for T { // --snip-- }`  - from stdlib, this implements `ToString` if `T` implements `Display`
- auto traits - https://doc.rust-lang.org/beta/unstable-book/language-features/auto-traits.html
    - e.g. Structs, enums, unions and tuples implement the trait if all of their fields do.
    - Function item types and function pointers automatically implement the trait.
    - `&T` , `&mut T` , `*const T` , `*mut T` , `[T; n]` and `[T]` implement the trait if `T` does.
    - `Send`, `Sync`, `Unpin`, `UnwindSafe` are all autotraits
- trait objects are fat pointers with both the object pointer and the vtable of methods
    - for trait `Trait`, `Box<dyn Trait>` is a trait object
    - compiles to single function that does a dispatch at runtime based on the object concrete type
### OTHER
- rust does not really support downcasting (can't `match` on a trait object's implementor types)
    - traits objects can't be downcast back to the original type with casting or coersion
    - the `Any` trait can do this, it's type-safe downcasting on trait objects
    - one idomatic way is to use `enums` variants in place of the trait implementors
- for `trait Trait {}`, a param of type `impl Trait` is basically syntax sugar for generic trait `<T: Trait>`
    ```rust
    trait Trait {}
    fn foo<T: Trait>(arg: T) { }

    fn foo(arg: impl Trait) { }
    ```
    - generic with trait bound will have a concrete type at compiletime due to monomorphization
    - trait objects contain concrete type only known at run time
    - big use case for trait objects is a array/vector/collection of heterogenous concrete types, can't do that with a generic trait
- no exception handling, `Result<T, E>` is commonly used to return errors as values
    - `unwrap` - panic if `Err`, `expect('failure!')` - panic if `Err` with message
    - `unwrap_or_else(|err| ...)` - error handler func if `Err`
    - propogate errors to caller with `?` operator
- DST - dynamically sized types - https://doc.rust-lang.org/nomicon/exotic-sizes.html
    - types can only exist behind a fat/wide pointer
    - main cases of DST
        - trait objects `dyn MyTrait` -> pointer has pointer to data and vtable
        - slices(`[T]`), `str`
        - structs can store a DST in a field `struct foo { a: [i32], b: u32 }`, making the struct DST itself

## CONCURRENCY
- rust only implements native threads
    - no green thread system (e.g. goroutines in golang)
    - the tried green threads in rust 1.0, but runtime was becoming bloated
    - rust intention is to stay a low level systems language with minimal runtime
    - https://stackoverflow.com/questions/29428318/why-did-rust-remove-the-green-threading-model-whats-the-disadvantage#29430403
- futures - https://docs.rs/futures/latest/futures/
    - very similar to javascript promises or scala future
- channels (std lib)
    - support one receiver and multiple senders
- two major categories: `Sync` and `Send`
    - `Sync` allows many references to same value
        - `Mutex`, `RWLock`, and `Atomic`s are `Sync` type
    - `Send` safe to transfer ownership to different thread
- sync wait group (like golang WaitGroup)
    - std lib also has Barrier https://doc.rust-lang.org/std/sync/struct.Barrier.html
    - crossbeam waitgroup: https://docs.rs/crossbeam/latest/crossbeam/sync/struct.WaitGroup.html

## CASTING
- `as` keyword used to turn primitive types (e.g. `i32`, `char`, `bool`) into other primitive types
- `From` and `Into` are main traits to convert, complex types like `Vec` and `String` support this

## ANNOTATION
- `derive` - tells rust to automatically generate a trait implementation for a type
- `cfg` - means set a configuration
    - example configs: `test`

## TESTING
- annotate `mod` with `#[cfg(test)]` and test func with `#[test]`
    - convention is to create a `tests` mod in each file just for tests
    - `#[cfg(test)]` tells cargo to only build this mod on `cargo test`
- `assert( 1 == 2, "one equals 2")` - 1st arg must return `bool`, will panic with message in 2nd arg if `false`
    - `assert( 1 == 2, "one equals {}", 2)` - can also take 3 args
- `assert_eq!(1, 1)` - panics unless args are equal
- `assert_ne!(1, 1)` - assert not equal
    - left and right of `assert_eq` and `assert_ne` must implement `PartialEq` and `Display`
- if `panic` is expected annotate the test func with `#[test]` and `#[should_panic]`
    - can test specific panic message with `#[should_panic(expected = "some expected message in panic statement")]`
- `cargo test` by default runs tests in parrallel, make sure tests wont cause race conditions with each other
    - can run serially with `cargo test --test-threads=1`
    - add `#[ignore]` annotation to test to ignore, then can run only ignored with `cargo test -- --ignored`
    - `cargo test foo` - will run all tests with `foo` in the function name
    - `cargo test --test foofile` - run just tests in a file named `foofile`
- can test private funcs in rust
- integration tests live in another top level directory `tests`, they test only public API of ur lib

## MACROS
- like macros in other langs, it's metaprogramming, rust code that expands to more rust code
- 2 major types: declarative and procedural
- declarative macros, aka "macros by example"
    - similar to pattern `match`, macro take input rust code, and match that code to a pattern to generate more rust code
    - defined using `macro_rules!`
    - `vec!` is an example
- procedural macros, 3 major types
    - act more like functions/procedures, take input rust code, modify it and spit it out
    - type 1: `derive` are procedural macros that implement various traits on enums/structs
    - type 2: attribute-like
    - type 3: function-like

## EXAMPLES
```rust
let s1 = "foo" // immutable string
let s2 = String::from("hello");  // type String is mutable
```

## LIBS/FRAMEWORKS/APPS
- [rayon](https://docs.rs/rayon/latest/rayon/) - lib for making sequential computations parralel (e.g. parrallel iterators)
- [tokio](https://tokio.rs) - awesome async framework
- [serde](https://serde.rs/) - awesome serial/deserialization framework
- [hyper](https://hyper.rs/) - popular http client lib (and server lib), dep on tokio
- [reqwest](https://github.com/seanmonstar/reqwest) - simpler http client lib, dep on tokio
    - http cli tool `xh` uses reqwest
- [rocket](https://rocket.rs/) - most popular rust backend web framework, uses async
- [actix](https://actix.rs/) - popular web framework, uses actor model
- [axum](https://github.com/tokio-rs/axum) - popular web framework
- [yew](https://yew.rs) - /awesome front end framework (compiles to webassembly)
    - similar to react architecture, has the conecpt of components
    - generally faster than react!
    - uses a `html!` macro to generate valid html at rust compile time!
- [tauri](https://tauri.app/) - build native apps for desktop and mobile
- CLI
    - [clap](https://docs.rs/clap/latest/clap/) - awesome CLI argument parser lib
    - [colored](https://lib.rs/crates/colored) - good ANSI terminal color lib for strings
- pingora - a http proxy that cloudflare wrote b/c nginx *was too slow!* (pingora uses a 1/3 of cpu and memory as nginx)
- [vaultwarden](https://github.com/dani-garcia/vaultwarden) - bitwarden server written in rust!

