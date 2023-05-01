# RUST
- https://www.rust-lang.org/
    - quick ref: https://doc.rust-lang.org/rust-by-example/index.html
    - walkthrough of concepts: https://doc.rust-lang.org/stable/book/title-page.html
    - technical referece: https://doc.rust-lang.org/reference/introduction.html
- playground: https://play.rust-lang.org/
- https://crates.io/ is a central default registry for tools/programs in rust
- source files use `.rs` extension
- created by mozilla teams with a main goal of correctness/reliability/speed
    - driven by massive tech debt of fixing bugs and issue
- by many measures it's as fast as C
    - oftentimes compiles to identical assembly as C
- zig and carbon aim to be a better C, but rust doesnt try to be like C

# REPL
- https://github.com/google/evcxr
- https://docs.rs/papyrus/latest/papyrus/

## COMPILER/BUILD TOOL
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

## CARGO
- native package manager
- a package consists of many crates and is defined by a `Cargo.toml` file
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
- package versions of a crate cant be deleted, they can be yanked
    - this means lock files with yanked versions can still be used, but new projects cannot use this version

## GRAMMER
- in C/C++ methods are invoked with `.` on object, and `->` operator on pointers
    - in rust the `.` operator works on pointers or direct struct/object, pointers are automatically dereferenced

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
- `String` is a heap-allocated `Drop` type, it's mutable/growable
    - it's really a wrapper around a `Vec` of bytes
    - initalizing
        - `let s = String::new()`
        - `let s = String::from("literal string")` or `let s = "literal string".to_string`
    - mutating
        - appending a string slice - `s.push_str("append")`
        - append a single char - `s.push('f')`
        - concat: `s = String::from("hi"); s2 = String::from("there"); s3 = s + &s2`
            - `s` is moved here to `s3`, `s` cant be used after
            - `+` operator is defined as `fn add(self, s: &str) -> String {`
- literal strings are refered to with string slices (also immutable reference) `&str`
### ARRAYS
- static and cannot change size
- function argument type annotation of `[T]`
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

## FUNCTIONS
- rust doesnt formally have variadic args but an argument can be a slice, which is effectively the same
- no default values for arguments (some peeps like to use `Option<T>` and pass in `None` as a pattern to trigger default)
    - can use `Default` trait https://doc.rust-lang.org/std/default/trait.Default.html (can use `[#define]` attrib too)
    - can use struct update syntax with the default
    - some peeps like using the builder pattern
- no keyword arguments
    - discussion to add it - https://internals.rust-lang.org/t/pre-rfc-named-arguments/16413
- no function overloading
    - apr2023 - there is a `overloadable` crate in nightl build - https://docs.rs/overloadable/latest/overloadable/

## TYPE SYSTEM
- `enum` in rust is really a tagged union or algebraic sum type, other languages it's a thin layer on a list of integers

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
- [rocket](https://rocket.rs/) - prolly best rust backend web framework
- [yew](https://yew.rs) - /awesome front end framework (compiles to webassembly)
    - similar to react architecture, has the conecpt of components
    - generally faster than react!
    - uses a `html!` macro to generate valid html at rust compile time!
- [tauri](https://tauri.app/) - build native apps for desktop and mobile
- pingora - a http proxy that cloudflare wrote b/c nginx *was too slow!* (pingora uses a 1/3 of cpu and memory as nginx)

