# OSX CHEATSHEET
-------------------------------------------
- cmd + option + hover over scale image in display in sys prefs   - show the resolution
- option + click on "scaled" radio buttton in display will bring up granular resolutions supported
    - https://apple.stackexchange.com/questions/194101/what-are-the-effective-scaling-modes-on-osx-with-a-4k-display-is-an-effective-r
- AppleID/icloud security two-factor auth: https://support.apple.com/en-us/HT204915
    - is required (can't turn it off in https://appleid.apple.com)
    - looks like the 2nd factor will pop up a 6 digit code in a trusted device, and if none maybe the trusted ph #?

## BREW
--------------------
Terminology:
- see https://docs.brew.sh/Formula-Cookbook#homebrew-terminology
- bottle: pre-compiled code, just installs
- cask: installs a program exactly as if it were a native osx appliation install
- tap: a repository of formula

- stop brew from auto update:
    `HOMEBREW_NO_AUTO_UPDATE=1 brew install somepackage`
- show deps of httpie in tree output
    - `brew deps --tree httpie`
- show all formula that need this formula
    - `brew uses httpie`
- only formula installed that need this formula
    - `brew uses --installed httpie`
- all brew formulas not depended by other brew formulas
    `brew leaves`
- for each brew leaf formula: show flat list of deps for that formula
    `brew leaves | xargs brew deps --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"`
- removing packages deps of a uninstalled FORMULA that isn't a dep on something else
    - from https://stackoverflow.com/questions/7323261/uninstall-remove-a-homebrew-package-including-all-its-dependencies)
    - `brew rm $(join <(brew leaves) <(brew deps FORMULA))`
- upgrade all formulas
    `brew upgrade`
    - NOTE: brew does seem to support upgrading just one formula


## CLI:
----------------
- ref: https://www.mitchchn.me/2014/os-x-terminal/
- say - speech synth to audio out a sentence
    - supports speaking a file like "say -f prose.txt -o audobook.aiff"
        - -o will save it to an audio file
- screencapture - capture screenshot images
- mdfind - cli way to find whatever spotlight does
- open - open a app like u would double click on it
    - open an app by name: open -a "Slack"
- pbcopy  - cli way to copy to sys clipboard
    - lal | pbcopy   (copy ls long listing to clipboard)
- pbpaste - cli way to paste from clipboard
    - pbpaste | grep foo
- mdls    - get metadata on a file
- sudo powermetrics  - spits out thermals and LOTS of info, network usage, gpu usage, etc
- vm_stat - show some raw memory usage
- nettop - like top but for tcp/udp sockets only and their bandwidth usage!
- skhd
    - `brew services` to see if it's running
    - `skhd -r` to reload config file with shortcuts
- force color to pipe output, be default ls wont colorize
    - `CLICOLOR_FORCE=1 ls -l | less`
- lp - print from command line



## KEYBOARD SHORTCUTS:
-----------------------------------
- full list: https://support.apple.com/en-us/HT201236
- command + tab  - switch between apps
- command + space - spotlight search
- command + H - goto home screen
- command + N - compose new email in mail app
- command + ctrl + q  - lock the screen

- command + c copy
- command + v paste
- command + x cut
- command + a select all
- command + z undo
- command + ,   typically bring up preferences window in many apps (chrome, spotify, slack, whatsapp, vlc, iterm)

- cmd + shift + 3           - screenshot
- cmd + shift + 4           - screenshot area
- cmd + shift + 4, space    - screenshot window

- cmd + ctrl + space    - bring up emoji menu in text field
- :<foo>:               - in text field typing `:` then text desc of emoji, then `:` will insert emoji
                          works in slack and whatsapp, not safari for google voice
- fn + E                - from a text box, bring up emoji window

### BROWSER(CHROME/FIREFOX verified):
- cmd + [number]          - goto that number tab (works for 1-8), 9/0 goto rightmost tab
- cmd + forward/back-arrow  - back and forth web page history
- cmd + [/]               - back/forward page history
- cmd + up/down-arrow     - scroll up/down web page
- cmd + shift [/]         - back/forward tabs in window
- cmd + \`  (cmd + backtick) - cycle through windows
- cmd + L                 - select url bar
- spacebar                - scroll down
- spacebar + shift        - scroll up
- tab/shift+tab           - goto next/prev field in browsertab+page

### WHATSAPP NATIVE:
- cmd + shift + [/]       - up/down conversations/groups
- page up/down            - scroll up/down in the convo

### PREVIEW
- option + downarray      - next page/item
- downarrow               - scroll down

### SAFARI
- command + T - open new tab
- command + W - close tab
- command + R - refresh tab
- command + . - stop loading tab
- command + click - open link in new tab
- shift + click - open link in new window
- command + rightarrow - go to future page history
- command + leftarrow - go to previow page history
- up/down arrow  - scroll up and down

## IPHONE / IOS
--------------------------
- iphone12: hold volume up and right button to see power off slider
- iphone12: press volume up and right button to take screenshot
- fix textastic greyed out markdown files, it's b/c it's Files app wont let me edit those
- Files app in iOS wont let me edit `.md` file extensions (markdowns)
    - apple case id 101308658353, https://support.apple.com/kb/HT201232
    - https://support.apple.com/en-us/HT211808 : 14.1 changelog address Files issue with cloud provider content as unavailable

## FILESYSTEMS:
----------------------------
- ISO filesystems can be mounted through disk utitlity application
- MacFUSE defunct, used to be only way to mount NTFS
- MacFUSE replaced by OSXFuse (FUSE = Filesystem in USErland)
    - with Fuse-ext2, can mount a ext2/3/4 filesystem
- NTFS:
    - ntfs-3g is free cli util to mount NTFS partitions for read/write
    - best paid option is probably Paragon
- mount samba share in osx
    mount -t smbfs //someuser@192.168.1.1/folder destfolder/
    mount -t smbfs smb://someuser:somepass@192.168.1.1111/folder destfolder/
- mount afp share in osx
    mount -t afp afp://someuser:somepass@192.168.1.4/folder destfolder/
- Finder mount, CMD+k -> someuser@192.168.1.1/folder


## OTHER:
- find out power cable watt usage and info: about-this-mac -> system-info -> power
    - https://discussions.apple.com/thread/8008792
- options key in osx is same as alt key in other Oses (like windows)
- function keys go up to f19, not f20-f24
    - f14, f15 are brightness up/down
    - f20 in iterm does same thing as hitting ctrl-p
- osx memory system, what is wired/active/inactive/free:
    - https://apple.stackexchange.com/questions/67031/isnt-inactive-memory-a-waste-of-resources
- how does process monitor know a process is "not responding"? how to automate CLI
    - https://superuser.com/questions/688024/how-can-i-determine-if-an-application-is-not-responding
- spotify shortcuts
    - https://support.spotify.com/us/using_spotify/system_settings/keyboard-shortcuts/
    - cmd-left/right next/prev song, cmd-up/down vol up/down, cmd-shift-up max volume, cmd-shift-down mute
- option + wifiicon(menu bar) - show diagnostic info like MAC and RSSI of wifi
    - also option + bluetoothicon
- shift + cmd + [/]    - move back/forward "tabs"
    - works with iterm2 tabs, chrome tabs, whatsapp convos
- option + cmd + esc  - bring up force quit menu for applications
- ctrl left/right arrow   - left/right desktops
    - ctrl 1/2          - move to desktop 1/2
- cmd-/  - highlight the cursor, iterm thing, not vim
- hold command mac key, hover over link, clickable
    - works in iterm and terminal
- microsoft word ctrl-h doesnt work, it opens a find and replace
- ~/Library/LaunchAgents - user dir of plist files for starting processes at user login

## GUI Components:
- menu bar                - top screen bar with apple menu on left, app menus, status menu and date/user on right
- notification center     - side bar (by default) with widgets for weather and stocks and notifs and so on
- dock                    - bottom (by default) panel with app shortcuts

## APPLESCRIPT
- shell script inline applescript with multiline in one line example
    ```zsh
    function osx_spotify_dec_volume() {
        osascript -e 'tell application "Spotify"' -e 'set sound volume to (sound volume - 10)' -e 'end tell'
    }
    ```
