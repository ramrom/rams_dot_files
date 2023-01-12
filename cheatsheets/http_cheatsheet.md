# HTTP
- good site to test HTTP requests: https://httpbin.org/

## XH
- https://github.com/ducaale/xh
- a http client in rust that is near identical in interface to HTTPie

## SSL/TLS
- generate a self-signed cert
    - `openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365`
- LetsEncrypt
    - use their official certbot to do an ACME challenge to prove you own a domain
    - dns challenge
        - certbot cmd will give text record to place on your domain record
        - for duckdns can curl to udpate the dns record with the txt record from letsencrypt dns challenge
- duckdns - https://www.duckdns.org/spec.jsp

## HTTPIE
- https://httpie.io/docs
- written in python, core libs pygments and requests
### USAGE
raw json fields:
    ```bash
    http POST https://api.foo.com field:='["a",2]'
    ```
### CODE SNIPPET OF EXTRACTING STATUS CODE
```sh
function httpie_all() {
    local url=$1
    local method=GET
    local body_file=/tmp/httpie_body

    # gets 3 digit status code with ansi color chars:
        # local headers=$(http -v -do $body_file --pretty all http://api.icndb.com/jokes/random 2>&1)
        # echo $headers | grep "HTTP.*\d\d\d" | grep -o "\d\d\d"

    local headers=$(http -v -do $body_file $method $url 2>&1)
    local http_status=$(echo $headers | grep "^HTTP" | cut -d ' ' -f 2)
    echo $headers; echo
    echo "STATUS CODE IS: $http_status"; echo
    jq . $body_file || echo $(fg=brightred ansi256 "$body_file NOT VALID JSON") && cat $body_file
}
```
