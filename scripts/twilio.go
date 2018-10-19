package main

import (
    //"github.com/go-yaml/yaml" // TODO: make file yaml and parse
    "github.com/sfreiberg/gotwilio"
    "fmt"
    "os/user"
    "io/ioutil"
    "regexp"
)

var (
  apikey  string
  sid     string
  fromnum string
)

func get_twilio_creds() {
  usr, _ := user.Current()
  creds, err := ioutil.ReadFile(usr.HomeDir + "/.creds/twilio_api")
  if err != nil { panic(fmt.Sprintf("failed to read twilio creds file!:  %v",err)) }
  r := regexp.MustCompile(`sid:\s(\w*)\n`)
  results := r.FindStringSubmatch(string(creds))
  sid = results[1] //will get 2 results, i want the second, the first has the full match "sid: ..."
  r = regexp.MustCompile(`auth_token:\s(\w*)\n`)
  results = r.FindStringSubmatch(string(creds))
  apikey = results[1]
  r = regexp.MustCompile(`phone_num:\s(\w*)\n`)
  results = r.FindStringSubmatch(string(creds))
  fromnum = results[1]
}

func send_twilio_text(to string, msg string) {
  twilio := gotwilio.NewTwilioClient(sid, apikey)
  res, ex, err := twilio.SendSMS(fromnum, to, msg, "", "")
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
