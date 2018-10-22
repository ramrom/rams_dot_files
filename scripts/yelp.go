package main

import (
    "fmt"
    "io/ioutil"
    "os/user"
    "encoding/json"
    "net/http"
    "net/url"
    "bytes"
)

var creds credentials

type credentials struct {
  ApiKey    string `json:"api_key"`
  ClientID  string `json:"client_id"`
}

func get_yelp_creds() {
  usr, _ := user.Current()
  cred_file, err := ioutil.ReadFile(usr.HomeDir + "/.creds/yelp_api.json")
  if err != nil { panic(fmt.Sprintf("failed to read yelp creds file!:  %v",err)) }
  err = json.Unmarshal(cred_file, &creds)
  if err != nil { panic(fmt.Sprintf("failed to json parse yelp creds file!:  %v",err)) }
}

func init() {
  get_yelp_creds()
}

func make_yelp_query() {
  //raw_query := fmt.Sprintf("latitude=%v&longitude=%v",41.9033958, -87.642861)
  raw_query := url.Values{"latitude":{"41.9033958"}, "longitude":{"-87.642861"}}
  u := url.URL{
      Scheme:     "https",
      Host:       "api.yelp.com",
      Path:       "v3/businesses/search",
      RawQuery:   raw_query.Encode(),
      //RawQuery:   raw_query,
    }
  req, err := http.NewRequest("GET", u.String(), nil)
  req.Header.Add("Authorization",fmt.Sprintf("Bearer %v",creds.ApiKey))
  //fmt.Println(req)
  client := &http.Client{}
  res, err := client.Do(req)
  if err != nil { panic(fmt.Sprintf("failed yelp fusion api call!:  %v",err)) }
  defer res.Body.Close()
  body, err := ioutil.ReadAll(res.Body)
  //fmt.Println(string(body))

  var ppjson bytes.Buffer
  err = json.Indent(&ppjson, body, "", "\t")
  if err != nil { fmt.Println("JSON parse error: ", err) } else { fmt.Println(string(ppjson.Bytes())) }
}

func main() {
  make_yelp_query()
}
