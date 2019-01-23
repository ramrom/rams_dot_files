package main

import "time"
import "fmt"
import "runtime"

func main() {
  start := time.Now()
  c := make(chan struct{})
  chead := c
  var c2 chan struct{}
  var ctail chan struct{}
  // running 1mil goroutines, i saw 1.65gig of memory in activity monitor which comes out to ~2k bytes/goroutine
  for i := 0; i < 100000; i++ {
    c2 = make(chan struct{})
    go func(in, out chan struct{}, ii int) {
      a := <-in
      //fmt.Println(ii)
      out<-a
    }(c, c2, i)
    c = c2
    ctail = c
  }
  fmt.Println(runtime.NumGoroutine())
  chead<-struct{}{}
  <-ctail
  fmt.Printf("time: %v\n", time.Since(start))
}
