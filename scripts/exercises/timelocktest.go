package main

import (
  "time"
  "fmt"
  "sync"
)

var lok sync.Mutex
var numTimes int = 1000
var numRout int = 400
var timcounter int
var starter sync.WaitGroup
var stopper sync.WaitGroup

func main() {
  start := time.Now()
  starter.Add(numRout)
  fmt.Println("before goroutine launching")
  for j := 0; j < numRout; j++ {
    stopper.Add(1)
    go func(gor int) {
      //fmt.Printf("goroutine %v launching\n", gor)
      starter.Done()
      starter.Wait()
      //for i := 0; i < numTimes; i++ { getTimeLock() }
      for i := 0; i < numTimes; i++ { getTime() }
      //fmt.Printf("goroutine %v FINISHING!!!!\n", gor)
      stopper.Done()
    }(j)
  }
  fmt.Println("all go routines launched")
  stopper.Wait()
  fmt.Println("execution time:", time.Since(start))
}

func getTimeLock() {
  lok.Lock()
  //timcounter++
  //fmt.Println(timcounter)
  time.Now()
  lok.Unlock()
}

func getTime() {
  time.Now()
}
