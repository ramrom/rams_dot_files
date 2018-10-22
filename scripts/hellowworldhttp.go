package main

import (
  "fmt"
  "net/http"
)

var port string = "8080"

func main() {
  http.Handle("/hi", http.HandlerFunc(hello))
  fmt.Printf("starting server on %v\n", port)
  http.ListenAndServe(fmt.Sprintf(":%v",port),nil)
}

func hello(w http.ResponseWriter,r *http.Request) {
  w.Header().Set("Content-Type","application/json")
  w.Write([]byte(`{"a":2, "b":3}`))
  w.WriteHeader(http.StatusOK)
}
