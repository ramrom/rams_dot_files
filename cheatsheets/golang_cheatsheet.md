## GOLANG:
- https://go.dev
- cgo lets you add c code in go programs: https://golang.org/cmd/cgo/
- supported architectures and OSes: https://golang.org/doc/install/source#environment

## GOOD LIBS
- solid big decimal package: https://github.com/shopspring/decimal
    - uses stdlib's big.Int
- protobuf: https://github.com/golang/protobuf

## print src code for go doc symbol/type/func
go doc -src fmt.Println

# GO MOD
- module is collection of packages
- https://blog.golang.org/using-go-modules
- `go.mod` specifies dependent modules/packages, `go.sum` contains crypto hashes of specific mod packages
