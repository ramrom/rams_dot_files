# LINUX STUFF
--------------------------
- udev, as of kernel 2.6, it replaces DevFS(device file system)
    - identify devices based on properties (e.g. vendor ID and device ID) dynamically
    - runs in userspace, devfs runs in kernelspace
    - kernel reports events to udev daemon, udev daemon does actions based on configured rules in response
    - specify rules what on how to identify device, regardless of what port it's plugged into
        - e.g. plug in same device into diff usb ports and see `/dev/foo` and not `/dev/usb0`/`dev/usb1`
- device drivers are basically part of the kernel (prolly make up 50% of the code or more)

# UBUNTU/DEBIAN:
-----------------------------------------
- lsb_release -a        - show distro name and version
    - LTS releases every 2 years, support for 5 years
    - regular releases every year, support for 9 months
- cat /etc/issue        - show distro and version
- `lscpu` or `cat /proc/cpuinfo` for cpu info
- `ldd /some/executable` - see all .so (shared objects, dynamically linked libraries) dependency files of an executable
- shared/dynamic libs in linux: https://developer.ibm.com/technologies/linux/tutorials/l-dynamic-libraries/
- ctr + alt + FnX - switch to tty x
- when you boot, hit escape to go into GRUB bootloader for boot options (can do recovery mode)
- dash is used as /bin/sh b/c it's much faster than bash, so boots are faster
    - it doesnt have command completion, or ctrl-r search, or command history search, as this would make the shell slow
- cron: task scheduler, great site: https://crontab.guru/

sudo shutdown -h now (halt now)
sudo shutdown -k (kick everyone off and login disabled, no halting)
sudo shutdown -r now (reboot now)

lsof +f -- /media/usb0   - assuming usb0 is root of filesystem, shows all proceses with file handles in that system
xdg-open    - like osx "open", will open file with default application for that file type
xdg-mime query default text/html    - query the default x app to open a given mimetype
xclip       - like osx pbpaste/bcopy, needs a DISPLAY set
    - `xclip -selection clipboard`    - copy to clipboard
    - `xclip -selection clipboard -o` - paste from clipboard

## USER STUFF
---------------------------------------
su - foouser               - login as foouser (need to enter foouser password)
sudo -u foouser cmd         - run command `cmd` as foouser
sudo -u foouser bash         - basically login as foouser, since `bash` cmd here starts a shell process
sudo useradd foouser        - create new user with home dir
sudo passwd foouser         - change users password, seems to bypass strength rules
sudo useradd foouser foogroup    - add existing user to new group
sudo useradd foosuer sudo       - will properly add user to group sudo and some others, for sudo access


## SYSTEMD
-------------------------------------------
- great wiki on it: https://wiki.archlinux.org/index.php/Systemd
- inspired by and basically a ripoff of osx's launchd
- makes heavy uses of messages and events, using dbus
- good comment by arch linux init maintainer on why systemd is good:
    - https://www.reddit.com/r/archlinux/comments/4lzxs3/why_did_archlinux_embrace_systemd/
- supports explicit order with After/Before directives: e.g. if unit2 has `After=unit1.service`, unit1 is up b4 unit2 started
    - sysV, a service config has to explicity specify sequence #, systemd the sequence by reading unit file deps/order
- supports deps with Requires directive: e.g. if unit2 has `Requires=unit1.service`, unit2 will be stopped if unit1 isnt up
- supports soft dep with Wants directive:
    - e.g. if unit2 has `Wants=unit1.service` unit1 started with unit2, if unit1 dies unit2 stays up
- base type is unit
    - service (processes/daemons), mount (filesystems), device (/dev devices), socket (sockets)
    - slice - heirarchical manage a resource of group of processes, using cgroups
    - scope - manage set of sys processes, external processes. dont fork their own. scopes not configured via unit config files
    - timer - replacement for cron basically, specify a service unit to run and a schedule for it
    - target - this unit type similar to runlelvel in sysV, so a desired state for the whole system
        - services and other units can be tied to a target, multiple targets can be active simultaneously

### SYSTEMCTL
- systemctl start/stop/restart/reload foo
    - reload doesnt stop and start the service, often is a HUP signal
- systemctl status
    - show full status of systemd with full tree
- systemctl status foo
    - show status of a unit named foo
- systemctl status foo*
    - status of all units that starts with foo
- systemctl cat foo
    - get contents of unit file defintion of foo
- systemctl list-dependencies foo
    - print a nice tree of unit dependencies for foo
- systemctl show foo
    - low levle details of units settings
- systemctl get-default
    - print the default target for the system

### JOURNALCTL
- journalctl was also by debian/ubuntu tool to access logs, in /var/log
- it is the cli util to query logs by systemd's logging service, journald
- systemd logs are stored in binary format, use journalctl to access them
journalctl -u foo
    - show full log of service foo,  "-u is unit"
journalctl -u foo.service
    - same as above, if unit is not service type need to type fully, e.g. foo.socket
journalctl -u foo -b
    - show logs since last boot
journalctl --list-boots
    - show list of times system was booted up
journalctl -f -u foounit
    - -f is follow or tail the unit's log
journalctl -f
    - tail ALL units
journalctl -n 100 -u foo
    - see just last 100 last lines for foo unit
journalctl --disk-usage
    - show disk usage of journal
journalctl --vacuum-size=200M
    - delete journal entries
journalctl --verify
    - verify integrity of logs
journalctl config file: /etc/systemd/journald.conf, can restrict max size

### LOGINCTL
- systemd bin interface for login sessions
loginctl
    - with no args is same as `loginctl list-sessions`


## SYSV (OLD INIT SYSTEM)
- uses pidfile in /var/run
- script that generally defines bin,conf/pidfile, defines start/stop/reload/status functions for ur bin
- uses the /usr/sbin/service script, e.g. `service start foo`

service script-name start/stop/restart
service --status-all

### GNONME DESKTOP SHORTCUTS
- see https://help.ubuntu.com/community/KeyboardShortcuts

super - usually the "windows" key on keyboards
super+l - lock screen
alt+ctr+t - open terminal
alt+ctr+l, super+l  - lock screen
super+tab, alt+tab  - switch between running apps
super+left/right-arrow - snap to left or right half of desktop
super+up/down-arrow - full screen, original
super + page-up/page-down - go forward/back workspaces
super + shift + page-up/page-down - move active window to next/previous workspace
super+m - toggle notif tray
shift + ctr + c - copy
shift + ctr + v - paste
alt+f2  - run command
ctrl+alt arrow - move between desktops
ctrl+alt+delete - logout
ctrl+shift+ c/p - copy and paste
super+shift+NUM  - click the NUM icon in the dash(quick launch)
- screenshots: https://help.ubuntu.com/stable/ubuntu-help/screen-shot-record.html
    - Prnt-Screen - full desktop screenshot
    - Prnt-Screen + Alt - active window screenshot
    - Prnt-Screen + shift - area select screenshot


browsers(chrome/firefox):
ctrl-tab    - cycle through tabs
ctrl-w  - close
ctrl-h  - open history
ctrl-b  - bring up bookmarks
ctrl-t  - new tab
ctrl-l  - select url bar
ctrl-r  - reload page
ctrl-click - open link in new tab
shift-click - open link in new window
space/space-shift - scroll up/down page

## APT:
------------------------------------------
### DEPENDENCIES
apt depends pkg
    - find direct deps of pkg
apt rdepends pkg
    - find reverse deps, other packages that depend on give package
apt rdepends --installed pkg
    - find packages dependent on pkg that are installed on the system
apt-rdepends pkg
    - show dependencies AND RECURSE to depth-first-search on deps of deps
apt-rdepends -r pkg
    - show reverse deps, AND RECURSE

apt-cache rdepends pkg
    - basically same as apt rdepends pkg, slightly diff info
apt-cache depends pkg
    - basically same as apt depends pkg, slightly diff info
apt-cache showpkg pkg - shows deps and reverse deps,
            shows versions, also shows SHAs and more info


apt list --installed - show installed packages
apt list --upgradable - show upgradable packages
sudo apt-get install packageName --no-upgrade  - install new pkg and dont upgrade dependend packages
sudo apt-get purge vsftpd  - remove package and config files
apt-get changelog pkg - see changelog
apt-get check  - check for broken deps
sudo apt-get autoremove pkg - remove a package and it's dependencies
sudo update-alternatives --config foopkg - select alt

### SEARCH
apt-cache search .*realregex$
    - search locally cached package info only
apt search *something*
apt-cache search --names-only .*foo.*
    - searches regex in package name only
apt search --names-only *something*
    - same

sudo apt --dry-run autoremove
    - autoremove remove uneeded pkgs
    - dry-run just shows what it would remove

sudo dpkg --remove --force-remove-reinstreq somepackage
    - remove pkg, if you see "current status 'half-installed'" error


### UNATTENDED-UPGRADE (update/upgrade security fixes)
sudo unattended-upgrade

## SNAP:
- snap invented by ubuntu, more rapid/flexible package system than .deb/apt
- snap isolates packages. each package has a filesystem mounted from a virtual loop device for it
    - snap keeps the old version of the package
- snapd runs to update (like ~ 4/day default) snap packages; https://snapcraft.io/docs/keeping-snaps-up-to-date
snap list
    - list all snap packages installed
snap refresh
    - updgrade snap packages
snap refresh --list
    - just show what snaps can be upgraded


## GRAPHICAL SYSTEMS:
- definitions: display server / display manager / window manager / desktop envrionment
    - https://unix.stackexchange.com/questions/20385/windows-managers-vs-login-managers-vs-display-managers-vs-desktop-environment
- Display servers and display managers
    - X Windowing System - core system for drawing bitmaps, X11 is latest version since 1987
    - Wayland, new (also FOSS) protocol b/w display server and clients, (often includes C implementations), to replace X
        - Weston is a reference implementation
        - good doc on architectures: https://wayland.freedesktop.org/architecture.html
- desktop environments - GNOME, KDE, XFCE
- Windows managers:
    - compiz
    - mutter(GNOME 3 uses it), particularly GNOMEShell is a plugin for mutter
    - metalicity(GNOME 2 uses it)
xrandr  - check graphics stuff
    - ssh session, i `export DISPLAY=:1` and xrandr finds displays
    - xrandr --output DP-0 --mode 2560x1440
    - off: `xrandr --output HDMI-0 --off`, on: `xrandr --output HDMI-0 --auto`
    - turn on and be left of other display: `xrandr --output HDMI-0 --auto --left-of DP-0`
wmctrl - window manager control
    - NEEDS DISPLAY VAR SET
    - display window number/ID in hexadecimal, xdotool display in decimal
    - wmctrl -l, will list all windows in window manager, wmctrl -d list desktops, wmctrl -m list name of window manager
    - -G option tells geometry info, heightxwidth, and x,y position on desktop
        - *NOTE* the height and widght are just content area
    - moving a "firefox" named window, `wmctrl -r Firefox -e '0,6,0,1040,708'`
        - can target window by ID with -i `wmctrl -i -r 0x03000003 -t 2`
    - `wmctrl - 1`, set active desktop to 1
    - `wmctrl -r Psensor -b toggle,fullscreen` , goto fullscreen
    - `wmctrl -r :ACTIVE: -b toggle,shaded` - toggle shade on active window
    - `wmctrl -c` , close window gracefull
xdotool - http://manpages.ubuntu.com/manpages/trusty/man1/xdotool.1.html
    - NEEDS DISPLAY VAR SET
    xdotool search --onlyvisible --name firefox  # say firefox is window id 123
    xdotool getwindowname 123   # should print `firefox`
    xdotool windowsize 123 800 600
    xdotool windowmove 123 0 1080
nvidia-smi - show nvidia card mem usage, gpu temp, X processes

### GNOME
- gnomeshell design: https://wiki.gnome.org/Projects/GnomeShell/Design
    - gnome panel means the top and side bar with clock/date status icons/wdigets, app shortcuts/favs
    - dash is side bar with quick launch icons and running apps
- if a GNOME shell freezes, use: `gnome-shell --replace` from a console tty or ssh session
- GNOME/gtk use emacs keys: use gnome-tweaks or https://superuser.com/questions/9950/ctrlh-as-backspace-in-linux-gui-apps
- keyboard shortcuts
    - need full path to executables, apparently no PATH set, so `/usr/bin/foo` and not just `foo`
        - some apps, like `vlc` and `spotify` work w/o full path, maybe cause they are GUI apps?
- gsettings - cli tool to get and set items in the settings menu
    - `gsettings list-schemas`, `gsettings list-recursively org.gnome.desktop.wm.keybindings`
    - can change basically any setting at cli like you could in GNOME settings menu
    - list all keyboard shortcuts
        - `gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys`
    - list just custom shortcuts
        - `gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings`
    - how to set a custom shortcut from the cli
        - https://askubuntu.com/questions/597395/how-to-set-custom-keyboard-shortcuts-from-terminal

### WINE-GRAPHICS
- protonDB, open source configuration of wine (and dxvk) settings to run windows games, developed by steam
- steam play, lets you play windows only games in linux steam, uses protonDB
- lutris, lets you play windows only games (including steam installs) and has wine configurations configured
- dxvk, vulkan implementation to provide compatibility with directx 9/10/11, to get 3d graphics support for windows games

### XSCREENSAVER
- https://www.jwz.org/xscreensaver/
- `DISPLAY=:1 xscreensaver-command --select 10` - select the 10th screensaver in program list to run now
- `.xscreensaver` config file uses `-` at beginning of program name to represent that it's unselected
    - mode values: `off` = disabled, `random` = randomly choose, `one` = just the one selected

## SOUND
--------------
- ALSA: is base sound stack for all linux distro
- pluseaudio: builds on top of ALSA, can do things like mix many sound streams together
amixer - cli for ALSA
    amixer sset Master 5%+
pulsemixer - volume manager with pulseaudio
    - https://github.com/GeorgeFilipkin/pulsemixer
    - can see input and output devices and processes using each and modify volume on each
        - can move a source(process outputting audio) to another sink(output device) or kill or mute in TUI
    pulsemixer --toggle-mute
    pulsemixer --mute
    pulsemixer --change-volume +5

## DEVICES AND FILE SYSTEMS:
------------------------------------------------
loopdevices
- regular files in a filesystem that can act as a block device, usually named something like /dev/loopX
- if this file itself has a filesystem it can be mounted, useful for mounting ISO images and such

tmpfs - ram drives, for temporary and fast storage of data in RAM

drive naming convention:
- fd - SATA, sd - SCSI/SATA, hd - IDE
- fda - first SATA drive, hdb - 2nd IDE drive
- hdb1 - 1st partition on 2nd IDE drive

- DIR conventions
    - /         - root filesystem
    - /home     - user directories
    - /export   - data shared over the network mount
    - /mnt      - temporary mount point
    - /media    - removable devices like usb (so not internal HDD)

special devices:
/dev/null   - write output to this device to throw it away
/dev/zero   - obtain null characters from this device
    - `dd if=/dev/zero of=foobar count=1024 bs=1024`, create 1 MiB file called foobar of null chars
/dev/random - generate pseduorandom numbers from this device



## OTHER LINUX/UBUNTU TOOLS:
------------------------------------------
sensors - from lm-sensors package, gives cpu/mobo temps, fan speeds, voltages
hddtemp - `sudo hddtemp /dev/sda1` - will show temp of sba1 hard drive
inxi - cli tool to spit out sys info (cpu, audio, video), `inxi -Fxxx`
stat - get metadata on a file
lsblk - show block level devices
mkfs - to format a disk partition
fdisk - show partitions and block devices, sizes, sectors
/etc/fstab - file systems mounted at boot
dmidecode - sudo this, get DMI(SMBIOS) system/hardware info, e.g. the motherboard exact chipset version
dconf  - like gsettings?
notify-send - pops up notification
`lsusb -D /dev/bus/usb/002/004`
    - get detailed info about a specific usb device
bluetoothctl - main linux cli bluetooth tool, can see device list, paired, unpaired, connect/disconnect
    - `bluetoothctl info` print trusted/paired/connected status, UUIDs of profiles, on all devices
    - `bluetoothctl info DC:0C:2D:A5:36:A9` will print info of just one device
    - `bluetoothctl` alone will start a interactive cli console session
pacmd - pulseaudio cli tool, query sound devices
    - pacmd list-sinks  # list audio out devices
    - ALSA is sound manager for kernel, can only do one stream
    - pulseaudio is userland program, can mix many
Pavucontrol - pulseaudio cli tool, CHECK IT OUT
    - simul audio streams two diff audio devices, e.g. movie with sound to hdmi, game and sound to base mobo audio dev
        - https://ubuntuforums.org/showthread.php?t=1810812
ss  - good way to see socket usage
pcsx2 -
    - keyboard map: esdf-up/dn/lft/rgt, ijkl-tri/sq/cross/circle, n-start, v-select, aw-l1/l2, ;p-r1/r2
retroarch -
    - main menu - backspace to back, up/down/left/right, (in-game) f1 show main menu
    - enter=start, p=pause, f=fullscreen, escesc=quit, space=runtimefast
    - z=a button, x=b button, h=reset state, o=toggle record movie
transmission - great torrent program
    - SETUP:
        - https://www.smarthomebeginner.com/install-transmission-web-interface-on-ubuntu-1204/
        - https://wiki.archlinux.org/index.php/transmission
    - DIRS:
        - `/usr/share/transmission/web` -> web assets
        - `/var/lib/transmission-daemon/.config/transmission-daemon` -> settings.json
    - CMDs:
        - start a magnet torrent: `transmission-remote -a "magnet:?xt...."`
            - adding double quote the magnet link
    - editing `settings.json`: https://github.com/transmission/transmission/wiki/Editing-Configuration-Files
        - `alt-speed` settings are "turtle mode", limited speed settings
            - NOTE: if you hit the turtle icon in the web GUI it will activate turtle mode but settings.json wont show
    - transmission-daemon --auth  --username foouser --password foopass --port 9091 --allowed "192.168.1.*"
        - configuring daemon with a user and allow a private address range
    - NOTE: `http://192.168.1.2:9091/transmission` and NOT `.../transmission/` with trailing slash

