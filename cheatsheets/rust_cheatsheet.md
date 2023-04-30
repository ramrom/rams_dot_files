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
- `rustc` is compiler bin
- `rustup` - bin to install toolchain and com
- `rustup update` - update/upgrade `rustc` (and `cargo`, docs, other tools)
- `rustc somerustsourcefile.rs` -> successful compile will generate a executable bin file
- compile targets: https://doc.rust-lang.org/rustc/platform-support.html
    - can compile to asm.js, but WASM support is waaaay better/faster and every browser basically supports WASM
- compiler explorer: https://rust.godbolt.org , will show compiled assembly code!

## CARGO
- native package manager
### CRATE
    - compiling a source file, rust considers that a crate
    - modules needed by the source file will be compiled and linked in
    - a binary crate has a `main` functions, library crates don't
    - generally when someone says a crate they mean a library crate
    - a package consists of many crates and is defined by a `Cargo.toml` file
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

## LIBS/FRAMEWORKS/APPS
- [tokio](https://tokio.rs) - awesome async framework
- [rocket](https://rocket.rs/) - prolly best rust backend web framework
- [yew](https://yew.rs) - /awesome front end framework (compiles to webassembly)
    - similar to react architecture, has the conecpt of components
    - generally faster than react!
    - uses a `html!` macro to generate valid html at rust compile time!
- [tauri](https://tauri.app/) - build native apps for desktop and mobile
- pingora - a http proxy that cloudflare wrote b/c nginx *was too slow!* (pingora uses a 1/3 of cpu and memory as nginx)

## EXAMPLES
```rust
let s1 = "foo" // immutable string
let s2 = String::from("hello");  // type String is mutable
```
