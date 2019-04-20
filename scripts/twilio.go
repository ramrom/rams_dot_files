package main

// see this blog on directly writing the http client code instead of the gotwilio package:
// https://www.twilio.com/blog/2017/09/send-text-messages-golang.html

import (
    "github.com/sfreiberg/gotwilio"
    "flag"
    "fmt"
    //"io"
    //"bufio"
    //"os"
    "io/ioutil"
    "encoding/json"
)

var credFileFormat string =`
Cred file must be JSON with the fields:
>>  {
>>      "auth_token": "foo token value",
>>      "sid": "foo sid",
>>      "phone_num": "foo source phone number"
>>  }`

var (
    // escape sequence for color below not working
    // rederror           string =  "\e[31mfailed to parse twilio creds file\e[0m"

    creds              credentials
    defaultCredFileLoc string = "/usr/local/etc/twilio_api.json"
    credFileLocation   *string = flag.String("creds", defaultCredFileLoc, "location of creds file")

    toNumber           *string = flag.String("to", "", "destination phone number")
    debug              *bool = flag.Bool("debug", false, "spit out extra debug info")

    message             string = ""
)

type credentials struct {
    AuthToken  string `json:"auth_token"`
    SID        string `json:"sid"`
    PhoneNum   string `json:"phone_num"`
}

func get_twilio_creds() {
    cred_file, err := ioutil.ReadFile(*credFileLocation)
    if err != nil { panic(fmt.Sprintf("failed to read twilio creds file!:  %v",err)) }
    err = json.Unmarshal(cred_file, &creds)
    if err != nil {
        panic(fmt.Sprintf("failed to json parse twilio creds file!:  %v\n%v",err,credFileFormat))
        //panic(fmt.Sprintf("%v!: %v\n%v",rederror,err,credFileFormat))
    }
}

func send_twilio_text(to string, msg string) {
    twilio := gotwilio.NewTwilioClient(creds.SID, creds.AuthToken)
    res, ex, err := twilio.SendSMS(creds.PhoneNum, to, msg, "", "")
    if *debug {
        fmt.Printf("sms response body: %v\n", res)
        fmt.Printf("exception: %v\n", ex)
        fmt.Printf("error: %v\n", err)
    } else {
        fmt.Printf("exception: %v\n", ex)
        fmt.Printf("error: %v\n", err)
    }
}

func init() {
    flag.Parse()
    if *toNumber == "" {
        panic("must specify a destination phone number")
    }
    //m := readFromStdIn()
    get_twilio_creds()
    if len(flag.Args()) == 0 {
        panic("must specify message")
    }
    for _, word := range flag.Args() {
        message += word + " "
    }
}

func readFromStdIn() string {
    // read https://flaviocopes.com/go-shell-pipes/
    return "hi"
}

func main() {
    fmt.Println(*credFileLocation)
    fmt.Println(flag.Args())
    send_twilio_text(*toNumber, message)
}
