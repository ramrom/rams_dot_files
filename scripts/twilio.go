package main

// see this blog on directly writing the http client code instead of the gotwilio package:
// https://www.twilio.com/blog/2017/09/send-text-messages-golang.html

import (
    "github.com/sfreiberg/gotwilio"
    "flag"
    "fmt"
    "io/ioutil"
    "os/user"
    "encoding/json"
)

var credFileFormat string =`
Cred file must be in the format:
>>  {
>>      "auth_token": "foo token value",
>>      "sid": "foo sid",
>>      "phone_num": "foo source phone number"
>>  }`

var (
    creds              credentials
    defaultCredFileLoc string = "/usr/local/etc/twilio_api.json"
    credFileLocation   *string = flag.String("creds", defaultCredFileLoc, "location of creds file")

    toNumber           *string = flag.String("to", "", "destination phone number")
    message            *string = flag.String("msg", "", "SMS message content to deliver")
    debug              *bool = flag.Bool("debug", false, "spit out extra debug info")
)

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
  if err != nil {
      fmt.Println(credFileFormat)
      panic(fmt.Sprintf("failed to json parse twilio creds file!:  %v",err))
  }
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
  flag.Parse()
}

func main() {
    fmt.Println(*credFileLocation)
    fmt.Println(*message)
    //send_twilio_text(`1112223333`,`werd to ya motha, golang script`)
}
