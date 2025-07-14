# OSX CHEATSHEET
- cmd + option + hover over scale image in display in sys prefs   - show the resolution
- option + click on "scaled" radio buttton in display will bring up granular resolutions supported
    - https://apple.stackexchange.com/questions/194101/what-are-the-effective-scaling-modes-on-osx-with-a-4k-display-is-an-effective-r
- AppleID/icloud security two-factor auth: https://support.apple.com/en-us/HT204915
    - is required (can't turn it off in https://appleid.apple.com)
    - looks like the 2nd factor will pop up a 6 digit code in a trusted device, and if none maybe the trusted ph #?
- safari mac: bring up seperate window for dev tools - `cmd` + `shift` + `j`
- set default browser -> system prefs -> desktop+dock -> default web browser (select browser from dropdown)

## HARDWARE
### M PROCESSORS
- M2 - 4 high-performance cores, 4 high-efficiency cores, 8/16/24 GB unified DDR5 memory
    - 10 GPU cores, each has 16 EU(execution units), each EU has 8 ALUs
    - 16core neural network chip
    - also has an image signal processor, USB4 controller, thunderbolt 3/4, PCI Express storage controller
- M2/M1 support OpenGL 4.6 and OpenGL ES 3.2
- generally vulkan support wont exist b/c they don't want a dependency from chronos

## BREW
### TERMINOLOGY
- see https://docs.brew.sh/Formula-Cookbook#homebrew-terminology
- cask: installs a program exactly as if it were a native osx appliation install
- caskroom: directory containing one or more named casks
- formula: a package definition written in ruby DSL
    - e.g. `/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/f/foo.rb`
- tap: directory (and usually Git repository) of formulae, casks and/or external commands
    - `/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core`
- cellar: directory containing one or more named racks
    - e.g. `/usr/local/Cellar`
- rack: directory containing one or more versioned kegs
    - e.g. `/usr/local/Cellar/foo`
- keg: installation destination directory of a given formula version
    - e.g. `/usr/local/Cellar/foo/0.1`
- bottle: pre-built keg poured into a rack of the Cellar instead of building from upstream sources
    - generally pre-compiled code
### INFO
- aug2022, base bin dir is `/opt/homebrew/bin`
### USEFUL COMMANDS
- `brew --prefix` - show base dir
- stop brew from auto update:
    `HOMEBREW_NO_AUTO_UPDATE=1 brew install somepackage`
- show deps of httpie in tree output
    - `brew deps --tree httpie`
- show all formula that need this formula
    - `brew uses --eval-all httpie`
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
- `brew list --cask`  - list all the casks
    - `brew remove --cask someformula` - to remove a cask
- `brew services` -> list services
- `brew services start redis` -> start a service
- `brew info foo` - get status of a formula, is it installed, it's required deps, size, is it a bottle, etc.
- `brew ls foo` - get install locations of a formula
### PACKAGES
- colima - Containers on LIMA (linux on mac) `brew install colima`
    - need to cd to `~/.docker/run/` and `ln -s ~/.colima/default/docker.sock` - otherwise cant find docker daemon


## CLI
- reference: https://www.mitchchn.me/2014/os-x-terminal/
- 2024 - cool keyboard customizer for osx - https://karabiner-elements.pqrs.org/
- force color to pipe output, be default ls wont colorize
    - `CLICOLOR_FORCE=1 ls -l | less`
- `say` - speech synth to audio out a sentence
    - supports speaking a file like "say -f prose.txt -o audobook.aiff"
        - -o will save it to an audio file
- `screencapture` - capture screenshot images
- `mdfind` - cli way to find whatever spotlight does
- `open` - open a app like u would double click on it
    - open an app by name: `open -a "Slack"`
    - open a dir in Finder: `open somedir` or `open .`(cur dir)
- `pbcopy`  - cli way to copy to sys clipboard
    - lal | pbcopy   (copy ls long listing to clipboard)
- `pbpaste` - cli way to paste from clipboard
    - pbpaste | grep foo
- `mdls`    - get metadata on a file
- `sudo powermetrics`  - spits out thermals and LOTS of info, network usage, gpu usage, etc
- `vm_stat` - show some raw memory usage
- `nettop` - like top but for tcp/udp sockets only and their bandwidth usage!
- `wdutil` - get wireless diag info, dump temp wifi logs
- `skhd`
    - `launchctl list` to see skhd service is running
        - *DEPRECATED* oct'24 - `brew services` to see if it's running
    - `skhd -r` to reload config file with shortcuts
- `lp` - print from command line
- `launchctl` - the cli tool that talks to `launchd`, which control apples background daemons(aka services)
    - see list of daemons - `launchctl list`
    - e.g. start/stop dockerdameon `sudo launchctl stop com.docker.docker`
- `spctl` - controls Gatekeeper, which is the security system that checks if an app is signed by a trusted developer
    - `spctl --status` - check if Gatekeeper is enabled
    - `spctl --master-disable` - disable Gatekeeper
    - `spctl --master-enable` - enable Gatekeeper

## LAUNCHD
- `launchd` is a management system which control apples background daemons(aka services)
- see https://support.apple.com/guide/terminal/script-management-with-launchd-apdc6c1077b-5d5d-4d35-9c19-60f2397b2369/mac
    - `~/Library/LaunchAgents` - user dir of plist files for starting processes at user login, i.e. autostart apps
    - `/Library/LaunchAgents` - same as above but applies to _all_ users


## KEYBOARD SHORTCUTS / HOTKEYS
- full list: https://support.apple.com/en-us/102650
- cmd + tab  - switch between apps
- cmd + space - spotlight search
- cmd + H - hide the window of active app
- cmd + N - compose new email in mail app
- cmd + J - display view options within app
    - chrome -> find: jump to selection
- cmd + L - ???
    - chrome: make url bar active field
- cmd + K - opens window related to connection to a server, clears screen in terminal/iterm
- cmd + ; - does some wierd autocompletion in terminal/iterm
- cmd + ctrl + q  - lock the screen
- cmd + W - close window
- cmd + Q - quit application
- cmd + O - open file
- cmd + T - open new tab
- cmd + C - copy
- cmd + V - paste
- cmd + X - cut
- cmd + A - select all
- cmd + Z - undo
- cmd + ,   typically bring up preferences window in many apps (chrome, spotify, slack, whatsapp, vlc, iterm)
- cmd + 1-9 - for safari/chrome/iterm select tab X
- cmd + shift + N           - open new folder in finder
- cmd + shift + 3           - screenshot
- cmd + shift + 4           - screenshot area
- cmd + shift + 4, space    - screenshot window
- cmd + ctrl + space    - bring up emoji menu in text field
- :<foo>:               - in text field typing `:` then text desc of emoji, then `:` will insert emoji
                          works in slack and whatsapp, not safari for google voice
- fn + E                - from a text box, bring up emoji window
- cmd + option + ctrl + left/right arrow - move window to next/prev display

### BROWSER
- *NOTE* these are verified in chrome and firefox
- cmd + [number]          - goto that number tab (works for 1-8), 9/0 goto rightmost tab
- cmd + forward/back-arrow  - back and forth web page history
- cmd + [/]               - back/forward page history
- cmd + up/down-arrow     - scroll up/down web page
- cmd + shift [/]         - back/forward tabs in window
- cmd + \`  (cmd + backtick) - cycle through windows
- cmd + L                 - select url bar
- cmd + option + i        - toggle open developer tools
- spacebar                - scroll down
- spacebar + shift        - scroll up
- tab/shift+tab           - goto next/prev field in browsertab+page

### WHATSAPP NATIVE
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
- iphone12: hold volume up and right button to see power off slider
- iphone12: press volume up and right button to take screenshot
- fix textastic greyed out markdown files, it's b/c it's Files app wont let me edit those
- Files app in iOS wont let me edit `.md` file extensions (markdowns)
    - apple case id 101308658353, https://support.apple.com/kb/HT201232
    - https://support.apple.com/en-us/HT211808 : 14.1 changelog address Files issue with cloud provider content as unavailable
- scanning - https://support.apple.com/en-us/108963 , can use notes app
- iphone16 - poweroff - hit vol up, hit vol down, hold down right side button

## FILESYSTEMS
- ISO filesystems can be mounted through disk utitlity application
- NTFS
    - natively has read only support
    - write support
        - https://osxdaily.com/2013/10/02/enable-ntfs-write-support-mac-os-x/
        - ntfs-3g is free cli util to mount NTFS partitions for read/write
        - best paid option is probably Paragon
- mount samba share in osx
    mount -t smbfs //someuser@192.168.1.1/folder destfolder/
    mount -t smbfs smb://someuser:somepass@192.168.1.1111/folder destfolder/
- mount afp share in osx
    mount -t afp afp://someuser:somepass@192.168.1.4/folder destfolder/
- Finder mount, CMD+k -> someuser@192.168.1.1/folder
### FUSE
- sshfs, veracrypt, and ntfs-3g programs use FUSE
- with Fuse-ext2, can mount a ext2/3/4 filesystem - https://github.com/alperakcan/fuse-ext2?tab=readme-ov-file
- aug'21 - MacFUSE issues
    - sshfs and ntfs-3g brew install fail b/c of macfuse issue (macfuse closed-source or something)
- may'22 - osxfuse rebranded to macfuse: https://github.com/osxfuse/osxfuse/issues/888
    - osxfuse github just points to macfuse: https://github.com/osxfuse/osxfuse?tab=readme-ov-file


## OTHER
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
- switch to desktop x
    - keyboard shortcuts has ctrl 1/2, nothin past 2, can turn these on
    - https://apple.stackexchange.com/questions/362614/macos-navigating-between-desktops-using-keyboard-shortcuts
- cmd-/  - highlight the cursor, iterm thing, not vim
- hold command mac key, hover over link, clickable
    - works in iterm and terminal
- microsoft word ctrl-h doesnt work, it opens a find and replace
- hostname
    - `hostname` - get the hostname, will be what tmux sees as hostname
    - `scutil --get ComputerName` - get the computer name
    - `scutil --get HostName` - get the hostname
    - `scutil --get LocalHostName` - get the local hostname

## OSX GUI COMPONENTS
- menu bar                - top screen bar with apple menu on left, app menus, status menu and date/user on right
- notification center     - side bar (by default) with widgets for weather and stocks and notifs and so on
- dock                    - bottom (by default) panel with app shortcuts

## APPLESCRIPT
- shell script inline applescript with multiline in one line example
```sh
    function osx_spotify_dec_volume() {
        osascript -e 'tell application "Spotify"' -e 'set sound volume to (sound volume - 10)' -e 'end tell'
    }
    ```
- can also add `#!/usr/bin/osascript` as first line in executable source script
