## GOLANG
- https://go.dev
- cgo lets you add c code in go programs: https://golang.org/cmd/cgo/
- supported architectures and OSes: https://golang.org/doc/install/source#environment
- ken thomson, robert pike, Robert Griesemer invented it to fix everything they hated about c++
    - they all had to agree on features they liked
    - golang is object-oriented _but_ has not classes, you can be object-oriented without classes
- early version didnt use `libc` much, and implemented their own syscalls in go
- critique of why go is bad: https://fasterthanli.me/articles/i-want-off-mr-golangs-wild-ride

## HISTORY
- 1.18 added generics

## IMPLEMENTATIONS
- "go spec", the official specification: https://go.dev/ref/spec
- google's original "gc" compiler toolchain
- gofrtontend - frontend for other compilers using `libgo`, `gccgo` uses `gcc`, `gollvm` uses LLVM
- gopherJS - compiles to javascript

## MEMORY
- good article on memory alignment and padding: https://go101.org/article/memory-layout.html
### GC
- compiler performs escape analysis: determine if data goes on heap or stack
    - if data is used outside of scope (e.g. data is returned) it needs to be on the heap
    - other cases are if data is really big, it'll be on the heap

## TYPE SYSTEM
- has pointers for "pass by reference" style, but you cant do pointer arithmetic like C/C++

## LEARNING GUIDES
- good quick intro: https://www.golang-book.com/books/intro
- good solid intro: https://go.dev/doc/effective_go
- go playground: https://go.dev/play/


## CONCURRENCY
- blog opinion on why channels not so great: https://www.jtolio.com/2016/03/go-channels-are-bad-and-you-should-feel-bad/

## GOOD LIBS
- solid big decimal package: https://github.com/shopspring/decimal
    - uses stdlib's big.Int
- protobuf: https://github.com/golang/protobuf

## DOCS
- print src code for go doc symbol/type/func
    - `go doc -src fmt.Println`

## RUNTIME SCHEDULING
- https://www.ardanlabs.com/blog/2018/08/scheduling-in-go-part2.html
- goroutines pre-empted only at safe points, at function calls
    - many of these are inserted before/after function calls by compiler
    - yield points are injected in parts of code to allow runtime to pre-empt to ensure fair scheduling
- GC generally done by concurrently running dedicated goroutines

## DEPENDENCY MANAGEMENT
- [dep](https://github.com/golang/dep) was first dep management tool, archived in 2020 in favor of mod
- go modules is official dep management tool
- overview - https://blog.golang.org/using-go-modules
    - https://go.dev/ref/mod
- `go.mod` specifies dependent modules/packages, `go.sum` contains crypto hashes of specific mod packages

## LIBS/FRAMEWORKS
- [cobra](https://github.com/spf13/cobra) - CLI builder lib
- [glow](https://github.com/charmbracelet/glow) - CLI markdown viewer
