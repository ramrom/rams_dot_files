# LINUX
- linus rant on app development in linux - https://www.youtube.com/watch?v=Pzl1B7nB9Kc
    > If people are using it, it's not a bug, it's a feature - Linus
- swap partition - using a filesystem generally on a HD as storage for data on RAM, usually when RAM is full
- ramdisk - area of RAM acting as a virtual filesystem, `tmpfs` and `ramfs` are the two main types
- cron: great site for deciphering a cron schedule: https://crontab.guru/
- procfs - special filesystem, an API, kernel exposes process and system info, in the `/proc` dir
    - most unix-like OSes support it, notably OSX doesn't
- cgroups - linux kernel feature (version 2.6.24+), limits/isolates resource usage(cpu/memory/disk/network) for set of processes
- namespaces - linux kernel feature, isolates sets of processes and resources
- `io_uring`, syscalls for async IO, interface added in 5.1, addresses deficiencies of Linux AIO
- shared/dynamic libs in linux: https://developer.ibm.com/technologies/linux/tutorials/l-dynamic-libraries/
- ELF - file format for binary files, used for ABI for c programs to find functions to call
    - ELF ABI specifies table of functions/symbol-table that external programs can call
- when you boot, hit escape to go into GRUB bootloader for boot options (can do recovery mode)
- dash is used as /bin/sh b/c it's much faster than bash, so boots are faster
    - it doesnt have command completion, or ctrl-r search, or command history search, as this would make the shell slow
- linus key principle is to never break kernel-to-userspace API(or ABI), that contract will always hold
    - however internal kernel APIs (and ABIs) b/w kernel components break all the time
    - so userland programs wont break but expect like your binary device driver to break over diff kernel versions

## GNU
- project started by richard stallman in 1984
- goal is to make free open source software, believes selling propietary software is immoral
- big projects
    - GIMP - Gnu image processing/editor
    - GNOME - a graphical desktop environment
        - KDE came first, but some devs didnt like that Qt wasnt totally free, so started GNOME
            - Qt is owned by trolltech, an oslo company, and offers it for free if u build free software
    - gcc/g++ - GNU compiler/toolchain for c/c++
    - Hurd - a OS, never took off as linux dominated

## UBUNTU/DEBIAN
- `lsb_release -a`        - show distro name and version
- LTS releases every 2 years, support for 5 years
- regular releases every year, support for 9 months
- june'24 - upgrading to ubuntu 23 and 24 - third party apt sources were disabled
    - apparently done not to break the upgrade

## RASPBIAN
- `rpi-imager` deb package
    - `DISPLAY=:1 rpi-imager` - launch imager
- official linux distro(based on debian) for raspberry pi
- to manually config wifi, edit `/etc/wpa_supplicant/wpa_supplicant.conf`
    - set SSID name and password
- `/boot/config.txt` contains lots of high level rapsian configs
- gpu temp celcius - `sudo vcgencmd measure_temp`
- cpu temp celcius - `cat /sys/class/thermal/thermal_zone0/temp`, divide this number by 1000
### RETROPI
- location of config files
    - gamepads - https://retropie.org.uk/forum/topic/24965/location-of-joystick-configuration-files
- home page - https://retropie.org.uk/
- from cli `emulationstation` to start retropi GUI menu
    - configured keyboard as controller but it crashed right after
- dirs/files
    - `~/RetroPie/roms/` - roms locations

## COMMON COMMANDS
- `cat /etc/issue`        - show distro and version
- `lscpu` or `cat /proc/cpuinfo` for cpu info
- `ctr` + `alt` + `FnX` - switch to tty x
    - from cli to switch to vtty2 can do: `sudo chvt 2`
```sh
sudo shutdown -h now (halt now)
sudo shutdown -k (kick everyone off and login disabled, no halting)
sudo shutdown -r now (reboot now)

lsof +f -- /media/usb0   # assuming usb0 is root of filesystem, shows all proceses with file handles in that system
xdg-open    # like osx "open", will open file with default application for that file type
xdg-mime query default text/html    # query the default x app to open a given mimetype
xclip       # like osx pbpaste/bcopy, needs a DISPLAY set
xclip -selection clipboard    # copy to clipboard
xclip -selection clipboard -o # paste from clipboard
```
- `ldd /some/executable` - see all .so (shared objects, dynamically linked libraries) dependency files of an executable


## USER STUFF
- `/etc/passwd` and `/etc/shadow`
    - `passwd` used to contain passwords, this is deprecated, security issue as u could dictionary attack it
        - file remains b/c programs like `ls` still use it
        - still contains UID, full name, home dir, default shell
    - `shadow` contains hashed passwords and other management fields, is readable only by root
```sh
su - foouser                            # login as foouser (need to enter foouser password)
sudo -u foouser cmd                      # run command `cmd` as foouser
sudo -u foouser bash                     # basically login as foouser, since `bash` cmd here starts a shell process
sudo useradd foouser                     # create new user with home dir
sudo passwd foouser                      # change any users password, seems to bypass strength rules
passwd                                   # change your password
sudo usermod -a -G foogroup foouser     # add foouser to group foogroup
sudo useradd foosuer sudo               # will properly add user to group sudo and some others, for sudo access
```

## PERMISSIONS
- group `input` - user has full control over all devices in `/dev/input`
- group `dialout` - user can admin serial ports and modems
- group `docker` - can admin the docker daemon
- group `bluetooth` - can admin bluetooth stack


## SYSTEMD
- great wiki on it: https://wiki.archlinux.org/index.php/Systemd
- inspired by and basically a ripoff of osx's launchd
- makes heavy uses of messages and events, using dbus
- good comment by arch linux init maintainer on why systemd is good:
    - https://www.reddit.com/r/archlinux/comments/4lzxs3/why_did_archlinux_embrace_systemd/
- supports explicit order with After/Before directives: e.g. if unit2 has `After=unit1.service`, unit1 is up b4 unit2 started
    - *NOTE* if `unit1` didn't start (e.g. not enabled), then `unit2` would still start, _unless_ `unit2` also had `Require=unit1.service`
    - sysV, a service config has to explicity specify sequence #, systemd the sequence by reading unit file deps/order
- supports hard deps with Requires directive: e.g. if unit2 has `Requires=unit1.service`, unit2 will be stopped if unit1 isnt up
- supports soft dep with Wants directive:
    - e.g. if unit2 has `Wants=unit1.service` unit1 started with unit2, if unit1 dies unit2 stays up
- base type is unit
    - service (processes/daemons), mount (filesystems), device (/dev devices), socket (sockets)
    - target - this unit type similar to runlelvel in sysV, so a desired state for the whole system
        - services and other units can be tied to a target, multiple targets can be active simultaneously
    - slice - heirarchical manage a resource of group of processes, using cgroups
        - can group other slices or scopes or services
    - scope - manage set of processes that are external. i.e. not started by systemd, i.e. no unit config files
        - systemd creates them using the systemd dbus API
    - timer - replacement for cron basically, specify a service unit to run and a schedule for it
- with GNOME systemd will kill any daemon processes started in the gnome session(slice), e.g. tmux(feb2023 ubunut22), with a log out
    - https://unix.stackexchange.com/questions/583283/how-to-prevent-processes-from-being-killed-when-i-log-out-of-gnome
- folders
    - most system unit files are in `/etc/systemd/system`
    - user unit files in `/etc/systemd/user` or `$HOME/.config/systemd/user`
    - `systemctl enable someunitfile` - essentiall symlinks a unit file to appropriate place in `/etc/systemd/system`
- `systemctl daemon-reload` - reload systemd daemon, do this after editting unit files
- `systemd analyze` - verify all unit files and measure approximate startup time
- `systemctl get-default` - get the default target (probably `graphical.target` for regular desktop installs)
    - `sudo systemctl set-default multi-user.target` - set new target
- `systemd-analyze critical-chain` - print blocking tree of daemons
- `ls -al /lib/systemd/system/runlevel*` - the defined runlevel targets
### SYSTEMCTL
- systemctl start/stop/restart/reload foo
    - reload doesnt stop and start the service, often is a HUP signal
- systemctl status
    - show full status of systemd with helpful tree structure
- systemctl status foo
    - show status of a unit named foo
- systemctl status foo*
    - status of all units that starts with foo
- systemctl cat foo
    - get contents of unit file defintion of foo
- systemctl list-dependencies foo
    - print a nice tree of unit dependencies for foo
- systemctl show foo
    - low level details of units settings
- systemctl get-default
    - print the default target for the system
### JOURNALCTL
- journalctl was also by debian/ubuntu tool to access logs, in /var/log
- it is the cli util to query logs by systemd's logging service, journald
- systemd logs are stored in binary format, use journalctl to access them
journalctl -u foo
    - show full log of service foo,  "-u is unit"
journalctl -x -u foo
    - -x(--catalog) mean show any additional explanation
journalctl -u foo.service
    - same as above, if unit is not service type need to type fully, e.g. foo.socket
journalctl -u foo -b
    - show logs since last boot
journalctl -b -1 -e
    - show logs of boot before current (e.g. -2 would from 2 boots ago)
    - -e means jump to end of pager
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
### NETWORKCTL
- cli to talk to `systemd-networkd`, a network manager
- `networkctl list` - or no args will list all network interfaces and brief status
- `networkctl status` - more detailed info on each interface
### LOGINCTL
- systemd bin interface for login sessions
loginctl
    - with no args is same as `loginctl list-sessions`

## LOGS
- `/var/log/dist-upgrade/` ->  folder with dist-upgrade details
- `/var/log/auth.log` -> logins (console, tty, ssh, etc)
- journalctl handles a ton of logs now, including logs before a crash


## SYSV (OLD INIT SYSTEM)
- cheat sheet of sysv command equivalents in systemd: https://fedoraproject.org/wiki/SysVinit_to_Systemd_Cheatsheet
- uses pidfile in /var/run
- script that generally defines bin,conf/pidfile, defines start/stop/reload/status functions for ur bin
- uses the /usr/sbin/service script, e.g. `service start foo`

service script-name start/stop/restart
service --status-all


## APT
- see history in `/var/log/apt/history.log`
### DEPENDENCIES
apt depends pkg
    - find direct deps of pkg
apt rdepends pkg
    - find reverse deps, other packages that depend on give package
    - apt rdepends --installed pkg
        - find packages dependent on pkg that are installed on the system
apt-rdepends pkg
    - r here is "recursive"
    - show dependencies with depth-first-search on deps of deps
apt-rdepends -r pkg
    - show reverse deps and recursive depth-first search

apt-cache policy
    - print the apt sources and some details
apt-cache policy somepackage
    - show what version of a package each source makes available
apt-cache rdepends pkg
    - basically same as apt rdepends pkg, slightly diff info
apt-cache depends pkg
    - basically same as apt depends pkg, slightly diff info
apt-cache showpkg pkg - shows deps and reverse deps,
            shows versions, also shows SHAs and more info
### OTHER COMMANDS
- apt list --installed - show installed packages
- apt list --upgradable - show upgradable packages
- sudo apt-get install packageName --no-upgrade  - install new pkg and dont upgrade dependend packages
- sudo apt-get purge vsftpd  - remove package and config files
- apt-get changelog pkg - see changelog
- apt-get check  - check for broken deps
- sudo apt-get autoremove pkg - remove a package and it's dependencies
- sudo update-alternatives --config foopkg - select alt
### SEARCHING
- apt-cache search .*realregex$
    - search locally cached package info only
- apt search *something*
- apt-cache search --names-only .*foo.*
    - searches regex in package name only
- apt search --names-only *something*
    - same
- sudo apt --dry-run autoremove
    - autoremove remove uneeded pkgs
    - dry-run just shows what it would remove
- sudo dpkg --remove --force-remove-reinstreq somepackage
    - remove pkg, if you see "current status 'half-installed'" error


### UNATTENDED-UPGRADE (update/upgrade security fixes)
- `sudo unattended-upgrade`

## SNAP
- snap invented by ubuntu, more rapid/flexible package system than .deb/apt
- snap isolates packages. each package has a filesystem mounted from a virtual loop device for it
    - snap keeps the old version of the package
- snapd runs to update (like ~ 4/day default) snap packages; https://snapcraft.io/docs/keeping-snaps-up-to-date
- snapstore is propietary and owned by canonical and only place to get snaps
- mar2023 - looks like snaps are generally slower thank flatpak or appimage for many apps, definitely graphical apps
- commands
    - `snap list`
        - list all snap packages installed
    - `snap refresh`
        - updgrade snap packages
    - `snap refresh --list`
        - just show what snaps can be upgraded

## FLATPAK
- similar to snap but supported as main app packager by most linux distros other than ubuntu
- many flatpak stores to choose from

## GRAPHICAL SYSTEMS
- definitions: display server / display manager / window manager / desktop envrionment
    - https://unix.stackexchange.com/questions/20385/windows-managers-vs-login-managers-vs-display-managers-vs-desktop-environment
- Display servers and display managers
    - `XDG_SESSION_TYPE` env var will generally tell u if it's tty or wayland or x11
    - X Windowing System - core system for drawing bitmaps, X11 is latest version since 1987
    - Wayland, new (also FOSS) protocol b/w display server and clients, (often includes C implementations), to replace X
        - Weston is a reference implementation
        - good doc on architectures: https://wayland.freedesktop.org/architecture.html
- desktop environments - GNOME, KDE, XFCE
- Windows managers:
    - compiz
    - mutter(GNOME 3 uses it), particularly GNOMEShell is a plugin for mutter
    - metalicity(GNOME 2 uses it)
- DISPLAY env var
    - `who` will show users logged in and the `FROM` column will show where, if you see just `:1` that's the DISPLAY value of X session
- xrandr  - check graphics stuff
    - ssh session, i `export DISPLAY=:1` and xrandr finds displays
    - xrandr --output DP-0 --mode 2560x1440
    - off: `xrandr --output HDMI-0 --off`, on: `xrandr --output HDMI-0 --auto`
    - turn on and be left of other display: `xrandr --output HDMI-0 --auto --left-of DP-0`
- wmctrl - window manager control
    - NEEDS DISPLAY VAR SET
    - display window number/ID in hexadecimal, xdotool display in decimal
    - `wmctrl -l`, will list all windows in window manager, `wmctrl -d` list desktops, `wmctrl -m` list name of window manager
    - `-G` option tells geometry info, heightxwidth, and x,y position on desktop
        - *NOTE* the height and widght are just content area
    - moving a "firefox" named window, `wmctrl -r Firefox -e '0,6,0,1040,708'`
        - can target window by ID with -i `wmctrl -i -r 0x03000003 -t 2`
    - `wmctrl - 1`, set active desktop to 1
    - `wmctrl -r Psensor -b toggle,fullscreen` , goto fullscreen
    - `wmctrl -r :ACTIVE: -b toggle,shaded` - toggle shade on active window
    - `wmctrl -c` , close window gracefull
- xdotool - http://manpages.ubuntu.com/manpages/trusty/man1/xdotool.1.html
    - NEEDS DISPLAY VAR SET
    xdotool search --onlyvisible --name firefox  # say firefox is window id 123
    xdotool getwindowname 123   # should print `firefox`
    xdotool windowsize 123 800 600
    xdotool windowmove 123 0 1080
- nvidia-smi - show nvidia card mem usage, gpu temp, X processes
    - cli tool uses the [NVML](https://developer.nvidia.com/management-library-nvml) library
- nvidia-xconfig - show nvidia config
    - `nvidia-xconfig --query-gpu-info` - get basic gpu info

### GNOME
- gnomeshell design: https://wiki.gnome.org/Projects/GnomeShell/Design
    - gnome panel means the top and side bar with clock/date status icons/wdigets, app shortcuts/favs
        - appindicators mean icons in this panel of running apps with their status, can click with dropdown menus
    - dash is side bar with quick launch icons and running apps
- if a GNOME shell freezes, use: `gnome-shell --replace` from a console tty or ssh session
- GNOME/gtk use emacs keys: use gnome-tweaks or https://superuser.com/questions/9950/ctrlh-as-backspace-in-linux-gui-apps
- extensions management in browser: https://extensions.gnome.org/
- keyboard shortcuts
    - https://wiki.gnome.org/Design/OS/KeyboardShortcuts
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
- `Startup Applications` - run commands and programs at startup
    - will create `.desktop` files in `~/.config/autostart` folder
- copy + paste
    - press mouse wheel button to copy text and to paste text
    - `ctrl + c/v` work but not when involving terminal
    - `shift + ctrl + c/v` when coping from terminal or pasting to terminal
        - due to quirk of my setup(emacs keys?) press `ctrl`, then `shift`, then `c/v`
- common Tools
    - nautilus is the file explorer
    - ubuntu22 - uses RDP for gnome remote desktop

### GNONME DESKTOP SHORTCUTS
- see https://help.ubuntu.com/community/KeyboardShortcuts
- super - usually the "windows" key on keyboards
- alt+ctr+t - open terminal
- alt+ctr+l, super+l  - lock screen
- super+tab, alt+tab  - switch between running apps
- super+left/right-arrow - snap to left or right half of desktop
- super+home - switch to 1st workspace
- super+up/down-arrow - full screen, original
- super + page-up/page-down - go forward/back workspaces
- super + shift + page-up/page-down - move active window to next/previous workspace
- super+m - toggle notif tray
- shift + ctr + c - copy
- shift + ctr + v - paste
- alt+f2  - bring up prompt to run a shell command
- ctrl+alt arrow - move between desktops
- ctrl+alt+delete - logout
- ctrl+shift+ c/p - copy and paste
- super+NUM  - click the NUM icon in the dash(quick launch)
- screenshots: https://help.ubuntu.com/stable/ubuntu-help/screen-shot-record.html
    - Prnt-Screen - full desktop screenshot
    - Prnt-Screen + Alt - active window screenshot
    - Prnt-Screen + shift - area select screenshot
#### BROWSERS(CHROME/FIREFOX)
- ctrl-tab    - cycle through tabs
- ctrl-w  - close
- ctrl-h  - open history
- ctrl-b  - bring up bookmarks
- ctrl-t  - new tab
- ctrl-l  - select url bar
- ctrl-r  - reload page
- ctrl-click - open link in new tab
- shift-click - open link in new window
- space/space-shift - scroll up/down page

### WINE-GRAPHICS
- protonDB, open source configuration of wine (and dxvk) settings to run windows games, developed by steam
- steam play, lets you play windows only games in linux steam, uses protonDB
- lutris, lets you play windows only games (including steam installs) and has wine configurations configured
- dxvk, vulkan implementation to provide compatibility with directx 9/10/11, to get 3d graphics support for windows games

### XSCREENSAVER
- https://www.jwz.org/xscreensaver/
- it's in the name, designed for X, but compatible with wayland through XWayland compatibility lib
    - it works well on ubuntu22 GNOME/wayland
- https://linux.die.net/man/1/xscreensaver-command - CLI tool
    - `DISPLAY=:1 xscreensaver-command -select 10` - select the 10th screensaver in program list to run now
    - `DISPLAY=:1 xscreensaver-command -deactivate` - stop currently running screensaver, `activate` is opposite
    - `DISPLAY=:1 xscreensaver-command -exit` - stop the screensaver daemon
- `.xscreensaver` config file uses `-` at beginning of program name to represent that it's unselected
    - mode values: `off` = disabled, `random` = randomly choose, `one` = just the one selected

## DBUS
- message bus standard that is used for IPC
    - has messages with data formats, unlike most IPC which is raw bytes
    - can be publish-subscribe (service broadcast to listening clients) or one-to-one request/response
- implementations include: freedesktop.orgs ref impl, GDBus(GNOME), QtDBus(Qt), dbus-java, sd-bus(systemd)
- good short desc of it's function: https://www.cardinalpeak.com/blog/using-dbus-in-embedded-linux
- `busctl` - cli to introspect the bus
    - `sudo busctl monitor org.bluez` - see all live events for bus name `org.bluez`
    - `busctl introspect org.bluez /org/bluez/hci0`  - show interfaces/methods/properties on object `/org/bluez/hci0`

## NETWORK
- `netplan` - reads a YAML file describing network layout/config and renders it to a network script
    - either NetworkManager or systemd-networkd instruct netplan what output format to use 
    - ubuntu16 and later use netplan
    - yaml configs should live in `/etc/netplan/*.yaml`
- NetworkManager vs systemd-networkd - two competing network managers
    - NetworkManager is intended more for desktops
- `/etc/resolv.conf` - traditional static conf file for DNS servers, often updated with DHCP client hooks
    - for systemd use `systemd-resolved`
- https://en.wikipedia.org/wiki/Netfilter
    - linux framework for most network related things like NAT and firewall and more
- `iptables` - userspace bin
    - `iptables -L` - list all rules as table
        - `iptables -L --line-numbers` - by line number
    - `iptables -D INPUT 2` - drop `INPUT` rule 2
        - `iptables -F INPUT` - flush(drop) all rules in INPUT chain
        - `iptables -F` - flush all rules
    - `iptables -S` - list all rules by specification

## SOUND
- ALSA: is base sound stack for all linux distro
- pluseaudio - builds on top of ALSA, can do things like mix many sound streams together
- pipewire - aims to fix deficencies of pulseaudio, default sound server in ubuntu22, fedora34
    - originally called pulsevideo, and for video. devs renamed it and decided to handle audio
amixer - cli for ALSA
    amixer sset Master 5%+
pulsemixer - volume manager with pulseaudio
    - https://github.com/GeorgeFilipkin/pulsemixer
    - can see input and output devices and processes using each and modify volume on each
        - can move a source(process outputting audio) to another sink(output device) or kill or mute in TUI
    - `pulsemixer --toggle-mute`
    - `pulsemixer --mute`
    - `pulsemixer --change-volume +5`

## KERNEL MODULES
- can be dynamically loaded/unloaded from kernel at runtime
- great for easily removing/adding device drivers without rebooting
    - so needed for things like usb storage drives, usb bluetooth devices, basically any usb dongle device

## DEVICES
- kernel drivers interact directly with hardware
    - handle all hardware devices like: graphics cards, NICs, keyboards/mice, sound card, etc.
    - they are loaded with kernel code at boot, in kernel privileged mode
- device drivers are basically part of the kernel (prolly make up 50% of the code or more)
    - old hardware support does get removed but conservatively, e.g. kernel3.8 removed i386 intel support
- `hidraw` - raw data access to HID(human interface device)s - https://docs.kernel.org/hid/hidraw.html
- `udev`, as of kernel 2.6, it replaces DevFS(device file system)
    - `udevadm` - cli tool to see events, monitor devices, list attribs
    - identify devices based on properties (e.g. vendor ID and device ID) dynamically
    - runs in userspace, devFS runs in kernelspace
    - kernel reports events to udev daemon, udev daemon does actions based on configured rules in response
    - specify rules what on how to identify device, regardless of what port it's plugged into
        - e.g. plug in same device into diff usb ports and see `/dev/foo` and not `/dev/usb0`/`dev/usb1`
- loop devices
    - regular files in a filesystem that can act as a block device, usually named something like `/dev/loopX`
- if this file itself has a filesystem it can be mounted, useful for mounting ISO images and such
- `tmpfs` - ram drives, for temporary and fast storage of data in RAM
- drive naming convention
    - fd - SATA, sd - SCSI/SATA, hd - IDE
    - fda - first SATA drive, hdb - 2nd IDE drive
    - hdb1 - 1st partition on 2nd IDE drive
### SPECIAL DEVICES
- /dev/null   - write output to this device to throw it away
- /dev/zero   - obtain null characters from this device
    - `dd if=/dev/zero of=foobar count=1024 bs=1024`, create 1 MiB file called foobar of null chars
- /dev/random - generate pseduorandom numbers from this device
### GRAPHIC DEVICES
- nvidia propietary drivers - https://wiki.gentoo.org/wiki/NVIDIA/nvidia-drivers
    - drivers compiled against kernel: composed of a kernel module and X11 driver
- ubuntu(like around 2022) - uses nouveau open source drivers as default if nvidia GPU exists


## FILE SYSTEMS
- file ownership
    - kernel only understand numeric UID and GID
    - when `ls -l` shows names, it's b/c it's mapping UID and GID to names in `/etc/passwd`
### DIR CONVENTIONS
- see FHS(linux filesystem hierarchy standard): https://www.pathname.com/fhs/
- /         - root filesystem
- /usr      - UserSystemResources(not! user)
    - /usr/lib - shared libs for usr executables (e.g. gtk, qt, language runtimes)
- /sbin     - system binaries/executables, generally run by root for core sys stuff like sshd, iptable
- /bin      - executables
- /etc      - config files (fstab, ssh_config, etc)
- /home     - user directories
- /root     - home dir for root user
- /dev      - devices themselves
- /sys      - info on devices, drivers, kernel modules (similar to proc but maybe better)
- /proc     - psuedo filesystem that shows details on process info and general system info
- /lib      - shared libraries between different binaries for core system executables, e.g. for booting up
- /mnt      - temporary mount point
- /var      - sys specific variable(changing) files: logs, spool files, web server data files
- /run      - volatile runtime info (user session, systemd session)
- /export   - data shared over the network mount
- /media    - removable devices like usb (so not internal HDD)

## KERNEL API
- epoll
    - kernel add fd to ready list without waiting for process to call `epoll_wait`
    - when process call `epoll_wait` kernel just returns ready list
    - good blog - https://copyconstruct.medium.com/the-method-to-epolls-madness-d9d2d6378642
- select/poll - kernel has to scan all N items when it's asked by process
    - and a full list of N items is returned, so process has to scan all to find ready ones


## OTHER LINUX/UBUNTU TOOLS
- sensors - from lm-sensors package, gives cpu/mobo temps, fan speeds, voltages
- hddtemp - `sudo hddtemp /dev/sda1` - will show temp of sba1 hard drive
    - *NOTE* dec2022 - old and unmaintained, removed from debian and ubuntu22
- smartmontools - query SMART device, e.g. HDDs and SSDs
    - can do `smartctl -A /dev/sda` to get temperature (since hddtemp id deprecated)
- dmidecode - sudo this, get DMI(SMBIOS) system/hardware info, e.g. the motherboard exact chipset version
- inxi - cli tool to spit out sys info (cpu, audio, video), `inxi -Fxxx`
- lshw - like inxi, display lots of sys info
    - `sudo lshw -C display` - show only info about display/GPU
- lsusb - `lsusb -D /dev/bus/usb/002/004`
    - get detailed info about a specific usb device
- lspci - ls on pci and bus devices
- lsblk - show block level devices
- stat - get metadata on a file
- mkfs - to format a disk partition
- fdisk - show partitions and block devices, sizes, sectors
- /etc/fstab - file systems mounted at boot
- efibootmgr - UEFI boot manager, list boot devices and order, change order, delete boot option
- dkms - cli for dynamic kernel modules
    - `dkms status` - list all loaded kernel modules and show status
- lsmod - show status of kernel modules
- modprobe - add/remove modules from linux kernel
- udevadm - query info about udev events
    - `udevadm info -a -n /dev/nvme0` - show info about device
- dmesg - kernel ring buffer, print messages or control it
- dconf  - sorta related to gsettings, configure database for settings
- iwlist - get info on wireless(wifi) lan
    - `iwlist wlan0 scan` (`wlan0` being wifi intface name) will show all wifis, base frequency, channel, signal stregnth, SSID name, etc
- notify-send - pops up notification
- upower - sys util, get power/battery info and stats about devices
- bluetoothctl - main linux cli bluetooth tool, can see device list, paired, unpaired, connect/disconnect
    - `bluetoothctl info` print trusted/paired/connected status, UUIDs of profiles, on all devices
    - `bluetoothctl info DC:0C:2D:A5:36:A9` will print info of just one device
    - `bluetoothctl` alone will start a interactive cli console session
- https://askubuntu.com/questions/557906/problem-starting-jack-server-jack-server-is-not-running-or-cannot-be-started
- `pulseaudio` - `pulseaudio --kill` and `pulseaudio --start` to restart
- hciconfig - config bluetooth devices
    - `hciconfig -a` - print all info of bluetooth controllers
    - `hciconfig hci0 down` - turn off bluetooth controller `hci0`
        - in ubuntu settings the bluetooth toggle button will also turn off (it reads this devices state)
- jstest-gtk - decent util to test and configure gamepad/game-controllers
- pacmd - pulseaudio cli tool, query sound devices
    - pacmd list-sinks  # list audio out devices
    - ALSA is sound manager for kernel, can only do one stream
    - pulseaudio is userland program, can mix many
- Pavucontrol - pulseaudio cli tool, CHECK IT OUT
    - simul audio streams two diff audio devices, e.g. movie with sound to hdmi, game and sound to base mobo audio dev
        - https://ubuntuforums.org/showthread.php?t=1810812
- ss  - good way to see socket usage
- pcsx2
    - keyboard map: esdf-up/dn/lft/rgt, ijkl-tri/sq/cross/circle, n-start, v-select, aw-l1/l2, ;p-r1/r2
- retroarch
    - main menu - backspace to back, up/down/left/right, (in-game) f1 show main menu
    - enter=start, p=pause, f=fullscreen, escesc=quit, space=runtimefast
    - z=a button, x=b button, h=reset state, o=toggle record movie
- transmission - great torrent program
    - SETUP
        - https://www.smarthomebeginner.com/install-transmission-web-interface-on-ubuntu-1204/
        - https://wiki.archlinux.org/index.php/transmission
    - DIRS
        - `/usr/share/transmission/web` -> web assets
        - `/var/lib/transmission-daemon/.config/transmission-daemon` -> settings.json
    - CMDs
        - start a magnet torrent: `transmission-remote -a "magnet:?xt...."`
            - adding double quote the magnet link
    - editing `settings.json`: https://github.com/transmission/transmission/wiki/Editing-Configuration-Files
        - `alt-speed` settings are "turtle mode", limited speed settings
            - NOTE: if you hit the turtle icon in the web GUI it will activate turtle mode but settings.json wont show
    - transmission-daemon --auth  --username foouser --password foopass --port 9091 --allowed "192.168.1.*"
        - configuring daemon with a user and allow a private address range
    - NOTE: to access GUI: use `http://192.168.1.2:9091/transmission` and NOT `.../transmission/` with trailing slash
- vlc
    - play media at cli and quit `vlc somefile.mp3 vlc://quit`
    - enable log file: `tools`->`preferences`->select `all` in show settings
        - under `logger`, enable it, set level and filename (defaults to home dir location)
        - restart vlc
