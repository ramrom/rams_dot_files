# HTTP
- good site to test HTTP requests: https://httpbin.org/

## STANDARDS
- http 1.0
    - every request requires a new TCP handshake and connection
- http 1.1
    - supports persistent TCP and pipelining requests
- http 2: https://developers.google.com/web/fundamentals/performance/http2
    - started as SPDY protocol by google, released by IETF in 2015
    - all data sent as binary (1.1 uses plain text)
    - smallest "packet" is a frame, a message is made up of many frames
    - frames/messages allow multiplexing of many streams, no HOL blocking
        - streams can have priorites, with weights
    - server push - the server can send data without a request

## XH
- https://github.com/ducaale/xh
- a http client in rust that is near identical in interface to HTTPie

## SSL/TLS
- generate a self-signed cert - https://letsencrypt.org/docs/
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

## WEB SERVERS
- apache HTTP server - written in c, really old
    - multiple request concurrency models: threaded, pre-forked, evented/async
- apache tomcat - written in java, a application server but not full JEE(java enterprise edition)
- cloudflare
- IIS - internet information services, by microsoft
- nginx - written in C with a reactor pattern, great reverse proxy and load balancer, also serves files from disk
    - `site-available` and `sites-enabled` are 2 folders
        - design is to define all site with conf files in `sites-avaialble` and symlink to `sites-enabled` for ones to be active
        - jan2023 - per internet this pattern is deprecated, now just create `your-site.conf` in the `/etc/nginx/conf.d` folder
- traefik - written in Go, great reverse proxy and load balancer
    - built in admin gui
    - can dynamicaly update configs without restart, unlike nginx
