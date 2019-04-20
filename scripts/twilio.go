package main
// blog used to write this: https://www.twilio.com/blog/2017/09/send-text-messages-golang.html

import (
    //"github.com/sfreiberg/gotwilio"  # good library for more options
    "flag"
    "fmt"
    "net/http"
    "net/url"
    "strings"
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

func etTwilioCreds() {
    cred_file, err := ioutil.ReadFile(*credFileLocation)
    if err != nil {
        panic(fmt.Sprintf("failed to read twilio creds file!:  %v",err))
    }
    err = json.Unmarshal(cred_file, &creds)
    if err != nil {
        panic(fmt.Sprintf("failed to json parse twilio creds file!:  %v\n%v",err,credFileFormat))
        //panic(fmt.Sprintf("%v!: %v\n%v",rederror,err,credFileFormat))
    }
}

func readFromStdIn() string {
    // read https://flaviocopes.com/go-shell-pipes/
    return "hi"
}

//func SendTwilioSMS2(to string, msg string) {
//    twilio := gotwilio.NewTwilioClient(creds.SID, creds.AuthToken)
//    res, ex, err := twilio.SendSMS(creds.PhoneNum, to, msg, "", "")
//    if *debug {
//        fmt.Printf("sms response body: %v\n", res)
//        fmt.Printf("exception: %v\n", ex)
//        fmt.Printf("error: %v\n", err)
//    } else {
//        fmt.Printf("exception: %v\n", ex)
//        fmt.Printf("error: %v\n", err)
//    }
//}

func SendTwilioSMS(to string, msg string) {
    urlString := "https://api.twilio.com/2010-04-01/Accounts/" + creds.SID + "/Messages.json"

    msgdata := url.Values{}
    msgdata.Set("To", to)
    msgdata.Set("From", creds.PhoneNum)
    msgdata.Set("Body", msg)

    req, _ := http.NewRequest("POST", urlString, strings.NewReader(msgdata.Encode()))
    req.SetBasicAuth(creds.SID, creds.AuthToken)
    req.Header.Add("Accept","application/json")
    req.Header.Add("Content-Type","application/x-www-form-urlencoded")
    fmt.Println(req)

    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        panic(fmt.Sprintf("making request failed!: %v", err))
    }
    defer resp.Body.Close()

    var jsonbody map[string]json.RawMessage
    if (resp.StatusCode >= 200 && resp.StatusCode < 300) {
        raw_content, _ := ioutil.ReadAll(resp.Body)
        err = json.Unmarshal(raw_content, &jsonbody)
    } else {
        panic(fmt.Sprintf("failed, response code: %v", resp.Status))
    }
    fmt.Println("results", jsonbody)
}

func init() {
    flag.Parse()
    if *toNumber == "" {
        panic("must specify a destination phone number")
    }
    //m := readFromStdIn()
    if len(flag.Args()) == 0 {
        panic("must specify message")
    }
    for _, word := range flag.Args() {
        message += word + " "
    }
    GetTwilioCreds()
}

func main() {
    if *debug {
        fmt.Println(*credFileLocation)
        fmt.Println(flag.Args())
    }
    SendTwilioSMS(*toNumber, message)
}
