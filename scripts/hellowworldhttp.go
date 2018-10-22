package main

import (
  "fmt"
  "net/http"
)

var port string = "8080"

func main() {
  http.Handle("/json", http.HandlerFunc(myjson))
  http.Handle("/web", http.HandlerFunc(web))
  fmt.Printf("starting server on %v\n", port)
  http.ListenAndServe(fmt.Sprintf(":%v",port),nil)
}

func myjson(w http.ResponseWriter,r *http.Request) {
  w.Header().Set("Content-Type","application/json")
  w.Write([]byte(`{"a":2, "b":3}`))
}


func web(w http.ResponseWriter,r *http.Request) {
  w.Header().Set("Content-Type","html")
  html := fmt.Sprintf(`<html><body><h1>Werd</h1><p>Your IP: %v</p></body></html>`,r.RemoteAddr)
  w.Write([]byte(html))
}
