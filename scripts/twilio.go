package main

// see this blog on directly writing the http client code instead of the gotwilio package:
// https://www.twilio.com/blog/2017/09/send-text-messages-golang.html

import (
    "github.com/sfreiberg/gotwilio"
    "fmt"
    "io/ioutil"
    "os/user"
    "encoding/json"
)

var creds credentials

type credentials struct {
  AuthToken  string `json:"auth_token"`
  SID        string `json:"sid"`
  PhoneNum   string `json:"phone_num"`
}

func get_twilio_creds() {
  usr, _ := user.Current()
  cred_file, err := ioutil.ReadFile(usr.HomeDir + "/.creds/twilio_api.json")
  if err != nil { panic(fmt.Sprintf("failed to read twilio creds file!:  %v",err)) }
  err = json.Unmarshal(cred_file, &creds)
  if err != nil { panic(fmt.Sprintf("failed to json parse twilio creds file!:  %v",err)) }
}

func send_twilio_text(to string, msg string) {
  twilio := gotwilio.NewTwilioClient(creds.SID, creds.AuthToken)
  res, ex, err := twilio.SendSMS(creds.PhoneNum, to, msg, "", "")
  fmt.Println("sms response body: %v", res)
  fmt.Println("exception: %v", ex)
  fmt.Println("error: %v", err)
}

func init() {
  get_twilio_creds()
}

func main() {
  send_twilio_text(`1112223333`,`werd to ya motha, golang script`)
}
