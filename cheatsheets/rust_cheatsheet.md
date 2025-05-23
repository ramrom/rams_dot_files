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
- discord switch from golang->rust: https://discord.com/blog/why-discord-is-switching-from-go-to-rust
    - latency spikes due to GC pauses were a big issue
- https://matklad.github.io - awesome blog by core maintiner of `rust-analyzer` and tigerbeetle
    - nice zig vs. rust thoughts: https://matklad.github.io/2023/03/26/zig-and-rust.html
- std lib is very bare on purpose
    - rust community gaurantees std lib is very stable long term, even across new editions, can do this b/c it's small
    - also small b/c crate system is so robust, it's easy to include a crate that does what you want
    - e.g. this is a big reason rust std lib doesnt support http
    - pythons std lib is massive and a mess, many things are not reccommended by python community

## LEARNING RESOURCES
### DOCS
- official docs - https://www.rust-lang.org/
- quick ref of every feature -  https://doc.rust-lang.org/reference/introduction.html
- nice simple examples for most features - https://doc.rust-lang.org/rust-by-example/index.html
- the rust book (walkthrough of core concepts): https://doc.rust-lang.org/stable/book/title-page.html
- technical reference: https://doc.rust-lang.org/reference/introduction.html
- rust in Y minutes: https://learnxinyminutes.com/docs/rust/
- `rustup doc` - open local copy of docs in browser
    - `rustup doc std::collections::HashMap` - open a specific topic in browser
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
- most version use `libc` for low level stuff like syscalls
### LINKING
- can produce dynamically or statically linked libraries
- generics on dynamic libs
    - AST of generic functions is stored in the metadata of a library
    - when you compile against it you get a copy of that AST and monomorphize your own copies when you need it.
    - so it's not really dynamic

## BUILD TOOLS
- `rustup` installs and manages toolchain
    - `rustup update` - update/upgrade `rustc`, `cargo` and other tools including docs, clippy
    - `rustup show` - show rustc ver, rustup home dir, host arch
- `rustc` is compiler bin
- [cargo](#cargo) is main dependency manager and build tool(fetch deps, compile/build, run, test, bench, lint)
- `rustfmt` - formatter, invoked by `cargo fmt`
    - docs on rules: https://rust-lang.github.io/rustfmt/
    - `cargo fmt` - apply formatting rules to source files
    - `cargo fmt --file=/path/to/file` - format just one file
    - `cargo fmt --check`  - print diff of format changes to shell
- `rust-analyzer` - Rust LSP
- `rustdoc` - generate docs for the project

## CARGO
- native package manager
- `~/.cargo` dir contains source code for crates, bins, cached artifacts, and more
- a package consists of many crates and is defined by a `Cargo.toml` file
### CARGO COMMANDS
- `cargo new myproject` - create new project (Cargo.toml and main.rs file in dir `myproject`)
- `cargo install --list` - print all gobally installed crates
- `cargo install --version 0.3.10 someprogram` - install version x of program
- `cargo install someprogram` - will install _and_ upgrade(as of rust 1.4.1) a program
- `cargo uninstall someprogram` - will remove a program
- `cargo add tokio --features rt` - add `tokio` as dep to toml with feature `rt`
- `cargo tree` - print dependency tree
- `cargo build -v` - show exactly what commands it's running
- `cargo build --manifest-path /path/to/Cargo.toml` - specify `Cargo.toml` file in another location
- `cargo doc` - build docs for current crate, including dependencies
    - `cargo doc --open` - open docs for crate in browser
    - `cargo doc --document-private-items` - docs private items too
    - `cargo doc --all-features` - docs for every feature flag
### CRATE
- package versions of a crate cant be deleted, they can be yanked
    - this means lock files with yanked versions can still be used, but new projects cannot use this version
- main crate repository: https://crates.io/
- compiling a source file, rust considers that a crate
- composed of a tree of modules
    - modules needed by the source file will be compiled and linked in
- a binary crate has a `main` functions, library crates don't
- generally when someone says a crate they mean a library crate
- a path means a namespace for where things live
- using a crate in a project
    ```rust
    extern crate old_http;  // rust 2015
    use old_http::SomeType;

    use old_http::SomeType;  // rust 2018 and 2021
    ```

## CONTROL STRUCTURES
- in C/C++ methods are invoked with `.` on object, and `->` operator on pointers
    - in rust the `.` operator works on pointers or direct struct/object, pointers are automatically dereferenced
- if a expression is followed by semicolon `;`, then it'll discard the result and become a statement
### CONDITIONALS
- `if` is an expression
    - `let res: &str = if someval == 10 { "truecond" } else { "falsecond" };`
    - takes blocks of code called "arms" that must evaluate to a `bool`, there is no truthiness like ruby or javascript
### LOOPS
- `loop { ... }` - infinite loop
    - use `break` conditions internally to terminate
    - use `continue` to skip to next iteration
- `while bool_expre { ... }` - while loops
### ITERATORS
```rust
for i in 1..10 { println!("{i}"); };  // create a range and iterate over it, does 1,2..9, 10 is excluded
(1..10).for_each( |i| { println!("{i}"); } ) // range is iterator, almost same as above, this takes a closure unlike above
for i in 1..=10 { println!("{i}"); };  // inclusive of 10

let foo = vec![1,2];

for i in foo { println!("{i}"); }  // passes ownership, same as i.into_iter() foo becomes invalid
for i in foo.into_iter() { println!("{i}"); } // same as above
foo.into_iter().for_each ( |i| { println!("{i}"); } )  // same as above

for i in foo.iter() { println!("{i}"); } // explicitly calling iter passes ref, &T
for i in &foo { println!("{i}"); } // same as foo.iter()

for i in foo.iter_mut() { println!("{i}"); } // passes &mut T
for i in &mut foo { println!("{i}"); } // same as iter_mut

foo.iter().map( |x| println!("{x}") ) // iterators are lazy, maps just returns another iterator with the closure
foo.iter().map( |x| x + 1 ).filter( |&x| x > 1 ) // iterator adapters are useful for chaining
foo.iter().map( |x| x + 1 )
    .filter( |&x| x > 1 ).collect() // collect will execute iterator and return collection
                                   // adapters are efficient, no intermediate collection is made!

let result = [1,2,3].iter().map(|i| i * 2).fold(3, |acc, item| { acc + item } ) // fold

vec!["foo","bar"].into_iter().map(String::from) // shorthand map syntax if one arg, compiler infers params

foo.iter().for_each( |x| println!("{x}") )  // for each side effects, executing on the iterator
foo.iter().for_each( |x| x + 1 )  // fails compile, for_each must return a unit (), so last line is staetment, not expression
```
- adapters - `Iterator`s that return `Iterator`s, main examples: `map`, `filter`, `enumerate`, `take`, `zip`, `flatten`, `chain`
    - slice has `windows` but `Iterator` doesn't
        - `(1..10).collect::<Vec<usize>>().as_slice().windows(3).for_each(|i| println!("{:?}", i));`
- consumers - methods that consume `Iterators`, e.g. `collect`, `fold`, `reduce`, `sum`, `all`, `any`, `max`, `min`, `count`, `find`
- unrolling - means to flatten a loop, compiler does this optimization often if it's a small number of known iterations
    - e.g. `for i in (1..5) { ... }`
### CONTROL FLOW
```rust
// IF STATEMENTS
if n == 1 {
    "one"
} else if (n == 2) {
    "two"
} else {
    "other"
}

// LOOP
outer: loop {
    println!("Entered the outer loop");
    'inner: loop {
        println!("Entered the inner loop");
        // This would break only the inner loop
        //break;

        // This breaks the outer loop
        break 'outer;
    }
    println!("This point will never be reached");
}

// WHILE
while n < 10 {
    n += 1;
}

// PATTERN MATCHING
let number=100;
let num2=3;
match number {
    1 => println!("One!"),                              // Match a single value
    1 if num2 == 3 => println!("One!"),                 // can take guard statements
    2 | 3 | 5 | 7 | 11 => println!("This is a prime"),  // Match several values
    13..=19 => println!("A teen"),                      // Match an inclusive range
    _ => println!("Ain't special"),                     // Handle the rest of cases
}

// match on many items
let astr: String = String::from("hi");
match (number, astr) {
    (1,"foo") => println!("match"),
    _ => println!("default"),
}

// Match can be used to destructure a tuple
let triple = (0, -2, 3);
match triple {
    (0, y, z) => println!("First is `0`, `y` is {:?}, and `z` is {:?}", y, z), // Destructure the second and third elements
    (1, ..)  => println!("First is `1` and the rest doesn't matter"),
    (.., 2)  => println!("last is `2` and the rest doesn't matter"), // `..` can be used to ignore the rest of the tuple
    (3, .., 4)  => println!("First is `3`, last is `4`, and the rest doesn't matter"),
    _  => println!("It doesn't matter what they are"),  // `_` means don't bind the value to a variable
}

// a `!` return type means the func never returns
fn neverreturn() -> ! { panic!("no return") }   // panics dont return
fn neverreturn() -> ! { loop{}; }    // infinte loop will never return
```
### VISIBLITY/SCOPE
- all things are private by default and can be made public with `pub` keyword
    - public items can be used by anything in the crate
    - a struct/enum can be marked public, but fields are still private unless fields are declared public
- private items are only visible in the current module and decendant modules


## REFERENCES/OWNERSHIP
- references are a "pointer" to data, and in rust they also mean borrowing the data from an owner
- 2 main rules of references
    - a owner can lend out one mutable reference
    - a owner can lend out multiple immutable references
    - can _not_ lend out a mutable reference and an immutable reference
- dot operator is smart to convert to/from reference/pointer types: https://doc.rust-lang.org/nomicon/dot-operator.html
    - this makes using smart pointers like `Box<T>` easy to use as methods on `T` can basically be called on `Box<T>` 
- Dereference coersion - convert a type that implements `DeRef` into a reference when passed in as func param
    - e.g. `String` implements `DeRef` and `deref` method produces `&str` so a `&String` can be passed into a arg of type `&str`
    - multiple nested `DeRef` types be called, e.g. `Box<String>>` passed into arg taking `&str`
        - `Box<String>` derefs to `String`, `String` derefs to string slice `&String`, `&String` derefs to `&str`
    - `let m = Rc::new(vec![1,2])` -> `m.len()` is same as `(*m).len()`, `m` gets deref'd b/c dot(`.`) operator derefs it's receiver
- why aren't multiple mutable references allowed in a single threaded context
    - https://manishearth.github.io/blog/2015/05/17/the-problem-with-shared-mutability/
        - example 1 - 2nd mut ref to insides of variants' insides could be invalid when 1st mut ref of enum changes base variant
        - example 2- iterator can be invalid
            - `let buf = vec![1,2,3,4]; for i in &buf { buf.push(i); }` - loops forever
    - https://www.reddit.com/r/rust/comments/95ky6u/why_arent_multiple_mutable_references_allowed_in/
- `Box<T>` - pointer to heap allocated data, single ownership and can mutate contents
    - implements `DeRef` and `DeRefMut` so can be used as reference, mutable too
    - implements `Send`, so can tx ownership to a different thread
    - can create recursive types using Box: e.g. `enum E { Nil, Cons(i32, Box<E>) }`, or `struct S { a: i32, b: Option<Box<S>> }`
    - can "unbox" by just derefing: `let b = Box::new(1); let i = *b;`
        - does a deref and move really
            - see https://stackoverflow.com/questions/33653946/dereferencing-boxt-gives-back-value-instead-of-reference
- `Rc<T>` - reference counter heap allocated data, multiple ownership, tracks # of references, and cleans up when count is zero
    - it is only used for single-threaded scenarios
    - it's immutable for same reason as borrow rules allowing one mutable reference, prevent data races/inconsistencies
    - you could use references, but that requires specifying lifetimes and might mean tons of data lives for long unneccessary times
    - implements `DeRef` but not `DeRefMut`, so can't mutate it's contents, read only
    - doesn not implement `Send`
    - usage `let a = Rc::new(1); let b = Rc::clone(&a)`
        - can also do `let b = a.clone()` but not idiomatic, `Rc::clone` wont deep-copy
        - get count `Rc::strong_count(&a)`
    - danger is mixing `Rc` and `RefCell` to create circular references that leak memory
    - can create weak references, `Weak<T>` with `Rc::downgrade`, weak refs dont increment "strong" count, inc the "weak" count
        - weak ref might point to nothing, so test it with `upgrade` method which returns `Option<Rc<T>>`, `None` if it was dropped
- `UnsafeCell<T>` - `RefCell<T>` with no guard, gives you mutable raw pointer/ref without any safety checks
- `Cell<T>` - can replace `T` and get a copy of `T`, but can't get a reference to `T`
- `RefCell<T>` - has interior mutability, unlike `Cell` can get a reference
    - single ownership like `Box<T>`, except borrowing rules checked at runtime, will panic if borrow rules violated
    - uses `UnsafeCell` like `Cell`
    - `let r = RefCell::new(1); *r.borrow_mut() = 2`
    - `let r = RefCell::new(1); let r1 = r.borrow_mut(); let r2 = r.borrow_mut(); *r1 = 2; *r2 = 3`
        - will panic in runtime!, no comile time error
- taking ownership from struct field - can use `Option::take` or `std::mem::replace`
    - see https://users.rust-lang.org/t/how-to-take-ownership-of-a-field-of-uniquely-borrowed-struct/16169
- swapping ownership with `std::mem::swap` - `let mut x=1; let mut y=2; std::mem::swap(&mut x, &mut y)`
### LIFETIMES
- references are tracked by lifetimes and lifetime annotations are needed in cases in order to help the compiler/borrow-checker
- a parameters with an annotation has a input lifetimes, a return values have output lifetime
- output lifetimes cant outlive input lifetimes, that's a dangling pointer/reference
- `'static` lifetime means reference lives for the entire duration of program
- lifetime elision rules are cases where lifetime annotations are not needed because the compiler can infer them correctly
    - 3 main rules to determine if no lifetime annotations are needed on func/method
        - multiple inputs each get a different lifetime parametes
        - if only one input then the output gets the same lifetime
        - if multiple inputs and one is `&self` or `&mut self` then output get the lifetime of `self`
- variance relationships - https://doc.rust-lang.org/reference/subtyping.html
    - jon gjengset on variance - https://www.youtube.com/watch?v=iVYWDIW71jk&t=4953s&ab_channel=JonGjengset
- `Cow<T>` - Copy-On-Write "pointer", stores a &%, and can convert by cloning the T when you write to it
### UNSAFE
- raw pointers - `*const` and `*mut`
    - can only dereference raw pointers in unsafe blocks
    - can have any number of immutable and mutable pointers at same time
    - raw means they can be null, point to invalid mem locations, no automatic cleanup
    - `let address = 0x012345usize; let r = address as *const i32;` - random mem location, cast it to raw pointer
    - usage scenarios: 1. interface with C code, 2. some safe abstractions that borrow checker can't understand
- unsafe functions
    - must delcare function unsafe, and can only invoke unsafe function in unsafe block
- extern functions
    - FFI(foreign function interface) to interact with non-rust code
- static variables that are mutable - unsafe in a multi-threaded scenario


## TYPE SYSTEM
- no exception handling, (`panic` doesnt count), `Result<T, E>` is commonly used to return errors as values
- no `null` concept, use `Option<T>` for similar uses in langs with `null` concept
### PRIMITIVES
- primitive integers 
    - `i32` - signed 32bit integer, `u64` unsigned 64bit integer
    - also 8,16,32,64,128 bit sized integers supported
    - can explicitly declare a integer literal as such: `let a = 42i64` - number `42` as a `i64`
### STRUCT
- very similar to C/C++/golang structs
- e.g. `struct Foo{ i: i32, b: bool, s: String }`
- tuple struct:  struct witih no field names, e.g. `struct Bar(i32, bool)`
### TUPLE
- https://doc.rust-lang.org/std/primitive.tuple.html
- `let a = (1, "hi"); let secondfield = a.1;`
### ARRAYS
- is a primitive type, cannot change size
- function argument type annotation: unsized `[T]`, sized `[T; 3]`
- indexing starts at zero, e.g. `a[0]` is first element
- stored in contiguous sections of memory on the stack
    - if array is too large, at runtime will get stack overflow
- len/size
    - `a.len()` - get length
    - `mem::size_of_val(&[1,2]))` - get num bytes in memory
- `let a = [ 1, 2 ]` - declaration
    - example type annotation declaration `let xs: [i32; 5] = [1, 2, 3, 4, 5];`
    -  initialize size 500 array with value zero - `let ys: [i32; 500] = [0; 500];`
- multi-dimensional arrays, e.g. 2D array 6x4 i32: `let a: [[i32; 4]; 6];`
    - slices need to specify subarray: `let sliceofa: &[[i32; 4]] = &a;`
### SLICES
- like arrays but size not known at compile time, it's a kind of reference
- 2 word object: 1st word is pointer to data, 2nd word is length of slice (word size = usize)
- allows us to borrow arrays, vec supports it too
- type signature `[T]`, shared/immutable type signature `&[T]`, e.g. `&[i32]`
    - term "slice" is overloaded: almost always means `&[T]`, a fat pointer(address + len), not `[T]`
    - "naked" `[T]` has unknown size, can't put it on the stack, use pointer redirection like `Box<[T]>` or `Rc<[T]>` or `&[T]`
- mutable type signature `&mut [T]`
- `let a = [1 ,2, 3, 4]; let s = &a` - `s` is a reference and immutable borrow here, `&a` is slice containing all of `a`
    - `let s = &a[0..2]` - borrow just first and second of `a`, ending index is non-inclusive
### CONSTANTS 
- contants, `const` keyword - cannot be mutable, type must be annotated, can declare in global scope
    - can use constant expressions, but not expression that evaluate at runtime
    - naming convention is to use upper snake case
    - `const MY_CONST: i32 = 1; const CONST_EXP: i32 = 10 * 10 * 3600;`
- static, similar to `const` but can be mutated, lives in a static memory space, have static lifetime (so forever)
    - type must have `Sync` to be shared for multi-threaded access
### GENERICS
- rust doesnt have higher kinded types, e.g. something like `Option<V<T>>` with `V` and `T` as generic params
- Monomorphization: generics are expanded and defined for each type used at compile time, so no perf hit for using generics
    - this is similar to how c++ templates work
### TRAITS
- follows orphan rule
    - cannot implement _external_ traits on _external_ types
    - **can** implment _internal_ trait on _external_ type and _external_ trait on _internal_ type
    - without rule, 2 crates could implement same trait on same type, this is a conflict and rust wouldnt know which to pick
    - newtype pattern can get around orphan rule, by creating a new type in a tuple struct
- blanket implementations - conditionally implement a trait for all types that implement another trait (using generics)
    - `impl<T: Display> ToString for T { // --snip-- }`  - from stdlib, this implements `ToString` if `T` implements `Display`
- auto traits - https://doc.rust-lang.org/beta/unstable-book/language-features/auto-traits.html
    - e.g. Structs, enums, unions and tuples implement the trait if all of their fields do.
    - Function item types and function pointers automatically implement the trait.
    - `&T` , `&mut T` , `*const T` , `*mut T` , `[T; n]` and `[T]` implement the trait if `T` does.
    - `Send`, `Sync`, `Unpin`, `UnwindSafe` are all autotraits
- **TRAIT OBJECT** - a wrapping type that contains anything that implements the trait
    - generally use a fat/smart pointer and the vtable of methods
    - for trait `Trait`, `Box<dyn Trait>` is a trait object
        - even a ref, `&dyn Trait` is a trait object
    - compiles to single function that does a dispatch at runtime based on the object concrete type
    - cannot create trait object for more than one trait directly: `&(dyn Trait1 + Trait2)`
        - the way to achieve this is using a supertrait: `pub trait Trait1and2: Trait1 + Trait2 {}`, then `&dyn Trait1and2`
        - compiler _could_ create a combined vtable of both traits, or fat pointers get fatter for each vtable, but supertrait works
    - assoicated type traits wont work unless u specify a default `&dyn Trait1<assType = SomeType>`
    - non-self types dont work, need a receiver, so no associated methods
    - traits with generics dont work, vtable cant really store which concrete type the generic represents
        - you could have diff vtables for diff combinations of types in each crate, but now you have many diff vtable implementations
    - vtable for trait object always implements `drop`(from `Drop`), needed for GC
        - size and alignment of concrete type in vtable (allocator needs this for `drop`)
- generic traits can specify a default concrete type with `<T = DefaultConcreteType>`
- associated type - a placeholder type that must be defined by the implementing struct/enum
    - e.g. the `Iterator` trait has a `Item` associated type. the implmentors specifies this as what it's `next` method returns
    - why not generic trait? - can implement the trait many times (per generic param)
        - with associated type we can only implement trait one time
- supertraits - defining a trait to depend on implementor implementing another trait
    - `trait SuperTrait: Trait { ... }` - implementor must implement `Trait` here before implementing `SuperTrait`
    - concept is similar to trait bounds on generics
- fully qualified syntax - use to disambiguate when same method name in different traits or direct impl
    - types direct implementation takes precedence
### CONVERSION/CASTING
- `as` keyword used to turn primitive types (e.g. `i32`, `char`, `bool`) into other primitive types
- `From` and `Into` are main traits to convert, `From<T> for U` implies `Into<U> for T`
    - complex types like `Vec` and `String` support this
    - correct practice is implement `From<T> for U`, `Into<U> for T` blanket implementation will be done
- `TryFrom` and `TryInto` exist for conversions that could fail, and return `Result` type
- `AsRef` and `AsMut` convert reference types
### ENUM
- in rust is really a tagged union or algebraic sum type, in many other languages it's a thin layer on a list of integers
```rust
enum E {
    Foo,
    Bar(i32, usize),            // variant can have fields
    Yar{ f1: i32, f2: string }   // a variant can be a embedded struct, and have field names
}
```
### OTHER
- `union` - like struct, but all fields share the same storage, size of union type is size of largest field
- `Option<T>` - generic enum which can be `Some<T>` or `None`
    - `unwrap_or(x)` -> retrieve value `T` if `Some<T>`, if `None` return `x`
- `Result<E, T>` - generic enum which can be `Err(E)` or `Ok(T)`
    - `unwrap` - panic if `Err`, `expect('failure!')` - panic if `Err` with message
    - `unwrap_or(x)` -> retrieve value `T` if `Ok<T>`, if `Err` return `x`
    - `unwrap_or_else(|err| ...)` - error handler func if `Err`
    - propogate errors to caller with `?` operator
- `Sized` - trait, known size at compile time, doesnt change size
     - data put on stack _must_ be `Sized`, un-`Sized` have to go on the heap
     - for enums compiler uses size of largest variant
     - it's automatically implemented for types whos size is known at compile time, very few types are not `Sized`
- structs and values in generally are placed on stack by default, general way to heap alloc is pointer wrappers like `Box` or `Rc`
- COPY vs MOVE semantics
    - a move is moving ownership
    - if type has `Copy` follows "copy" semantics, as opposed to "move" semantics
        - value is copied and not moved when assigned to new variable or passed into a function
        - e.g. `x = 1; y = x` (`y` is a copy of `x` with value 1, no ownership transfer)
    - if moved, compiler might copy the bytes, depending on the situation
- `Copy` - trait
    - value can be safely copied, i.e. `memcpy` used, so direct bit by bit copy
    - have a known size, and allocated on the stack, happens implicitly e.g. `x = y`
    - cannot be implemented on `Drop` types, `Drop` types are basically owned types
    - primitive types are `Copy`: `i32`, `char`, `bool`, references themselves like `&T` and `&mut T`
        - arrays `[T; N]` are `Copy` type too if elements if `T` is `Copy` type
        - tuples `(T1,T2,...,Tn)` if all fields of a tuple are `Copy` tuple is also `Copy`
    - `Clone` types more complex and general, a `Copy` type can probably easily also implement `Clone`
        - it's a trait and implementation can be arbitrarily complex to create a new `T`
- `Drop` trait, types that drop/free when they go out of scope, so need ownership tracking
    - deallocating at end of scope is similar to RAII(resource aquisition is initialization), used in c++
    - compiler will essentially insert the `drop` on a `Drop` type at the end of it's scope
    - trait has one method `drop` that you can't call explicitly on a `Drop` type
        - otherwise compiler cant gaurantee memory safety, double drops or dangling pointers
    - for manualy drop you can call `std::mem::drop`, e.g. `drop(somevar)`
- associated function - belongs to the type itself, doesn't need `self`, the `new` method convention is a common use case of this
- variance - https://doc.rust-lang.org/nomicon/subtyping.html
- type alias - synonymous to another type
    - one use case: syntax sugar convenient for long/verbose types
        - e.g. `Box<dyn Fn() + Send + 'static>` aliased as `type Thunk = Box<dyn Fn() + Send + 'static>`
- rust does not really support downcasting (can't `match` on a trait object's implementor types)
    - traits objects can't be downcast back to the original type with casting or coersion
    - the `Any` trait with `unsafe` code can do this, it's downcasting on trait objects
    - one idomatic way is to use `enums` variants in place of the trait implementors
- for `trait Trait {}`, a param of type `impl Trait` is basically syntax sugar for generic with trait bound `<T: Trait>`
    ```rust
    trait Trait {}
    fn foo<T: Trait>(arg: T) { }

    fn foo(arg: impl Trait) { }
    ```
    - generic with trait bound will have a concrete type at compiletime due to monomorphization
    - trait objects contain concrete type only known at run time
    - big use case for trait objects is a array/vector/collection of heterogenous concrete types, can't do that with a generic trait
- DST - dynamically sized types - https://doc.rust-lang.org/nomicon/exotic-sizes.html
    - types can only exist behind a fat/wide pointer
    - main cases of DST
        - trait objects `dyn MyTrait` -> "wide" pointer has pointer to data and pointer to vtable
        - slices(`[T]`), `str`
        - structs can store a DST in a field `struct foo { a: [i32], b: u32 }`, making the struct DST itself
    - vtable - each vtable for a type generally built at compile time
### OPERATORS
- bitwise ops: `&` bitwise AND, `|` bitwise OR, `^` bitwise XOR
    - only some types support it, e.g. integer types like `i32`, `u32`, etc
- `?` - https://doc.rust-lang.org/reference/expressions/operator-expr.html#the-question-mark-operator
    - postfix operator for `Result<T, E>`, or `Option<T>`
    - essentially returns the error if an error occured and also calls `From::from` to convert


## DATA STRUCTURES
- https://doc.rust-lang.org/std/collections/index.html
- may2023 - good vid on collections - https://www.youtube.com/watch?v=EF3Z4jdD1EQ&list=WL&ab_channel=JonGjengset
    - many collections need to use unsafe code(raw pointers) in order to be feasible/performant
    - borrow checker couldnt reason about it well
- rust has many ADTs that languages like haskell provide: tuples, enums(tagged unions), structs(product types)
### STRINGS
- use double quote `"` for strings, single quotes `'` for chars
- raw string literal (escapes arent processed) - `r#"foo \n bar"#`
- `s = "\x52\x75"` - `\x` escape for hex code byte value
- `String` and `&str` are UTF-8
- string literals (preallocated text) - declared in code like `let s = "string lit"`
    - are refered to with string slices (also immutable reference) `&str`
    - they are stored in a special read-only memory of executable
- `String`
    - is a heap-allocated `Drop` type, it's mutable/growable
    - `lines` - split string by `\n` or `\r\n` as delimiter, then create iterator
    - it's really a wrapper around a `Vec<u8>` of bytes
    - indexing/iterating
        - you cant index (`s[1]`) because it's confusing/ambiguous, for UTF8 is it byte value? character value? grapheme cluster value?
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
### VECTORS
- essential a struct with 3 properties: capacity, length, and pointer to base
    - generally vector struct on stack, and data in heap
- are mutable heap allocated arrays: `let a = vec![1 2]`
- stored in a contiguous section of memory
- initialize `Vec::with_capacity(n)`, for large n, instead of `new`, if you know u will push tons of items
    - this avoids a lot of copies and allocations
- it implements `Debug`, but not `Display`, and can be printed with `let v = vec![1, 2]; println!("{v:?}");`
- `let v = vec![1,2,3]; v[4]`, index out of bounds will panic, `v.get(4)` returns Option, `None` if out of bounds
- `VecDeque` - basically a ring buffer that uses a beginning and end pointer
    - good for queues and stacks, esp queue, u can append to beginning without having to move all items in array
    - overhead: gotta check if at end of allocation and wrap when indexing
    - disadvantage: cant turn into slice (no `DeRef` into slice), slices needs to be contiguous memory
    - disadvantage: cpu's do memory readahead optimizations for things like loops, and they dont know the ring buffer's termination
### HASHMAP
- `HashMap<K, V>` associative arrays, heap allocated
    - `K`, `V` are generic types, key and value must be one type (homogenous)
    - no macros to build them
    - backed by a vector with buckets and linear probing
    - 2016 reddit post on hash - https://www.reddit.com/r/rust/comments/52grcl/rusts_stdcollections_is_absolutely_horrible/
    - linear probing: for insert, if bucket is taken compute hash with occupying key + insertion key, goto that bucket, repeat till vacancy
        - newest imp uses `hashbrown::hash_map` crate (invented by google, called SwissTable, uses quadratic probing and SIMD, very fast)
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
     for (key, value) in &scores { println!("{key}: {value}"); }

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
### LINKED LISTS
- std lib has it, but linked lists are generally dumb: https://rust-unofficial.github.io/too-many-lists/
    - linked lists are slow, even insertion/deletion are slower than array! worse as N gets bigger
        - the linear search through linked list dominates slowness, and for array moving n/2 items is not that slow (caches good at this)
    - see c++ founder - https://www.youtube.com/watch?v=YQs6IC-vgmo&ab_channel=AlessandroStamatto
- to do a doubly linked list with `Rc`, you'll want one to be a weak counter so you don't get cyclical references
    - see https://doc.rust-lang.org/stable/book/ch15-06-reference-cycles.html#preventing-reference-cycles-turning-an-rct-into-a-weakt
- dropping a linked list is tricky w/o incurring a stackoverflow for recursive drop calls (c++ has same issue)
    - general solution is to write a drop that loops, can make use of `std::mem::replace`
- my example of building a singly linked list 100 nodes long
    ```rust
    struct LL { data: i32, next: Option<Box<LL>> }
    let mut l = LL { data: 1, next: None }
    let mut lref = &mut l;
    // NOTE: the `as_mut` on next is key, it gives me a ref to what's inside Box, an `unwrap` on Option would move and error
    for i in (1..100) { lref.next = Some(Box::new(LL{data: i, next: None})); lref = lref.next.as_mut().unwrap(); }
    ```


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
- `fn` is type, a function pointer, that refers to named fuctions, `Fn` is trait for closures
    - e.g. `fn f1(i: i32) -> i32 { i }; fn twice(f: fn(i32) -> i32) -> i32 { f(1); f(1) }`
    - `fn` pointers all implement `Fn`, `FnMut`, and `FnOnce`, so can pass `fn` to something expecting a closure
        - can also pass a closure that doesn't capture it's environment into a `fn`
        - can vary based on ABI, e.g. `extern` type, e.g. external C function: `extern "C" fn()`
- every function is a seperate type, a var cant hold another fucntion with same signature, need to use func pointers `fn` for indirection
    ```rust
    let mut f = |x: i32| -> i32 { x + x }
    f = |x: i32| -> i32 { x }           // compiler error!, will get `note: no two closures, even if identical, have the same type`

    let mut f2: fn(i32) -> i32 = |x: i32| -> i32 { x + x }
    f2 = |x: i32| -> i32 { x }           // this works
    ```
### CLOSURES
- are anonymous functions that can capture their environment
    - really are anonymous structs that have members which are references to the captured values and an anonymous function
- compiler auto-implments each closure into 3 traits
    - `FnOnce`- can only be run once, basically if ownership is transfered, aka moved out of it's environment
        - all closures can be called at least once so they all implement this
    - `FnMut` - will mutate captured values, dont move them
        - e.g. trait `Iterator`'s method `map` takes a `FnMut` closure, b/c a closure is called many times on a collection
    - `Fn` - will only read captured values, dont move them, or dont even capture values from env
- they are traits and traits are compiled to be statically allocated, so closures dont dynamic dispatch, they are static dispatch
- if a closure implements `Fn` it will also implement `FnMut` and `FnOnce`, if closure implements `FtMut` it also does `FnOnce`
- so a function that takes a `Fn` closure as an argument, compiler would error if a `FnOnce` or `FnMut` closure was passed in
- a named function also implements all these three as well
     - e.g. an `Option<Vec<T>>` could call `unwrap_or_else(Vec::new)`
```rust
let closure_annotated = |i: i32| -> i32 { i + outer_var };    // with annotations
let closure_inferred  = |i     |          i + outer_var  ;    // inferrerd types
let one = || 1;         // closure takes zero args, single line expressions dont need curly braces
```
- dont have concrete type that are returnable, can use dyn Box, e.g. `Box<dyn Fn(i32) -> i32>`

## IO
- read a file to var - `let contents = std::fs::read_to_string(file_path).unwrap()`
- incremental read - `let f = File::open(file_path)?; let reader = BufReader::new(f); for line in reader.lines() { ... }`
- `eprintln!` is macro to print to stderr
    - `println("{:b}",3)` - `:b` binary format, this prints`11` , `:o` octal `:x` hexadecimal
- `print!` - same as `println!` but no new line
```rust
let num = 0b0000000000101100u16;
println!("{:?}", num);    // prints 44  , "?" uses Debug trait
println!("{:0b}", num);    // prints "101100",  "b" means Binary trait
println!("{:0x}", num);    // prints "2c",  "x" means LowerHex trait
println!("{:0e}", num);    // prints "4.4e1",  "e" means LowerExp trait
```
- fill/alignment padding https://doc.rust-lang.org/std/fmt/#fillalignment


## CONCURRENCY
- rust itself(lang/runtime) only implements native threads
- no green thread system (e.g. goroutines in golang)
    - the tried green threads in rust 1.0, but runtime was becoming bloated
- rust intention is to stay a low level systems language with minimal runtime
- https://stackoverflow.com/questions/29428318/why-did-rust-remove-the-green-threading-model-whats-the-disadvantage#29430403
- good tokio issue on structured concurrency: https://github.com/tokio-rs/tokio/issues/1879 (also see "goto is bad" blog)
- good book on rust atomics/locks: https://marabos.nl/atomics/
- 2022 - issue tracker - make std lib mutex/rwlock/condvar better (use parking_lot) - https://github.com/rust-lang/rust/issues/93740
### SYNC + SEND
- `Sync` and `Send` are built into rust, (most of the rest is in std lib)
- `Sync` trait, these types allows many references to same value in different threads
    - type `T` is `Sync` if immutable ref `&T` is `Send`
    - generic parameters need to be `Sync` for container type to be `Sync`
- `Send` trait, these types are safe to transfer ownership to different thread
- `Mutex`, `RWLock`, and `Atomic`s are `Sync` type
- `Mutex` itself is `Send`, but the `MutexGuard` is not, same thread that locks must unlock
    - `MutexGuard` is sync b/c a shared ref in another thread cant do anything harmful
    - a `Mutex` is poisoned when a thread holding it panics, now other threads cant unlock it
- `Rc` isn't `Send`, can't have 2 `Rc`'s in 2 threads, must be in one thread
    - also not `Sync` b/c a shared ref can be cloned
    - use `Arc<T>` (atomic ref counter) if sharing b/w threads, it's `Sync` + `Send` if `T` is
- `Cell` and `RefCell` are `Send` but not `Sync`
    - with a shared ref, u can mutate interior, not safe in multiple threads
### THREADS - STD LIB
- `let handle = thread::spawn( ... )` method to create new thread, takes a closure arg
    - `handle` is type `JoinHandle`, can call join `handle.join()`, which blocks to wait for completion
    - if a handle is dropped, it _detaches_ and drops only the handle "reference", the associated thread still runs
    - compiler is conservative, and captured vars in the closure are borrowed, not moved by default
    - use `move` to transfer ownership, `thread::spawn(move ...)`
- `thread::sleep(Duration::from_millis(1))` - sleep for 1ms
### FUTURES/ASYNC
- 2016 great blog by aaron turon on async design for rust - https://aturon.github.io/blog/2016/09/07/futures-design/
    - struggle to make zero-cost, (no dynamic dispatch) async features
    - couldnt do "completion-driven" zero-cost (no allocations), but could do "readiness-driven"
    - defines task as a future that is being executed
    - e.g. socket I/O, register a task to event loops dispatch table to wake task when socket ready and then can be re-polled
        - task stays "fixed", this apparently requires no allocations to install this callback to the event loop
    - in this readiness-driven model we get cancellation and backpressure for free
- run many concurrent tasks on a small number of OS threads
- `Future` are inert - the make progress only when polled by `await`
    - can create a `Future` in sync code, but can only `await` a `Future` if it's in a `async`(`Future`) function itself
        - i.e. top level `main` function in the thread has be `async` (and basically an executor to poll it)
- zero cost - can use them without heap allocation or dynamic dispatch
- `async`/`await` keywords introduced in 2018 edition, it returns a `Future`, `Future` trait defined in std lib
    - `async fn() -> T { ... }` is basically `fn() -> Future<T> { async { ... } }`
    - executor runs Futures to completion, will "poll" future to make progress
        - tokio `spawn` gives future to executor to schedule
    - future has a "wake" callback func to let executor know when it's ready to be polled
- async-book - https://rust-lang.github.io/async-book/01_getting_started/04_async_await_primer.html
- jon gjengset good vid - https://www.youtube.com/watch?v=ThjvMReOXYM&t=7819s&ab_channel=JonGjengset
- https://docs.rs/futures/latest/futures/
    - cooperative multitasking, tasks, `Futures` (await points) yield at points to let others run
        - versus bare threads, which are preemtive, OS is responsible stop/schedule them, bare threads dont have "yield" points
    - Futures run on some executor, there are many types, single-threaded, multi-threaded, etc.
    - calling blocking operations like read from a regular file or network socket might block, need to use async versions of those
        - e.g. tokio has async version of all these IO operations
- Futures are similar to javascript promises or scala future
    - scala futures are eager, cant be cancelled, use a callback style (like javascript promises) with `map`/`flatMap`
    - reddit post on scala futures vs rust async - https://www.reddit.com/r/scala/comments/f9o4gq/rust_vs_scala_futures/
- rust's Futures themselves dont depend on thread locals, tokio does use it in order to get runtime context
- **FUTURE** internal representation
    - futures contain a "state machine", each state being a chunk of work seperated by an await
    - each chunk/state contains all it's state data, this includes local vars that need to be kept across await points
        - they can't be on the stack, b/c awaits are like returns
    - compiler generally creates a structs/enum definitions for each future and it's child futures
        - this call tree of cobbled futures allows for one big allocation of known size
    - a task is root level structure that a future belongs to
        - a executor will place a task on the run queue to be polled when a child future is awoken
    - so no stack is needed, all state info within Future type itself
- recursion is an issue b/c this statemachine like struct would refer to itself, causing the infinite size type issue
    - can get around this with indirection like `Box` or `BoxFuture`
- async traits are hard b/c Futures don't have a known size
    - future can have all sorts of data and that makes their size unkown
- if a `Future` holds non-`Send` data(e.g. `Rc`) then it cant be moved to another worker thread in executor
- stacktraces - trace will show origin upon the thread it's executing on, this might be different than thread that spawned it
- std lib `Mutex` will block thread if it cant aquire lock, deadlock risk here, so best to use when critical section is short
    - otherwise use async mutex like tokio mutex, which dont block thread, but async mutex have higher overhead
- `select!`, sortasimilar to golang `select`, it runs many futures concurrently
    - the first future that completes will execute it's cases' code, and `select!` block finishes without waiting for other futures
    - `default` -> case runs if no futures are ready
    - `complete` -> if all futures are completed, this runs
- `future::ready(1)` -> completed future, similar to scala `Future.complete(1)`
### CHANNELS
- in std lib - one way thread safe "pipes"
- multiple producers single consumer (mpsc), `let (tx, rx) = mpsc::channel()`
    - `let val = String::from("hi"); tx.send(val).unwrap()`
        - send returns `Result<T, E>`, will error if reciever dropped
        - sending a val transfers ownership, the receiver will take ownership
    - `let r = rx.recv().unwrap()` - get error if transmitter dropped, otherwise blocks until it gets a value
    - use `try_recv` for non-blocking, returns `Result<T, E>` immediately
    - `let tx2 = tx.clone()` - create a second producer
- channel closed if receiving or sending side is dropped
#### SYNC WAIT GROUP
- like golang WaitGroup
- std lib and tokio also has Barrier https://doc.rust-lang.org/std/sync/struct.Barrier.html
- crossbeam waitgroup: https://docs.rs/crossbeam/latest/crossbeam/sync/struct.WaitGroup.html
### LOCKS
- 2022 - PR on making locks/condvars better: https://github.com/rust-lang/rust/issues/93740
    - discussion to use parking_lot, use futex on linux/BSD
- std lib `RWLock` - allows one writer OR multiple readers (not both)
    - Tokio and parking_lot libs have RWLocks that are write-preferring
- std lib `Mutex` - allows one writer OR one reader
- `Condvar` - conditional variable, used to block a thread until a event happens
    - takes a mutex guard
### SEMAPHORES
- issue limited "permits" to do things, can limit concurrency level
- tokio has sempahores

## MEMORY
### ATOMICS AND MEMORY ORDERING
- good read: https://doc.rust-lang.org/nomicon/atomics.html
- `AtomicUsize` - `fetch_update` - really compare_exchange loop that tries to apply the closure
- memory model for atomics from c++20
### PIN
- `Pin` types prevent data from being moved in memory unless type implements `UnPin`
- one prime use case is `Future`s, some Future types need pinning, the ones that don't can implement `Unpin`

## ANNOTATION
- `derive` - tells rust to automatically generate a trait implementation for a type
- `inline` - annotation inlines function
- `#![allow(dead_code)]` - top level, ignore warnings about unused funcs/vars/code
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


## STD LIB
- `std` relies on OS primitives
- `core` relies on nothing
- `alloc` requires on a memory allocator
    - most collections in this crate, except hashmap which relies on random data, so its in `std`

## LIBS/FRAMEWORKS/APPS
- [mio](https://github.com/tokio-rs/mio) - low level lib for OS non-blocking IO API
    - basically rust's version of libuv, which offers abstractions of big IO APIs like epoll, kqueue, iocp
- [tokio](https://tokio.rs) - awesome async framework, built on mio
    - core of it is it provides an executor/runtime for rust Futures to run on
    - main component of runtime: I/O event loop (reactor), task scheduler/runner (executor), timer
    - has async version of tons of stuff, e.g. file handling, tcp/udp streams, channels, mutexes, timeouts, sleeps etc.
        - tokio mutex - yields instead of blocks if lock cant be aquired, however more expensive than std mutex
    - `#[tokio:main]` just creates a `tokio::runtime::Runtime` and `block_on` top level Future (`async fn main{ ... }`)
        - see https://docs.rs/tokio/latest/tokio/attr.main.html
    - `let t = tokio::runtime::Runtime.new().unwrap()` - create a runtime
        - `t.spawn(async { ... })` - pass future to a tokio runtime/executor
        - `let handle = tokio::runtime::Handle::current();` - get current runtimes handle
    - `let t = Builder::new_multi_thread().worker_threads(4).thread_stack_size(10 * 1024).build().unwrap()` - build manually
    - `let future_handle = tokio:::spawn(async { ... })` - pass future to tokio runtime/executor in current thread context
        - *NOTE* future is polled in executor even if you dont await the handle
    - `tokio::task::spawn_blocking(|| { ... })` - run blocking closure on special threads on runtime for blocking
    - graceful shutdown - pass a mpsc sender to all tasks, when all senders dropped, all tasks are done, can shutdown
- [tokio console](https://github.com/tokio-rs/console) - awesome TUI for diag/debug tool for tokio
- [async-std](https://github.com/async-rs/async-std) - async version of std lib, similar to tokio
- [crossbeam](https://github.com/crossbeam-rs/crossbeam) - concurrency toolbelt
- [parking lot](https://crates.io/crates/parking_lot) - better mutex/rwlock/condvar
- [hyper](https://hyper.rs/) - popular http client lib (and server lib), dep on tokio
- [reqwest](https://github.com/seanmonstar/reqwest) - simpler http client lib, dep on tokio
    - http cli tool `xh` uses reqwest
- [rocket](https://rocket.rs/) - most popular rust backend web framework, uses async/await w/tokio
- [actix](https://actix.rs/) - popular web framework, uses actor model, uses async/await w/tokio
- [axum](https://github.com/tokio-rs/axum) - popular web framework, uses tower/tokio, uses async/await
- [serde](https://serde.rs/) - awesome defacto serial/deserialization framework
    - `Serializer`/`Deserializer` traits define how parse data into/out-of the serde data model
        - deserialization uses the visitor pattern, centered around the `Visitor` trait
    - `Serialize`/`Deserialize` traits defined on struct to convert from/into any serde data model
        - `Serialize` muse use methods on `Serializer` (same for `Deserialize` and `Deserializer`)
- [rayon](https://docs.rs/rayon/latest/rayon/) - lib for making sequential computations parralel (e.g. parrallel iterators)
- [yew](https://yew.rs) - /awesome front end framework (compiles to webassembly)
    - similar to react architecture, has the conecpt of components
    - generally faster than react!
    - uses a `html!` macro to generate valid html at rust compile time!
- [tauri](https://tauri.app/) - build native apps for desktop and mobile
- [pprof](https://github.com/tikv/pprof-rs) - good profiler, flame graphs, like golangs pprof
- CLI
    - [clap](https://docs.rs/clap/latest/clap/) - awesome CLI argument parser lib
    - [ratatui](https://ratatui.rs/) - TUI builder lib
    - [crossterm](https://github.com/crossterm-rs/crossterm) - lib for ANSI codes
    - [termcolor](https://github.com/BurntSushi/termcolor) - good ANSI termical color lib
    - [colored](https://crates.io/crates/colored) - looks easier to use than termcolor
    - [prettytable-rs](https://lib.rs/crates/prettytable-rs) - pprint tables to terminal
- [pingora](https://github.com/cloudflare/pingora) - a framework for building networking components
    - cloudflare wrote it b/c nginx *was too inefficient!* (pingora uses a 1/3 of cpu and memory as nginx)
        - specifically [river](https://github.com/memorysafety/river) is a proxy built on pingora to replace nginx
- [vaultwarden](https://github.com/dani-garcia/vaultwarden) - bitwarden server written in rust!
- [rusttls](https://github.com/rustls/rustls) - rust implementation of TLS
### MORE REWRITE IN RUST
- zed,helix     - vi
- skim          - fzf
- zellij        - tmux
- alacritty     - terminal
