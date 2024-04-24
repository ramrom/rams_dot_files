# TECH STANDARDS AND INFO

## MULTIMEDIA CODECs
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

## PHONE STUFF
- E.164 is the international telephone numbering plan that ensures each device on the PSTN has globally unique number.
    - format is `+` + (country code) + (number in country, for US 10digit area-code+ph#)
- https://www.twilio.com/docs/glossary/what-e164
- RCS (Rich Communication Services) - next gen open standard to replace SMS/MMS on android by google
    - has group chat, rich media messages, real-time typing indicator, read receipts, end-to-end encryption, file share up to 100MB
    - some iphone supports RCS
    - google voice as of 2023 doesn't have RCS
- iMessage - next gen by Apple to replace SMS/MMS

## PROCESS SIGNALS
- most official definition - https://pubs.opengroup.org/onlinepubs/009695399/basedefs/signal.h.html
- SIGKILL - `kill -9`, forceful terminate without any cleanup
- SIGINT - `ctrl-c` - interrupt what you are doing, i.e. cancel current action, sometimes terminate the program
- SIGTERM - terminate the process, let process cleanup
- SIGQUIT - same as SIGTERM but also core dump

## ETHERNET
- https://en.wikipedia.org/wiki/Ethernet_crossover_cable#Automatic_crossover
    - generally since 1998, no need for straight vs crossover cables, ports autodetect

## WIFI
- 2.4GHz band - ch1 2412, ch6 2437, ch11 2462
### STANDARDS
- WiFi 6E, e = extended, supports 6Ghz band
- WiFi 6 to identify devices that support 802.11ax (released 2019)
- WiFi 5 to identify devices that support 802.11ac (released 2014)
- WiFi 4 to identify devices that support 802.11n  (released 2009)
- WiFi 3 to identify devices that support 802.11g (released 2003)
- WiFi 2 to identify devices that support 802.11a (released 1999)
- WiFi 1 to identify devices that support 802.11b (released 1999)
### MESH
- all nodes part of the same SSID
    - many wifi extenders use a seperate SSID for each extender
- wireless backhaul - each node in mesh uses a dedicated backhaul channel to talk to each other

## BLUETOOTH
- classic and BLE use 2.4Ghz range, 2400-2480
    - classic 79channels 32 discover channels, BLE 40channels 3discovery channels
- classic - 3Mbps max rate
    - use for file transfers, streaming
- BLE 4.2 -1Mbps max rate, 50-150m range
    - generally better for IoT sensors, device control
- bluetooth Mesh - introduced 2017
- decent basic vid on bluetooth wireless mechanism: https://www.youtube.com/watch?v=1I1vxu5qIUM
- how pairing works: https://www.bluetooth.com/blog/bluetooth-pairing-part-1-pairing-feature-exchange/

## ZIGBEE
- based on IEEE 802.15.4 standard
- supports star and tree network topologies as well as generic mesh
    - in star coordinator must be central node, mesh and tree allow router nodes to extend reach
- ch11 - ch26 between 2400Mhz - 2480Mhz
- LQI (Link Quality Indicator) - quality of data packets received
- RSS (Recieved Signal Strength) - quality of signal strength

## IOT
- Matter - is a new standard to rule all IoT for communication but still a big WIP (sept 2021)
    - https://buildwithmatter.com/
    - collaberation b/w tons of companies including big names apple, google, amazon, samsung
    - highly based on apple's homekit protocol
- Thread - networking tech that Matter is built on
    - low-power mesh network like zigbee
    - any device can be a thread edge router, it is IPv6 based
- Wifi (power hungry)
    - hub-and-spoke only, so must be near a access point
    - doesnt scale
- Z-Wave, mesh network, much slower than wifi
    - https://z-wavealliance.org/
    - stringent/strict process for certifying a defice conforms to it's standard cmds and security
        - this makes these more expensive
    - 900 MHz band (north america)
    - mesh limit of 232 devices
    - range of ~100 feet
- Zigbee, mesh network, much slower then wifi
    - no certification required, so cheaper
    - 2.4Ghz band (north america)
    - mesh limit of 65000! devices
    - range of 33-66 feet
- ONVIF - Open Network Video Interface Forum
    - create global open standards for IP-based security, particularly for video cameras
    - ONVIF.PTZ specifies Pan/Tilt/Zoom functions


## HDMI
- 50 foot MAX reliable length, really shouldn't ever exceed 25ft
    - but there are options like optical and wireless hdmi
- standard does not mandate versions be printed on cables, so only way to know is to test them...
- CEC (consumer electronics control) - protcol to control HDMI devices
- standards
    - 1.0 - supports 5Gbps
    - 1.1 - supports 5Gbps
    - 1.3 - supports 10Gbps
    - 1.4 - released 2009, supports 10Gbps
    - 2.0 - released 2013, supports 18Gbps, so one 4k@60hz
    - 2.1 - released 2017, supports 48Gbps(Ultra High Speed cables needed), can do a 10k@120hz

## USB
- usb 3.0 cable shouldn't really exceed 10 feet without repeater
- displayport cable shouldnt exceed 10 feet
- usbc supports usb 2.0 to 4.0
- usb a/b supports usb 1.0 to 3.1
    - a/b can support 2A @ 5V power, most cables are 28gauge, which can only handle .5A
- 2.0 - 480Mbps, can deliver 2.5watts power, has 4 wires
- 3.x
    - adds 5 more wires, still backwards compatible with usb2
    - 3.0(superspeed) - 5Gbps
    - 3.1gen1 - 5Gbps, 3.1gen2 - 10Gbps(uses 128b/132b)
    - using usb-c: 3.2gen1 - 10Gbps, 3.2gen2 - 20Gbps
- 4.x - suports 40Gbps

## PSU
- 80 PLUS is energystar program started in 2007 for efficiency rating, requires 80%+ efficiency at 3 diff load levels
    - different levels of rating including bronze, silver, gold

## FIBER OPTICS
- single-mode - small diameter, generally b/w 8-10micrometers
- TOSLINK - used generally for digital audio, uses plastic optical fiber, very cheap, can be 100x thicker than single-mode
    - generally half-duplex, toshiba did have a full-duplex

## SATA
- SATA 1.0: 1.5 Gb/s, 150 MB/s
- SATA 2.0: 3 Gb/s, 300 MB/s
- SATA 3.0: 6 Gb/s, 600 MB/s

## SSD
- no moving parts, use flash memory or semidconductor memory units to store data
- HDDs typically mean electromagnetic fields to store data, and moving disks with a head to read/write data
- TBW - terabytes written - amount of terabytes that can be written to drive before it fails, measure of durability/lifetime
- data density
    - SLC - single layer cells - one bit per memory cell
        - fastest and most durable, less error-prone
        - expensive per bit of data, used in enterprise
    - MLC - multi layer cells - 2 bits per memory cell
    - TLC - triple layer cells - 3 bits per meomry cell
    - QLC - quad layer cells - 4 bits per memory cell
    - PLC - penta ayer cells - 5 bits per memory cell

## COMPUTER INTERFACES
- PATA - parallel ATA(advanced technology attachment)
    - designed for magnetic spinning hard disk drives
- SATA(serial ATA) - successor to PATA
    - SATA 1 - 150 MB/s max, 2 - 300 MB/s max, 3 - 600 MB/s max
- NVME - often more than 3 times faster than SATA 3
    - uses PCIe, which can be order of magnitude faster than SATA
    - NVME devices usually use M.2 physical interface, but other like 2.5" U.2 or PCIe card slot are also used
- M.2 - interface form factor
- DMA - Direct Memory Access - a subsystem that lets hardware access sys memory without CPU intervention
    - hardware transfer to memory or vice versa directly


## CPU
- TPU - tensor processing unit - developed by google in 2015, made public in 2018, a AI ASIC specializing in tensorflow software
- ALU - arithmetic logic unit
- FPU - floating point unit
- AGU - address generation unit - fetches a value from memory
### ARCHITECTURES
### X86
- REAL MODE - CPU directly access physical memory locations, no redirection or virtual addresses
### RISC
- is a philosophy of cpu design, stands for reduced instruction set


## HDD
- LMR - longitudinal magnetic recording
- CMR(PMR) - perpendicular magnetic recording
    - 3 times more dense than LMR
    - magnetization done vertically and horizontally on platters
    - can achieve much higher than 750GB on 3.5" drive
- SMR - shingled magnetic recording
    - writes data overlapping, worse quality than CMR
    - good for archival storage
    - easy cache overflow, and slow for frequent writing

## [HTTP](http_web_tls_cheatsheet.md)

## [WEB SERVERS](http_web_tls_cheatsheet.md)

## RSS/ATOM
- RSS(Really Simple Syndication)
    - XML format
    - still more widely used than Atom
    - developed in 1999, but widespread in 2005
- Atom - developed to improve on RSS's flaws and limits


## SUBTITLES
- srt offset adjustment website: http://www.subsedit.com/simple

## CABLES
- displayport max lenghts
    - https://www.reddit.com/r/Monitors/comments/989lm2/maximum_cable_length_for_displayport/
        - don't exceed 10 feet, pretty much the limit

## MONITORS/TV
- low response time results in ghosting
- TV types
    - LED - really LED _backlit_ and LCD turns off/on pixels
    - QLED - LED with quatum dot layer behind LCD that improves color depth and brightness
    - OLED - organic LED, organic is misleading, each pixel is a seperate LED that turns on/off
        - great brightness, infinite contrast ratio, super fast response times, good viewing angles, no ghosting
        - burn in risk especially for static images, max brightness not great
- LCD types
    - TN (twisted nematic), oldest
        - fast refresh rates, short response times, high brightness -> good for gaming
            - can have response times low as 1ms
        - bad viewing angles, bad color reproduction
    - IPS (in-plane switcing), newer tech
        - great color reproduction, good viewing angle
        - slower response times, lower refresh rates
    - VA
        - good viewing angle, best constract ratio, good color repro, ok refresh rate (better than IPS), ok resonse time
        - oldest standard
- E-ink - uses charged particles moving through viscous fluid b/w two electrodes
    - requires very little power, last frame persists even with no power
    - very slow, max refresh rates like 15hz
    - each pixel is only black or white, so has to dither pixels to get greys
    - good for e-books

## COMPILERS
- LLVM is a platform for creating machine code
    - developed by the same guy who made Swift (Chris Lattner)
    - langauges that use it: Rust, Swift, Kotlin Native, objective C, Julia
    - LLVM has API that take IR (itermediate representation), then it uses that create binary(machine code) or JIT for every arch/OS
- objective C uses Clang compiler to create LLVM IR
- swift uses it's own "swift compiler" to create LLVM IR(bitcode)
- steps
    - Lexer, idenitfy tokens in text: keywords/operators/variables/etc
    - Parser - build an AST
    - Semantic Analysis - see if AST follows language rules
    - IR code generation for target machine
    - IR optimization
    - generate machine code
    - linking with symbols table
- linking
    - dynamic -> an executable loads the library at _run_ time
        - shared object, `.so`, files are dynamically linked libs
        - used often in linux, if 2 executables run and use same lib, the lib is loaded once in memory and shared by executables
    - static -> the library is included in the executable at _compile_ time
        - `.a` files (`ar` archive files of object files) are static linked libs
- c++ compilers
    1. preprocessor - process directives like `#includes` and `#define` (expanding macros)
    2. compiling - c++ code -> assembly code -> machine code, each source file essentially becoming an object file
        - c++ templates are handled at compile time, so are more semantic than macros
    3. linking - links object files together to one executable, undefined symbols are resolved to correct addresses

## EMULATORS
- compatibility https://wiki.recalbox.com/en/hardware-compatibility/emulators-compatibility

## API ARCHITECTURES
- SOAP - Simple Object Access Protocol
     - web services using XML based messaging protocol, usually over HTTP
- REST - REpresentational State Transfer
     - roy fielding created it in his dissertation to replace SOAP as model for WWW and used HTTP as reference implementation
- RPC - Remote Procedure Call

## DATA FORMATS
### TEXT
- JSON
- XML
- CSV
- TSV (tab seperated values)
### BINARY
- messagepack
- apache avro
- ProtoBufs
    - serialized data is pretty compact, integers representation can have variable bit length
- Capt'n'Proto
- flatbuffers
    - created by google, "zero-copy" serialization
### DATE/TIME
- ISO
- unix time - number of non-leap seconds since jan1-1970 UTC, can also be microseconds,nanoseconds

## DEVOPS
### TERRAFORM
- more declarative style of programming, used more for provisioning
- agentless, all the client needs is ssh server
### ANSIBLE
- more procedural style of programming, used more for configuration
- agentless, all the client needs is ssh server
- uses jinja2 (.j2 files) for templating
### DEPLOYMENT STRATEGIES
- big bang deployment - shutdown the service cluster to deploy all new versions
    - sometimes unavoidable, e.g. a intricate database upgrade
- rolling deployments - incremental deploy in same env
    - take down and upgrade each service instance at a time, so during deployment different versions exist live
- blue-green deploy - uses 2 different "environments" (e.g. 2 diff k8 clusters)
    - if blue is currently live, deploy new version of services on green, when ready switch traffic to green
    - advantage: can internally test green while ingress still serving to blue
    - advantage: can quickly rollback to old version
    - disadvantage: extra cost to have a whole dulplicate environment
- canary deploy
    - dont have a entirely seperate env (like another k8 cluster), but use spare nodes in the same cluster
    - cutover a small percentage of live traffic at a time (versus 100% in blue-green)
- feature toggle - not really a deployment, but another way to get a different version of service effectively running

## ENCRYPTION
- envelope encryption
    - DEK - data encryption key - encrypt payload/data
        - DEKs encrypted by KEK at rest, DEKs stored close to data
        - one practice to use entirely new DEK when writing data
    - KEK - key encryption key - encrypt DEK
        - store centrally

## ENCODING
### BASE64 
- 64 safe ASCII chars
- standard one is `A-Z` `a-z` `0-9` `+` `/`
- url safe one replaces `+` and `/` with `_` and `-`
### URL ECODING
- unreserved characters are `A-Z`, `a-z`, `0-9`, `-`, `_`, `.`, `~`
- https://en.wikipedia.org/wiki/Percent-encoding
### ASCII
- table - https://simple.wikipedia.org/wiki/File:ASCII-Table-wide.svg
    - basically all "regularly" used human characters encoded between 32-127
    - 48-57 is `0`-`9`, 65-90 is `A`-`Z`, 97-122 is `a`-`z`
### UNICODE
- is a description of all characters imaginable in every language, a unique character has a code point (e.g. `U+00639`)
- different implementations of unicode specify how to encode the codepoints of unicode in a file
- UTF8 - an implementation of unicode characters that's backwards compatible with ASCII
    - a UTF8 parser will fully be able to read a ASCII formatted file (but NOT vice versa)
    - all codepoints between 0-127 is encoded as one byte, code points above 128 are stored in 2,3 and up to 6 bytes
- UTF16 - uses a minimum of 2bytes, java natively uses UTF16
    - not backwards compatible with ASCII

## FLOATS
- https://en.wikipedia.org/wiki/IEEE_754-1985

## PLANTUML
- https://plantuml.com/sequence-diagram

## OpenApi / Swagger
- https://editor.swagger.io/  - good place to validate an openapi yaml file

## Smithy
- a service and SDK description language created by AWS
- https://awslabs.github.io/smithy/

## LOG FRAMEWORKS
- ELK stack - Elasticache, Logstache, Kibana
    - all developed and maintained by Elastic, all open-source
    - Logstache(aggregation+processing) -> Elasticahe(db for indexing/storing) -> Kibana(front-end for visualization/human-analysis)
- splunk is commercial solution that does all 3
    - bills/pricing revenue mainly from indexing volume

## LANGUAGES/FRAMEWORKS
- WASM - web assembly, supported my most browsers, it's a compile target supported by rust, python, kotlin, and many more
- Dart, new lang by google for front-end development, designed to be closely compatible with javascript
    - 2022 - chrome natively supports it, other browsers it's transpiled to javascript
    - 1.x is dynamic typed, 2.x is statically typed
    - also has compilers for arm or x86 code
    - uses a garbage collector
        - WasmGC(wasm + GC) will theoretically support Dart
- flutter is a cross-platform framework writtin in Dart for building mobile/client applications
    - has it's own 2D graphics library called skia, and thus has it's own widget framework
    - intended for mobile platforms and web but Flutter Desktop aims to take over desktop too
    - it's design is inspired by react, each widget/component has a render method (that returns a tree of 1+ other widgets)
    - it has it's own rendering engine, does not use native components, takes over the screen and renders each pixel
- electron is a cross-platform framework for desktop development
    - write regular web HTML5/CSS/javascript and chromium browser to render frontend and node.js for backend
    - can use javascript frameworks like react or vue
- react is a SPA framework for web browsers, built by facebook
    - uses 2 virtual DOM, changes to DOM are applied to virtual DOM
        - reconciliation - old and new virtual DOM are diffed, only changed parts are applied to real DOM
- react native lets you use your react code to build native mobile apps
    - uses C++ engine to compile react abstractions like `View` to native components for iOS or android
    - code runs in javascript engine(e.g. JavaScriptCore or Hermes) and talks to native code via messages over a bridge
- AI / Machine-learning
    - TensorFlow
    - PyTorch
- event/IO libs
    - libuv - C async lib, uses epoll/kqueue/IOCP, event ports
        - used by Node.js, neovim
    - libevent - C async lib, similar to libuv, uses callbacks on IO events
        - memcached, tmux, chrome, transmission use it
    - libev - C async lib, claims it's better than libevent

## GRAPHICS FRAMEWORK/ENGINES
- cryengine - by crytech
    - implementors: far cry
- id Tech - C++ codebase by id software
    - john carmack left in 2013, Tiago Sousa(came from crytech) took over
    - id Tech 5
        - implementors: Rage
    - id Tech 6 released 2015?, supports vulkan and openGL
        - implementors: Doom 2016
    - id Tech 7 released 2018?, supports only vulkan, ray tracing, no "main thread" (all "jobs")
        - implementors: Doom Eternal
- unreal - C++ codebase by epic games
    - 5.0 - major goal to make game content/assets easy to create
        - nanite - no LOD(level of detail) limitation, high polygon count with dynamic detail
            - import photographic source into game
        - lumen - full real-time global illumination, no manual lightmap creation for a scene
        - Niagara - fluid/particle dynamics, Chaos - physics engine

## GARBAGE COLLECTION
- reference counting
    - maintain a count of variables referencing each object
    - when reference is nil or goes out of scope, decrement count. inc count for a new reference
    - when count goes to zero, call object destructor
    - one big challenge is cyclic references, usually use a strong and weak reference count to detect these
    - consistence peformance, no major pauses like tracing, but overall overhead is prolly larger
    - need an atomic ref counter for a shared object in a multi-threaded env
- tracing
    - store list of global/root objects, and locals from main func
    - trace all other objects reachable from them
    - does not have cyclical reference issue, as a cyclical reference b/w say A <--> B can still be detected by root object unreachability
    - mark and sweep
        - go through all allocated objects, if it's not reachable deallocate it
    - pauses, especially stop-the-world pauses causes latency/jitter

## LSP
- language servers - https://langserver.org/
    - introduced in 2016 for microsoft VSC, then made an open standard
- uses JSON RPC for message passing b/w client and server
- BSP (build server protocol) - abstracts the build tool, complementary to LSP
    - LSP server can be a _client_ to build server using BSP to talk to it
    - e.g. bloop was first build server to implement BSP, scala metals lang server uses BSP to talk to bloop
- DAP (debug adapter protcol) - abstracts debugging tool, complementary to LSP

## Compilation
- `.so`, SO(shared object) files, used mostly in Linux, similar to windows DLL or OSX DYLIB(mach-o dynamic library)

## GRAPHICS
- DLSS (deep learning super sampling) - using AI to interpolate frames and thus more cheaply increase frame rates
### APIs
- Metals - apple API
- Vulkan - open source platform independent generic API for 3D graphics and computing, managed by Khronos Group
    - originally based on AMD's Mantle API
    - designed to utilize multi core better and CPUs better (vs OpenGL or old directx)
    - lower level API, similar to metals and directX 12
    - higher performance than OpenGL and Direct3D 11
- OpenGL - older 2D/3D open-source platform independent graphics API
    - started in 1992, Khronos group inherited in 2006
    - doesnt support ray tracing or video decoding
    - really being succeeded by vulkan
- DirectX - microsoft APIs for graphics and more

## GAME CONSOLES
### XBOX 
- gen 1 - xbox
- gen 2 - xbox 360
- gen 3 - xbox One, backwards compabile with xbox original and 360
- gen 4 - xbox series X/S - fully backward compatible with xbox One (and xbox 360 and original xbox)
### PS
- ps5 (gen 5) - backward compatible with most ps4 games

## LEAGUE
- north america server: 104.160.131.3
- ctrl f in league for ping
- shift + enter  - in game do a /all message

## NATIVEFIER
- set user agent so google wont yell about untrusted broswer
    - https://github.com/jiahaog/nativefier/issues/831
    - nativefier --user-agent "Mozilla/5.0 (Windows NT 10.0; rv:74.0) Gecko/20100101 Firefox/74.0" --name 'Google Hangouts' 'https://hangouts.google.com'

## BITWARDEN
- it's fully FOSS, can self host a server, has a cli, can do mobile/desktop for free (unlike lastpass)
- premium individual is $10/year, offers 2FA, emergency access, file share/upload
- autofill https://bitwarden.com/help/article/auto-fill-browser/
    - cmd+shift+Y activate extension
    - cmd+shift+L for autofill
    - cmd+shift+9 generate new password and copy to clipboard
- excluded domains: browser ext -> settings -> excluded domains
    - list of domains/sites where banner to prompt to save creds wont appear

## XBROWSWERSYNC
- full FOSS, can self host, works in firefox/chrome/brave/edge
- `ctrl + space` is shortcut to bring up extension to search bookmarks

## CLOUD DRIVES
- dropbox
    - free: limits to 3 devices to sync, no offline file access
- mega
    - no device limits, native linux/osx/windows clients, has offline file access for entire folders and all files
- google drive
    - offline access for idvidual files (and only gdocs like their spreadsheet and word doc)

## FILE TRANSFER
- snapdrop, pairdrop
- localsend, on all platforms, local only no internet, written in dart/flutter

## BOOTING
- BOOT sequence
     - POST - verify core devices work (CPU, memory, system timer, storage, keyboard)
     - boot loader to load OS kernel and run it
        - for UEFI, a disk will have a special EFI partition for this
        - for linux GRUB2(LILO is outdated) loader will put kernel in memory and let it take over
        - kernel loads all device drivers, loads kernel modules, and goes through init system(e.g. systemd)
- BIOS - basic input output system, firmware used to boostrap into a full OS, IBM PCs started with this in 1980
    - limitations vs UEFI: 16-bit real mode, only 1MB adressable space, only assembly language, no network support, and more
    - it's tied to MBR(master boot record), and limits disk size to 2TB
- UEFI - Unified Extensible Firmware Interface, a new firmware architecture to replaces BIOS
    - specifications written by the UEFI Forum
    - uses GPT (GUID partition table) and supports greater drive sizes natively
    - offers security with secure boot
    - microsoft drove adoption in 2010 b/c in win8 they wanted secure boot
- firmware - low level code that controls hardware, for PCs first loaded and bootstraps main OS
    - for embedded systems is probably main layer of code
    - stored in non-volotile memory like flash memory or EEPROM

## SYSTEM MEMORY
- for modern processors, with memory controllers, every process has it's own virtual memory address space
    - so process A and B can have a mapping for the same virtual address, but physical address obviously cant overlap

## FILE SYSTEMS
- storage device vs partition vs volume vs file system
    - physical storage devices are split into multiple partitions
        - old MBR(master boot record) is being replaced by GPT(GUID partition table) describe these
    - a volume is a logical piece of the underlying storage that the OS recognizes and can install a file system on
        - a partition could hold many volumes
        - multiple partitions could be presented as a single volume (usually called "logical" volumes)
            - RAID arrays are seen as logical volumes
### ZFS
- created by sun microsystems for solaris
- performance is great - https://arstechnica.com/gadgets/2020/05/zfs-versus-raid-eight-ironwolf-disks-two-filesystems-one-winner/
- supports encryption, compression
- does use traditional volumes, has storage pool concept for multiple drives, so it supports RAID-like features
- standard on BSD, super awesome, does basically everything well
- uses "transactional semantics" for integrity: https://docs.oracle.com/cd/E19120-01/open.solaris/817-2271/6mhupg6hh/index.html
    - better than journaling
    - ZIL - ZFS intent log
- has checksums on data and metadata
- STRUCTURE
    - high level
        - zpool - highest level in structure, has many vdevs, diff zpools cant share vdevs
        - vdev - virtual device, consistes of many real devices
            - most used for plain storage, but special types are CACHE, LOG, SPECIAL
            - 5 topolgies: RAIDz1, RAIDz2, RAIDz3, single-device, mirror
        - device - a random-access block device
            - can be anything with descriptor in `/dev` , (so entire hardware RAID array could be one device in ZFS)
    - data level
        - datasets - highest level, analagous to standard mounted filesystem
        - blocks - all data and metadata stored in blocks
        - sectors - represents small unit of data writable to physical device
### EXT4
- good article: https://opensource.com/article/18/4/ext4-filesystem
- backwards compatible with ext3 and ext2
- has 3 journaling modes(like ext3)
    - journal: writes data and metadata to journal, ordered: writes only metadata to journal, writeback: write metadata but no order, fast
        - default mode is usually ordered
### NTFS
- windows standard

## XDG
- https://github.com/adrg/xdg/blob/master/README.md
- standar for files for apps and configs

## NETWORK PROTOCOLS
### LAYER 7
- WebDAV - HTTP based protocol for data manipulation
- CalDAV - based on WebDAV for sharing and syncing calander data
    - uses iCalander format for the data
- CardDAV - protocol for sharing contact data
### ADDRESS RESOLUTION
- ARP - address resolution protocol, get layer 2(MAC) address from a given layer 3(IP) address
- InARP(inverse ARP)/RARP(Reverse ARP) - get layer 3 address from a layer 2 address
- BOOTP - superseded InARP
- DHCP - superseded BOOTP
### DNS (Domain Name System)
- A record - hostname -> IP address
    - can have many IPs for failover, if main/default IP fails, the next IPs are used round robin
- CNAME - hostname -> hostname, alias a domain to another
    - if client DNS requests returns CNAME, it continues to make requests until it gets an A name
- AAAA record - needed for IPv6
- MX record - name for email server for a domain
- TXT record - contains textual data

### NETWORK FILESYSTEM PROTOCOLS
- SSHFS uses SFTP
- SFTP is FTP over SSH
- FTPS is FTP + TLS/SSL
- AFP (apple filing protocol), NFS (unix designed), SMB/CIFS(windows designed, supported well by all)
- osx: smbv3 performs > afs ( https://photographylife.com/afp-vs-nfs-vs-smb-performance)
- CIFS/SMB info: https://linux.die.net/man/8/mount.cifs
    - `mount` will show the extensions/flags set on the samba share
    - supports hardlinks with unix extensions and/or servinfo
    - osx wont let you create hard links on samba share, but ls -i seems to recognize them fine
### NOTE!!!
samba share ver 3, nounix set, serverino set, serverino seems to sorta support hard links
hard link a file, then modify one: it shows same inode number, BUT `du -hs` shows usage for 2 files
Also when i rsync they are diff inode # files on destination

in linux if i mnt with ver=1.0, i see unix set (and serverino set), and this behavious doesnt happen
- samba 2/3 dont support hard links:
   - https://unix.stackexchange.com/questions/403509/how-to-enable-unix-file-permissions-on-samba-share-with-smb-2-0
   - https://en.wikipedia.org/wiki/Server_Message_Block
- nfs
    - best for linux-to-linux, better than smb in this case. windows and osx dont support nfs really
    - supports hard links well
- NOTE: to see flags/options/attributes on a samba share, just look at `mount` command output
- OSX samba share -v verbose
- `-o` with username(or user) does not work

## OPTIONS TRADING
- strike price - the price of the stock for which the option can be exercized at
    - "in the money" means strike price > current price for put, and current price > strike price for call
        - opposite for "out of the money"
- delta - rate of change b/w options price and $1 change in underlying assets price
- theta (decay) - measure of rate of decline of option due to passoge of time (b/c of getting closer to expiration)

## CREDIT CARDS
- magnetic stripes stores data in plaintext, including FN, LN, acc #, expiration date, security code, same data every transaction
- new EMVs (embedded chips) in cards, started in 2015, generate and exchange one time unique code for each transaction
    - EMV -> stands for europay, mastercard, visa (the 3 major networks)
- NFC - also "contactless" like EMV
    - NFC and EMV both use RF protocol, ISO 14443 B

## AUTHENTICATION
- Oauth - invented in 2006 out of twitter OpenID standard
    - https://oauth.net/
    - oauth 1.0 came out in 2007, by google engineer
    - 2.0 came out in 2013, not backwards compatible with 1.0
    - martin fowler ruby scripting to do oauth 2.0 with google: https://martinfowler.com/articles/command-line-google.html
- OpenID Connect(OIDC) - built on top of oauth 2.0, includes identity stuff, has an IdP
    - dont need a user/pass for each website, can have one idp and an RP for each website/application/client
    - advantages: SSO for all RPs that use that IDP server, only one db instead of many with ur creds
- TOTP - time based one time password
- passwordless auth - umbrella term for any tech that doesnt requires entering a password or knowledge based secret
- Passkey 
    - a passwordless auth type, digital cred stored in OS or browser(2022 chrome supports it), can also live in a physical device
    - by 2023 many password managers support it, like dashlane and nordpass, soon bitwarden
    - often the passkey store is secured behind a biometric key
- WebAuthN
    - good site - https://webauthn.io/
    - attestation - https://medium.com/webauthnworks/webauthn-fido2-demystifying-attestation-and-mds-efc3b3cb3651
    - doesnt no require password (is a passwordless auth type)
    - uses public key cryptography under the hood
    - any hardware/software that implements CTAP(client to authenticator protocol) can be used
        - so an authneticator can be pure software (using trusted execution env of cpu)
    - great b/c it's highly phishing resistant
    - backwards compatible and successor to FIDO U2F(universal 2nd factor)
