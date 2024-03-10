# COMPUTER SCIENCE
- mutexes are generally implement with atomics at the low-level in order to aquire locks
    - https://en.wikipedia.org/wiki/Read%E2%80%93modify%E2%80%93write
- null value, represented as ASCII code point zero, bits will all be zero value

### PASS BY VALUE OR REFERENCE
- refers to the nature of variables
    - pass-by-value means value is pass to the function
    - pass-by-reference means the reference to the variable is passed to the function
- java is really pass by value, variables hold object "references"(really pointers), and _those_ are copied
```java
class Foo { int data; Dog(int i) { this.data = i;} }

public static void testmodify(Foo f) { f = Foo(2); }

public static void main(String[] args) {
    Foo bar = Foo(1);
    testmodify(bar);
    System.out.println(bar.data);       // this prints 1 in java, if java was pass-by-ref it would print 2
}
```

### BASE2 REPRESENTATION OF BASE10
- cant reprent base10 `0.1` in base2 in finite way, in binary it repeats forever: `0.00011001100110011...`
    - types like java `BigDecimal` can represent these values
- floating point in any laungage of `0.1` is not exactly `0.1`
- https://www.educative.io/answers/why-does-01-not-exist-in-floating-point


## NUMERIC REPRSENTATIONS
### TWOS COMPLEMENT
- unlike one's complement, there is only one representation for zero
- arithmetic implementations can use both signed and unsigned values
### IEEE754 FLOAT
- has 2 representations for zero

## MEMORY ALIGNMENT
- n-byte (where n is a power of 2) alignment means the address has a minimum of log2(n) least-significant zeros when represented in binary
