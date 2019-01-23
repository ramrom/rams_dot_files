package main

import "fmt"
import "time"
import "sync"

func main() {
  testunsafeadd()
}

func testunsafeadd() {
  a := mystruct{}
  a.w.Add(3)
  go a.unsafeadd()
  go a.unsafeadd()
  go a.unsafeadd()
  a.w.Wait()
  fmt.Println(a.count)
}

type mystruct struct {
  count int
  w sync.WaitGroup
  l sync.Mutex
}

func (s *mystruct) unsafeadd() {
  for i := 0; i < 10000; i++ {
    //s.l.Lock()
    s.count++
    //s.l.Unlock()
  }
  s.w.Done()
}

func chans() {
  var w sync.WaitGroup
  f := make(chan struct{})
  s := make(chan struct{})
  w.Add(1)

  go func() {
    <-s
    fmt.Println("third")
    w.Done()
  }()

  go func() {
    <-f
    fmt.Println("second start")
    time.Sleep(1 * time.Second)
    fmt.Println("second done")
    s <- struct{}{}
  }()

  go func() {
    fmt.Println("first start")
    time.Sleep(1 * time.Second)
    fmt.Println("first done")
    f <- struct{}{}
  }()

  w.Wait()
  fmt.Println("fin")
}
