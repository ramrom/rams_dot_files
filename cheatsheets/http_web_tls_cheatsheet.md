# HTTP
- good site to test HTTP requests: https://httpbin.org/

## STANDARDS
- http 1.0
    - every request requires a new TCP handshake and connection
- http 1.1
    - supports persistent TCP (dont need to open a new TCP connection for every request)
    - supports pipelining requests (can send request 2 before waiting for response of request 1)
        - many browsers stopped supporting it, b/c many proxies did not implement pipelining correctly
- http 2: https://developers.google.com/web/fundamentals/performance/http2
    - good docs: https://http2.github.io/faq/
    - started as SPDY protocol by google, released by IETF in 2015
    - all data sent as binary (1.1 uses plain text)
    - smallest "packet" is a frame, a message is made up of many frames
    - frames/messages allow multiplexing of many streams, no HOL blocking
        - with 1.1 clients would do complex strategies with multiple TCP connections to get resources in parralel
        - streams can have priorites, with weights
    - server push - the server can send data without a request
    - has HPACK header compression
- http 3
    - released as IETF standard in 2023
    - uses QUIC, runs on top of UDP
        - QUIC major advantage for mobile traffic, which have many network handoffs, TCP tends to die on network handoffs
        - QUIC embeds TLS inside it, offer more security with more data encrypted
        - QUIC can support multiple streams at transport layer, all HTTP2 streams would be blocked if TCP connect was blocked
        - http3 was invented in order to use QUIC, QUIC wasnt compatible with HTTP2

## OTHER INFO
- chunked vs multi-part: chunked is transfer encoding, multi-part is content type
    - each chunk is preceded by it's size, transmission ends with zero sized chunk, not supported in HTTP2
    - multi-part type can use chunked encoding

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
- logs on ubuntu: `/var/log/letsencrypt/letsencrypt.log`

## CERTS
- `.csr` - certificate signing request, for submission to cert authorities
    - format is PKCS10, https://www.rfc-editor.org/rfc/rfc2986
- `.pem` - container format defined in https://www.rfc-editor.org/rfc/rfc1422
    - usually includes public cert
    - but can include entire chain: public keys, private keys, root certs
    - can also encode a .csr, PKCS10 can be translated to PEM format
    - apache installs in `/etc/ssl/certs`
- `.key` - PEM formatted file just containing private key
    - apache installs in `/etc/ssl/private`
- `.cert`, `.cer`, `.crt` - PEM formatted file, diff ext, recognized by windows explorer as cert
    - the whole signed certificate

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

## CURL
- `curl --insecure https://foo.com`  - skip cert TLS verification
- `curl -X POST -H "Content-Type: application/json" -d '{"foo": 3, "bar": 1}' https://foo.com/yar/bar`
- `curl -v --http1.1 -X POST -F 'name=foo' https://foo.com`  
    - `-v` for verbose, `--http.1.1` to force http1.1
- `curl -X POST -d 'name=foo' https://foo.com` 
    - `-d` forces Content-Type to be `application/x-www-form-urlencoded`
- removing a header: https://stackoverflow.com/questions/31293181/how-can-i-remove-default-headers-that-curl-sends
- `curl --header 'HOST: foo.com' bar.com`  
    - curl will resolve bar.com _but_ still set host header to `foo.com`

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
- `xh --verify no https://foo.com` - dont verify TLS cert

