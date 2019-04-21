package main
// blog used to write this: https://www.twilio.com/blog/2017/09/send-text-messages-golang.html

import (
    //"github.com/sfreiberg/gotwilio"  # good library for more options
    "flag"
    "fmt"
    "net/http"
    "net/url"
    "strings"
    "io"
    "bufio"
    "os"
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

// TODO: support flag args for creds
func GetTwilioCreds() {
    cred_file, err := ioutil.ReadFile(*credFileLocation)
    if err != nil {
        panic(fmt.Sprintf("\033[31mfailed to read twilio creds file!:\033[0m  %v",err))
    }
    err = json.Unmarshal(cred_file, &creds)
    if err != nil {
        panic(fmt.Sprintf("\033[31mfailed to json parse twilio creds file!:\033[0m  %v\n%v",err,credFileFormat))
        //panic(fmt.Sprintf("%v!: %v\n%v",rederror,err,credFileFormat))
    }
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

    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        fmt.Printf("\033[31mmaking request failed!:\033[0m %v", err)
        os.Exit(1)
    }
    defer resp.Body.Close()

    var jsonbody map[string]json.RawMessage
    raw_body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        panic(fmt.Sprintf("\033[31mERRORreading response body faild!:\033[0m %v", err))
    }
    err = json.Unmarshal(raw_body, &jsonbody)
    if err != nil {
        panic(fmt.Sprintf("\033[31munmarshaling json from response body faild!:\033[0m %v", err))
    }

    if *debug {
        fmt.Println("results", jsonbody)
    }
    if resp.StatusCode != 201 {
        fmt.Printf("\033[31mSMS failed to deliver, response message:\033[0m %v\n", resp.Status)
        panic("")
    }
}

// if stdin is a pipe input read it all
func readFromStdIn() string {
    stats, err := os.Stdin.Stat()
    if err != nil { panic(err) }

    if stats.Mode() & os.ModeNamedPipe == os.ModeNamedPipe {
        reader := bufio.NewReader(os.Stdin)
        var output []rune
        for {
            input, _, err := reader.ReadRune()
            if err != nil && err == io.EOF {
                break
            }
            output = append(output, input)
        }
        return string(output)
    } else {
        return ""
    }
}

// message args passed in are ignored if any chars are obtained from stdin
func getMessage() {
    message = readFromStdIn()
    if message == "" {  // we got nothing from stdin
        if len(flag.Args()) == 0 {  // then try args, if nothing here, then failure
            fmt.Println("\033[31mmust specify message\033[0m")
            os.Exit(1)
        }
        for _, word := range flag.Args() {
            message += word + " "
        }
    }
}

func init() {
    flag.Parse()
    if *toNumber == "" {
        fmt.Println("\033[31mmust specify a destination phone number\033[0m")
        os.Exit(1)
    }
    getMessage()
    GetTwilioCreds()
}

func main() {
    if *debug {
        fmt.Println(*credFileLocation)
        fmt.Println(message)
    }
    SendTwilioSMS(*toNumber, message)
}
