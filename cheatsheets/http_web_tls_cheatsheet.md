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

## SSL/TLS
- certificate data is formatted according to X.509 standard: https://en.wikipedia.org/wiki/X.509
- root CA certs can last 20 years or more
    - the root CA cert is self-signed and inherently trusted
    - most OSes come pre-installed with root CA certs, get new root certs with OS udpates
- CAs do get hacked, DigiNotar was hacked and went bankrupt, so was Comodo
- generate a self-signed cert - https://letsencrypt.org/docs/
    - `openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365`
- get cert from website in PEM format and parse details and print to screen
    - `echo | openssl s_client -showcerts -servername gnupg.org -connect gnupg.org:443 2>/dev/null | openssl x509 -inform pem -noout -text`
- duckdns - https://www.duckdns.org/spec.jsp
### LetsEncrypt
- use their official certbot to do an ACME challenge to prove you own a domain
- dns challenge
    - certbot cmd will give text record to place on your domain record
    - for duckdns can curl to udpate the dns record with the txt record from letsencrypt dns challenge
### LetsEncrypt CERTBOT
- https://certbot.eff.org/instructions?ws=nginx&os=ubuntufocal - certbot install for ubuntu + nginx setup
    - for duckdns, used this 3rd party plugin: https://github.com/infinityofspace/certbot_dns_duckdns
- revoking a cert with certbot - https://letsencrypt.org/docs/revoking/
- dont use `--staging`, maybe `--dry-run` better per docs, after creating staging have to use `--force-renew` to create prod certs
    - https://community.letsencrypt.org/t/certbot-how-can-i-renew-if-staging-certs-exist-but-i-want-production-certs/46472/7
- `sudo certbot --nginx` - create a cert and update nginx configs
- `sudo certbot certonly --nginx` - create a cert only
- `sudo certbot renew --dry-run` - test renewal (dry-run only works on renew cmd)
- `sudo certbot show_account` - show ACME account info (url with acc# and email)
- `sudo certbot certificates` - list certs and expirations
- `certbot plugins` - show plugins installed

## WEB SERVERS
- apache HTTP server - written in c, really old
    - multiple request concurrency models: threaded, pre-forked, evented/async
- apache tomcat - written in java, a application server but not full JEE(java enterprise edition)
- cloudflare
- IIS - internet information services, by microsoft
### NGINX
- written in C with a reactor pattern, great reverse proxy and load balancer, also serves files from disk
- `site-available` and `sites-enabled` are 2 folders
    - design is to define all site with conf files in `sites-avaialble` and symlink to `sites-enabled` for ones to be active
    - jan2023 - per internet this pattern is deprecated, now just create `your-site.conf` in the `/etc/nginx/conf.d` folder
- `sudo nginx -t` - verify if nginx conf files are ok
- nginx will by default remove blank headers and modify `Host` and `Connection` headers
    - https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/
- `stub_status` gives basic info (active connections, # reading/writing/waiting)
    - http://nginx.org/en/docs/http/ngx_http_stub_status_module.html
- make sure to set a default server that denies
    - https://stackoverflow.com/questions/56538783/how-to-force-exact-match-of-subdomains-with-nginx
        - otherwise if no server matches, it will select the first server to route to
### TRAEFIK
- written in Go, great reverse proxy and load balancer
- built in admin gui
- can dynamicaly update configs without restart, unlike nginx

## DNS
- can use tools like `dig` to get info on dns records
    - there will be a `TXT` section to show text record

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

## XH
- https://github.com/ducaale/xh
- a http client in rust that is near identical in interface to HTTPie

