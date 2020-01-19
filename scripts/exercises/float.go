package main

// see https://en.wikipedia.org/wiki/IEEE_754-1985 for how float is represented

import "fmt"
import "math"

func main () {
  //for _, i := range []float32{0.1,0.125,0.25,0.5} {
  for _, i := range []float32{-0.75} {
    bf := fmt.Sprintf("%b",math.Float32bits(i))
    fmt.Printf("float: %f, binary rep: %v, signbit: %v, exp: %v, mant: %v\n", i, bf, bf[0:1], bf[1:9],bf[9:32])
    // for sing precision (32bit), exp bias is 127, so 0.5 has exp 2^ -1, so 127 - 1 = 126.
  }
}

// binary float rep for .25 float32: 111110100000000000000000000000
// sign bit: 1, exponent: 11110100 (0d244)
