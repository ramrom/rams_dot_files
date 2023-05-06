# RUST
- source files use `.rs` extension
- created by mozilla teams with a main goal of correctness/reliability/speed
    - driven by massive tech debt of fixing bugs and issue
- by many measures it's as fast as C
    - oftentimes compiles to identical assembly as C
- zig and carbon aim to be a better C, but rust doesnt try to be like C
- pre 1.0 rust at one point had a GC and threading runtime
- good for kernel code, kernels don't/can't raise exceptions, generally return magical values in pointers that callers check

## DOCS
- https://www.rust-lang.org/
    - quick ref: https://doc.rust-lang.org/rust-by-example/index.html
    - walkthrough of concepts: https://doc.rust-lang.org/stable/book/title-page.html
    - technical referece: https://doc.rust-lang.org/reference/introduction.html
- playground: https://play.rust-lang.org/
- https://crates.io/ is a central default registry for tools/programs in rust
- `rustup doc` - open local copy of docs in browser
    - `rustup doc --std` to jump straight to std lib
    - `rustup doc --book` to jump straight to "The Rust Programming Language" book

## REPL
- https://github.com/google/evcxr
- https://docs.rs/papyrus/latest/papyrus/

## COMPILER
- uses LLVM
- `rustc` is compiler bin
- `rustup` - bin to install toolchain and com
- `rustup update` - update/upgrade `rustc` (and `cargo`, docs, other tools)
- `rustc somerustsourcefile.rs` -> successful compile will generate a executable bin file
- compile targets: https://doc.rust-lang.org/rustc/platform-support.html
    - can compile to asm.js, but WASM support is waaaay better/faster and every browser basically supports WASM
- compiler explorer: https://rust.godbolt.org , will show compiled assembly code!
- HIR - High level Intermedidate Representation
    - AST created after parsing, macro expansion, and name resolution
- MIR - Mid level Intermediate Representation, compiled from HIR
    - here we do the borrow-checking, optimization, and code gen
    - has no nested-expressions, all types are fully explicit
- THIR - Typed High-Level Intermediate Representation
- FFI(foreign function interface) - has C-compatible calling conventions
    - can generally take rust object files and use with C, and C can also use rust code
- BORROW CHECKER
    - validates lifetimes - a borrower cant outlive what it borrows

## BUILD TOOLS
- `cargo` is main dependency manager
- `rustup` installs and manages toolchain
    - `rustup show` - show rustc ver, rustup home dir, host arch

## CARGO
- native package manager
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

## GRAMMER
- in C/C++ methods are invoked with `.` on object, and `->` operator on pointers
    - in rust the `.` operator works on pointers or direct struct/object, pointers are automatically dereferenced
### LOOPS
- `loop { ... }` - infinite loop
    - use `break` conditions internally to terminate
    - use `continue` to skip to next iteration
- `while bool_expre { ... }` - while loops
- for loops
    ```rust
        let foo = vec![1,2];

        for i in foo { println!("{i}"); }  // passes ownership, foo becomes invalid

        for i in foo.iter() { println!("{i}"); } // explicitly calling iter passes ref, &T
        for i in &foo { println!("{i}"); } // same as foo.iter()

        for i in foo.iter_mut() { println!("{i}"); } // passes &mut T
        for i in &mut foo { println!("{i}"); } // same as iter_mut

        foo.iter().map( |x| println!("{x}") ) // iterators are lazy, maps just returns another iterator with the closure
        foo.iter().map( |x| println!("{x}") ).filter( |x| x > 1 ) // iterator adapters are useful for chained
        foo.iter().map( |x| println!("{x}") ).filter( |x| x > 1 ).collect() // collect will execute iterator and return collection
                                                                            // only one collection gets created here, not 2!
        foo.iter().for_each( |x| println!("{x}") )  // for each side effects, executing on the iterator
        foo.iter().for_each( |x| x + 1 )  // fails compile, for_each must return a unit (), so last line is staetment, not expression
    ```
- `Iterator`s that return `Iterator`s are adapters, main examples: `map`, `filter`, `take`


## MEMORY MANAGEMENT
- smart anaul memory management unsing ownership/borrow/lifetime mechanic, no runtime garbage collector
- `let` will put data in stack
- smart pointers put it on the heap

## REFERENCES/OWNERSHIP
- why aren't multiple mutable references allowed in a single threaded context
    - https://www.reddit.com/r/rust/comments/95ky6u/why_arent_multiple_mutable_references_allowed_in/

## COLLECTIONS
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
- closures are anonymous functions that can capture their environment
    ```rust
    let closure_annotated = |i: i32| -> i32 { i + outer_var };    // with annotations
    let closure_inferred  = |i     |          i + outer_var  ;    // inferrerd types
    let one = || 1;         // closure takes zero args, single line expressions dont need curly braces
    ```

## TYPE SYSTEM
- `enum` in rust is really a tagged union or algebraic sum type, other languages it's a thin layer on a list of integers
- `Option<T>` - generic enum which can be `Some<T>` or `None`
    - `unwrap_or(x)` -> retrieve value `T` if `Some<T>`, if `None` return `x`
- `Sized` - trait, known size at compile time, doesnt change size
- `Copy` - trait, value is always copied, (kind of opposite of `Drop` types)
    - e.g. `i32`, `bool`, references themselves like `&T` and `&mut T`
- `Drop` trait, types that drop/free when they go out of scope, so need ownership tracking
- Monomorphization: generics are expanded and defined for each type used at compile time, so no perf hit for using generics
### TRAITS
- blanket implementations - can implement a trait if a type conditionally implements another trait (using generics)
    - `impl<T: Display> ToString for T { // --snip-- }`  - from stdlib, this implements `ToString` if `T` implements `Display`
- auto traits - https://doc.rust-lang.org/beta/unstable-book/language-features/auto-traits.html
    - e.g. Structs, enums, unions and tuples implement the trait if all of their fields do.
    - Function item types and function pointers automatically implement the trait.
    - `&T` , `&mut T` , `*const T` , `*mut T` , `[T; n]` and `[T]` implement the trait if `T` does.
- trait objects are fat pointers with both the object pointer and the vtable of methods
    - for trait `Trait`, `Box<dyn Trait>` is a trait object
    - compiles to single function that does a dispatch at runtime based on the object concrete type
### OTHER
- rust does not really support downcasting (can't `match` on a trait object's implementor types)
    - traits objects can't be downcast back to the original type with casting or coersion
    - the `Any` trait can do this, it's type-safe downcasting on trait objects
    - one idomatic way is to use `enums` variants in place of the trait implementors
- for `trait Trait {}`, a param that takes `impl Trait` is basically syntax sugar for generic trait `<T: Trait>`
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

## TESTING
- `assert( 1 == 2, "one equals 2")` - 1st arg must return `bool`, will panic with message in 2nd arg if `false`
- `assert_eq!(1, 1)` - panics unless args are equal

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
- [tokio](https://tokio.rs) - awesome async framework
- [serde](https://serde.rs/) - awesome serial/deserialization framework
- [actix](https://actix.rs/) - popular web framework
- [axum](https://github.com/tokio-rs/axum) - popular web framework
- [hyper](https://hyper.rs/) - popular http client lib (and server lib), dep on tokio
- [reqwest](https://github.com/seanmonstar/reqwest) - simpler http client lib, dep on tokio
    - http cli tool `xh` uses reqwest
- [rocket](https://rocket.rs/) - most popular rust backend web framework
- [yew](https://yew.rs) - /awesome front end framework (compiles to webassembly)
    - similar to react architecture, has the conecpt of components
    - generally faster than react!
    - uses a `html!` macro to generate valid html at rust compile time!
- [tauri](https://tauri.app/) - build native apps for desktop and mobile
- [clap](https://docs.rs/clap/latest/clap/) - awesome CLI parser lib
- pingora - a http proxy that cloudflare wrote b/c nginx *was too slow!* (pingora uses a 1/3 of cpu and memory as nginx)

