# RUST
- https://www.rust-lang.org/
    - quick ref: https://doc.rust-lang.org/rust-by-example/index.html
    - walkthrough of concepts: https://doc.rust-lang.org/stable/book/title-page.html
- playground: https://play.rust-lang.org/
- https://crates.io/ is a central default registry for tools/programs in rust
- source files use `.rs` extension

# REPL
- https://github.com/google/evcxr
- https://docs.rs/papyrus/latest/papyrus/

## MEMORY MANAGEMENT
- `let` will put data in stack
- smart pointers put it on the heap

## RUSTC / RUSTUP
- `rustup` - bin to install toolchain and com
- `rustup update` - update/upgrade `rustc` (and `cargo`, docs, other tools)
- `rustc somerustsourcefile.rs` -> successful compile will generate a executable bin file

## CARGO
### CRATE
    - compiling a source file, rust considers that a crate
    - modules needed by the source file will be compiled and linked in
    - a binary crate has a `main` functions, library crates don't
    - generally when someone says a crate they mean a library crate
    - a package consists of many crates and is defined by a `Cargo.toml` file
- `cargo install --list` - print all gobally installed crates
- `cargo install --version 0.3.10 someprogram` - install version x of program
- `cargo install someprogram` - will install _and_ upgrade(as of rust 1.4.1) a program

## EXAMPLES
```rust
let s1 = "foo" // immutable string
let s2 = String::from("hello");  // type String is mutable
```

## TYPE SYSTEM
- `enum` in rust is really a tagged union or algebraic sum type, other languages it's a thin layer on a list of integers

## GRAMMER
- in C/C++ methods are invoked with `.` on object, and `->` operator on pointers
    - in rust the `.` operator works on pointers or direct struct/object, pointers are automatically dereferenced
