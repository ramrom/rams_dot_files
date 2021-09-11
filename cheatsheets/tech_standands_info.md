# TECH STANDARDS AND INFO
------------------------------------

## CODECs
- VP9, royalty-free, invented by google, succeeds VP8
    - used by google in youtube
    - competes with HEVC/H.265
- AV1, royalty-free and open, to succeed VP9, designed by alliance for open  media
- VP8, open and royalty-free
- HEVC(H.265), designed by MPEG-H, succeeds AVC
    - uses integer DCT and DST with 4x4 up to 32x32 blocks
    - maybe 25-50% better compression than H.264 (same quality)
    - supports 8K
- AVC(H.264, aka MPEG-4 part 10)
    - uses integer DCT 4x4 and 8x8 blocks

## WIFI
- WiFi 6 to identify devices that support 802.11ax (released 2019)
- WiFi 5 to identify devices that support 802.11ac (released 2014)
- WiFi 4 to identify devices that support 802.11n  (released 2009)
- WiFi 3 to identify devices that support 802.11g (released 2003)
- WiFi 2 to identify devices that support 802.11a (released 1999)
- WiFi 1 to identify devices that support 802.11b (released 1999)

## HTTP
- http2: https://developers.google.com/web/fundamentals/performance/http2

## SUBTITLES
- srt offset adjustment website: http://www.subsedit.com/simple

## CABLES
- displayport max lenghts
    - https://www.reddit.com/r/Monitors/comments/989lm2/maximum_cable_length_for_displayport/
        - don't exceed 10 feet, pretty much the limit

## BASE64
- 64 safe ASCII chars
- standard one is `A-Z` `a-z` `0-9` `+` `/`
- url safe one replaces `+` and `/` with `_` and `-`

## FLOATS
- https://en.wikipedia.org/wiki/IEEE_754-1985

## PLANTUML
- https://plantuml.com/sequence-diagram

## OpenApi / Swagger
- https://editor.swagger.io/

## Compilation
- `.so`, SO(shared object) files, used mostly in Linux, similar to windows DLL or OSX DYLIB(mach-o dynamic library)

## LEAGUE:
- north america server: 104.160.131.3
- ctrl f in league for ping
- shift + enter  - in game do a /all message

## NATIVEFIER:
- set user agent so google wont yell about untrusted broswer
    - https://github.com/jiahaog/nativefier/issues/831
    - nativefier --user-agent "Mozilla/5.0 (Windows NT 10.0; rv:74.0) Gecko/20100101 Firefox/74.0" --name 'Google Hangouts' 'https://hangouts.google.com'

## BITWARDEN
- it's fully FOSS, can self host a server, has a cli, can do mobile/desktop for free (unlike lastpass)
- premium individual is $10/year, offers 2FA, emergency access, file share/upload
- autofill https://bitwarden.com/help/article/auto-fill-browser/
    - cmd+shift+L for autofill
- excluded domains: browser ext -> settings -> excluded domains
    - list of domains/sites where banner to prompt to save creds wont appear


## OPTIONS TRADING
- strike price - the price of the stock for which the option can be exercized at
    - "in the money" means strike price > current price for put, and current price > strike price for call
        - opposite for "out of the money"
- delta - rate of change b/w options price and $1 change in underlying assets price
- theta (decay) - measure of rate of decline of option due to passoge of time (b/c of getting closer to expiration)

## RANDOM NOTES
- usb 3.0 cable shouldn't really exceed 10 feet without repeater
- displayport cable shouldnt exceed 10 feet
