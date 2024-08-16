package main

import (
  "fmt"
  "net/http"
  "log"
)

var port string = "8080"

func main() {
  http.Handle("/json", mwlog(auth(http.HandlerFunc(myjson))))
  http.Handle("/web", mwlog(http.HandlerFunc(web)))
  fmt.Printf("starting server on %v\n", port)

  // generate cert with opensll: https://www.linode.com/docs/security/ssl/create-a-self-signed-tls-certificate/
  // err := http.ListenAndServeTLS(fmt.Sprintf(":%v",port),"MyCertificate.crt","MyKey.key",nil)
  err := http.ListenAndServe(fmt.Sprintf(":%v",port),nil)  // no TLS server

  if err != nil {
    panic(err)
  }
}

func myjson(w http.ResponseWriter,r *http.Request) {
  w.Header().Set("Content-Type","application/json")
  w.Write([]byte(`{"a":2, "b":3}`))
}


func web(w http.ResponseWriter,r *http.Request) {
  w.Header().Set("Content-Type","text/html")
  html := fmt.Sprintf(`<html><body><h1>Werd</h1><p style="color:blue">Your IP: %v</p></body></html>`,r.RemoteAddr)
  w.Write([]byte(html))
}

func mwlog(handler http.Handler) http.Handler {
  return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
    log.Println(r)
    handler.ServeHTTP(w,r)
  })
}
func auth(handler http.Handler) http.Handler {
  return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
    handler.ServeHTTP(w,r)
  })
}
