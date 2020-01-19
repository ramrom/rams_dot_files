package main

import (
  "fmt"
  "io/ioutil"
  "os/user"
  "encoding/json"
  "net/http"
)

var creds credentials

type credentials struct {
  ApiKey     string `json:"api_key"`
}

type longlat struct {
  Location location
  Accuracy float64
}
type location struct {
  Lat float64
  Lng float64
}

func get_google_creds() {
  usr, _ := user.Current()
  cred_file, err := ioutil.ReadFile(usr.HomeDir + "/.creds/google_api.json")
  if err != nil { panic(fmt.Sprintf("failed to read nasa creds file!:  %v",err)) }
  err = json.Unmarshal(cred_file, &creds)
  if err != nil { panic(fmt.Sprintf("failed to json parse nasa creds file!:  %v",err)) }
}

func get_human_location() {
  //ADDRESS_URL := "https://maps.googleapis.com/maps/api/geocode/json?latlng=LONG,LAT&key=APIKEY"
}

func get_longlat() {
  url := fmt.Sprintf("https://www.googleapis.com/geolocation/v1/geolocate?key=%v",creds.ApiKey)
  res, err := http.Post(url, "text", nil)
  if err != nil { panic(fmt.Sprintf("failed longlat google api call!:  %v",err)) }
  defer res.Body.Close()
  body, err := ioutil.ReadAll(res.Body)
  fmt.Println(string(body))
  var rbody longlat
  json.Unmarshal(body, &rbody)
  fmt.Println(rbody)
}

func init() {
  get_google_creds()
}

func main() {
  get_longlat()
}
