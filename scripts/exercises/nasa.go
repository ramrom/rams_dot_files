package main

import (
  "fmt"
  "net/http"
)

var creds credentials

type credentials struct {
  ApiKey     string `json:"api_key"`
  AccountID  string `json:"account_id"`
}

func get_nasa_creds() {
  usr, _ := user.Current()
  cred_file, err := ioutil.ReadFile(usr.HomeDir + "/.creds/nasa_api.json")
  if err != nil { panic(fmt.Sprintf("failed to read nasa creds file!:  %v",err)) }
  err = json.Unmarshal(cred_file, &creds)
  if err != nil { panic(fmt.Sprintf("failed to json parse nasa creds file!:  %v",err)) }
}
func main() {
}
