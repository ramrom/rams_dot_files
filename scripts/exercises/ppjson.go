package main

import (
    "fmt"
    "encoding/json"
)

type S1 struct {
  i1,I2 int
  St1 string
  M1 map[string]S2
}

type S2 struct {
  St2 string
  I3 int
}

func main() {
  s := S1{1,2,"hi",map[string]S2{"a": S2{"dude",3}}}
  r, _ := json.Marshal(s)
  r2, _ := json.MarshalIndent(s, ">", "  ")
  fmt.Println(string(r))
  fmt.Println(string(r2))
}
