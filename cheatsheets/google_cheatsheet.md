# GOOGLE
- console.developers.google.com     - configure my apps and whatnot as google developer
- cli script with oauth2: https://martinfowler.com/articles/command-line-google.html
- how google knows device is the same/familiar
    - https://security.stackexchange.com/questions/103976/how-exactly-does-google-account-decide-my-device-or-location-is-familiar
- takeout - https://takeout.google.com
    - download basically *any* google data, including all photos
- example to search google cache for slashdot: http://webcache.googleusercontent.com/search?q=cache:http://www.slashdot.org

## OAUTH
- https://developers.google.com/identity/protocols/oauth2
    - jan2023, refresh tokens unused for 6 months expire

## GOOGLE PHOTOS
- delete from google photos app and it will delete locally (sync)
    - *BUT* delete locally and it will NOT delete from google photos

## DRIVE
- see drive usage at https://drive.google.com/drive/u/0/quota
-  gmail/drive/photos breakdown of usage: https://one.google.com/storage

## GOOGLE SEARCH
"literal string"
-excludethis
foo OR bar              - default spaced words is OR
*foo                    - wildcard search
foo site:www.site.com   - search a specific site
- should be a "tools" submenu below search bar that lets you filter by most recent (e.g. last year only)

## CHROME
- command + option + i   - toggle dev tools
    - hit "preserve logs" checkbox to not zero logs between full html refreshes
- chrome://flags  - see advanced/experimental options
- accept self signed certificates
    - https://stackoverflow.com/questions/7580508/getting-chrome-to-accept-self-signed-localhost-certificate
        - typing "thisisunsafe" worked for chrome 85 on osx!
- enable chrome to debug very verbose logs to a file:
    - https://www.chromium.org/for-testers/providing-network-details
    - https://groups.google.com/a/chromium.org/g/chromium-dev/c/VSzBnCgvQgc?pli=1
- can edit keyboard shortcuts for extensions, goto chrome:://extensions -> keyboard shortcuts(left bar)
- OSX bookmarks are stored in `~/Library/Application Support/Google/Chrome/Default/Bookmarks` file, it's json
    - normal bookmakr export is in html format

## CHROMEBOOK
- mounting a samba share, chromebook needs samba ver 2 or higher
    - open file explorer, hit 3 dot icon on top right -> "add new service" -> samba share
    - url is like "\\192.168.1.111\somefolder"

## CHROMECAST/GOOGLE-TV
- cast or Google Cast (https://en.wikipedia.org/wiki/Google_Cast) is a google propietary protocol created in 2013
- install screensaver app and set it to use ambient mode
    - https://www.reddit.com/r/AndroidTV/comments/k79y4j/google_tv_w_chromecast_ambient_mode/
- mirror in android -> google home -> select tv chromecast device -> bottom bar "cast my screen"

## DRIVE
- google drive linux sync options: https://linuxhint.com/best_google_drive_clients_linux/

## MEETS
cmd + d - toggle mute
cmd + e - toggle camera

## GMAIL
- QUERY language: https://support.google.com/mail/answer/7190?hl=en
    - find file in size range: `larger_than:5m smaller_than:8M`
    - find with label: `label:foo`
    - find unread + primary: `label:unread category:primary`
    - find 3day new not social: `newer_than:2d -category:social`
- select all in promotions/social
    - upper right box -> select all -> should see banner to select all with label (promotion/social)
### keyboard mappings
`?` bring up popup of keyboard shortcuts
`<backtick>` toggle b/w primary/social/promotion
`-` (goto settings and turn on keyboard shortcuts)
`-` see https://support.google.com/mail/answer/6594?co=GENIE.Platform%3DDesktop&hl=en
`c` - compose new email
`#` - delete
`/` - put cursor on searchbox
shift+`U` - mark email unread
`s` - toggle star on email
`gn`/`gp` - next/previous page of emails
up/down arrow, or `j`/`k`    - next/prev email in chain
`space/space-shift`   - scroll down/up current email
`o`/`enter` - open email/conversation
`gs` - unread
`gd` - drafts,
`gi` - inbox,
`gt` - sent
`f` - forward email
`c` - compose
`z` - undo last action

## YOUTUBE
- j/l - back/forward 10 sec
- k - play/pause
- t - toggle theater mode
- f - toggle fullscreen
- m - toggle mute
- c - toggle closed caption
- up/down arrow (while video is active element) - up/down volume by 5%
- add timestamp to a video link: append `&t=1m30s`

## SPREADSHEET
- full func list: https://support.google.com/docs/table/25273?hl=en&page=table.cs&tab=1240291&visit_id=638291857469023287-758844995&rd=1

## CALENDER
/ - put cursor in searchbox
a - agenda view, shows list of events
w - week view
m - month view
y - year view
d - day
t - today, fix to today's week/month/year if you are in those views
j - next time period (this feels reversed)
k - last time period
s - goto settings page
g - popup goto specific date box
c - create an event
z - undo
r - refresh
esc - return to calender grid from event details

## GOOGLE MESSAGES
- android app that can be default SMS message app
- can also message on the web: https://messages.google.com/web/ (requires pairing)

## VOICE
- voice legacy: in very top left menu, botton item is "legacy google voice"
- legacy voice lets you screen calls just for certain groups
    - e.g. you can turn off for all contacts group, and screen for anonymous callers

## ANDROID
- top swipe bar is called "quick settings"
- APK (android application package) file defines an app
- take screenshot: press volume button and power button together
- google photos: how to get a album(in gallery) to show up in google photos backup&sync folder list
    - https://forums.androidcentral.com/google-nexus-6/696364-google-photos-device-folders-missing.html
    - use a file manager(e.g. astro) to move the folder from `DCIM` folder to `Pictures` folder

## WEAROS
- wearOS 3.0 is joint OS that combines google's wearOS and samsung Tizen OS
    - samsung galaxy 4 will use wearOS 3.0
    - new OS *NOT* compatible with iphone
