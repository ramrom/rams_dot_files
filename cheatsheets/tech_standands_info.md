# TECH STANDARDS AND INFO
------------------------------------

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

## WIFI
- WiFi 6 to identify devices that support 802.11ax (released 2019)
- WiFi 5 to identify devices that support 802.11ac (released 2014)
- WiFi 4 to identify devices that support 802.11n  (released 2009)
- WiFi 3 to identify devices that support 802.11g (released 2003)
- WiFi 2 to identify devices that support 802.11a (released 1999)
- WiFi 1 to identify devices that support 802.11b (released 1999)

## IoT
- Matter is a new standard to rule all IoT for communication but still a big WIP (sept 2021)
    - https://buildwithmatter.com/
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


## HDMI
- 1.4 - released 2009
- 2.0 - released 2013, supports 18Gbps, so one 4k@60hz
- 2.1 - released 2017, supports 48Gbps(Ultra High Speed cables needed), can do a 10k@120hz

## USB
- usb 3.0 cable shouldn't really exceed 10 feet without repeater
- displayport cable shouldnt exceed 10 feet
- usbc supports usb 2.0 to 4.0
- usb a/b supports usb 1.0 to 3.1
- 2.0 - 480Mbps
- 3.x
    - 3.0(superspeed) - 5Gbps
    - 3.1gen1 - 5Gbps, 3.1gen2 - 10Gbps(uses 128b/132b)
    - using usb-c: 3.2gen1 - 10Gbps, 3.2gen2 - 20Gbps
- 4.x - suports 40Gbps

## SATA
- SATA 1.0: 5 Gb/s, 150 MB/s
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
- interfaces
    - SATA 3 - up to 600MBs
    - NVME - often more than 3 times faster than SATA 3
    - M.2 - interface form factor

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

## HTTP
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

## MONITORS
- low response time results in ghosting
- TN (twisted nematic), oldest
    - fast refresh rates, short response times, high brightness -> good for gaming
        - can have response times low as 1ms
    - bad viewing angles, bad color reproduction
- IPS (in-plane switcing), newer tech
    - good color reproduction, good viewing angle
    - slower response times, lower refresh rates
- VA
    - oldest standard

## COMPILERS
- LLVM is a platform for creating machine code
    - developed by the same guy who made Swift (Chris Lattner)
    - Rust, Swift, Kotlin Native, and objective C use LLVM
    - LLVM has API that take IR (itermediate representation), then it uses that create binary or JIT
- objective C uses Clang compiler to create LLVM IR
- swift uses it's own "swift compiler" to create LLVM IR(bitcode)

## BASE64
- 64 safe ASCII chars
- standard one is `A-Z` `a-z` `0-9` `+` `/`
- url safe one replaces `+` and `/` with `_` and `-`

## FLOATS
- https://en.wikipedia.org/wiki/IEEE_754-1985

## PLANTUML
- https://plantuml.com/sequence-diagram

## OpenApi / Swagger
- https://editor.swagger.io/  - good place to validate an openapi yaml file

## Smithy
- a service and SDK description language created by AWS
- https://awslabs.github.io/smithy/

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

## CLOUD DRIVES
- dropbox
    - free: limits to 3 devices to sync, no offline file access
- mega
    - no device limits, native linux/osx/windows clients, has offline file access for entire folders and all files
- google drive
    - offline access for idvidual files (and only gdocs like their spreadsheet and word doc)

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
- supports encryption, compression
- does use traditional volumes, has storage pool concept for multiple drives, so it supports RAID-like features
- standard on BSD, super awesome, does basically everything well
- uses "transactional semantics" for integrity: https://docs.oracle.com/cd/E19120-01/open.solaris/817-2271/6mhupg6hh/index.html
    - better than journaling
- has checksums on data and metadata
### EXT4
- good article: https://opensource.com/article/18/4/ext4-filesystem
- backwards compatible with ext3 and ext2
- has 3 journaling modes(like ext3)
    - journal: writes data and metadata to journal, ordered: writes only metadata to journal, writeback: write metadata but no order, fast
        - default mode is usually ordered
### NTFS
- windows standard

## NETWORK FILESYSTEM PROTOCOLS
- afp (apple filing protocol), nfs (unix designed), smb/cifs(windows designed, supported well by all)
- osx: smbv3 performs > afs ( https://photographylife.com/afp-vs-nfs-vs-smb-performance)
- cifs/smb info: https://linux.die.net/man/8/mount.cifs
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
