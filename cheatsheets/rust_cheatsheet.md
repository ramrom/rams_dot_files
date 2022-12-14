# RUST
- https://www.rust-lang.org/
    - quick ref: https://doc.rust-lang.org/rust-by-example/index.html
    - walkthrough of concepts: https://doc.rust-lang.org/stable/book/title-page.html
- playground: https://play.rust-lang.org/
- https://crates.io/ is a central default registry for tools/programs in rust

# REPL
- https://github.com/google/evcxr
- https://docs.rs/papyrus/latest/papyrus/

## MEMORY MANAGEMENT
- `let` will put data in stack
- smart pointers put it on the heap

## CARGO
- `cargo install --list` - print all gobally installed crates

## EXAMPLES
```rust
let s1 = "foo" // immutable string
let s2 = String::from("hello");  // type String is mutable
```
