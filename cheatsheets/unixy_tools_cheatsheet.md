# UNIXY TOOLS

## TOOLS NOT HERE
- [curl](http_web_tls_cheatsheet.md)
- [xh, a better curl](http_web_tls_cheatsheet.md)
- [fd or fdfind, a better find](fzf_fd_rg_cheatsheet.md)
- [ripgrep, better grep -r](fzf_fd_rg_cheatsheet.md)
- [fzf](fzf_fd_rg_cheatsheet.md)

```sh
# FIND: find files recursive starting with current dir
find . -type f -name "*.exe"        #  simpler patterns, find files ending in string .exe
find . -type f -regex ".*pattern.*"     # search filename using regular expression pattern
# find all hard links to /path/foo that exist in /searchdir
find /searchdir/ -samefile /path/foo
find /searchdir/ -xdev -samefile /path/foo  # xdev means only search same partiion (deviceid) as what foo is on
find /tmp/ -inum 4065089 # find all hard links with a inode #
find /foo/bar/ -type d -d 1  -name "*yar*" # find all dirs, search depth 1, has "yar" in name, in dir/foo/bar/
find foo/ -type f -size +10M | xargs du -sh   # find files > 10mb in filder foo, and then print it's size
find . -type f -regex ".*\.exe$" -exec grep foo {} \;    # exec runs a command on each result, grep pattern foo in thise case

# get terminal info
infocmp

# CAT - output content of file to stdout
cat file

# TAC - opposite of cat, output file in reverse order of lines to stdout
tac file

# TOUCH - create an empty file
touch foofile

# READLINK - get full absolute path of file (osx coreutils has this)
readlink foo        # might print /users/foouser/folder/foo

# MKDIR - Make a dir
mkdir -p middir/finaldir    # -p will create any intermediate dirs that might not exist

# CP - copy
cp -al dirA dirB  # recursively hardlink everything in dirA to dirB
cp -l               # make copies but just hard links, gnu/linux has this, osx does not
cp -rl dirA dirB # recursively copy all of dir a to b, but just hard links, gnu/linux supports this, not osx


# SCP - secure copy, (based on ssh protocol)
# not well maintained, and rec'd to use rsync or SFTP instead, in openssh 9.0 scp client actually uses SFTP
scp /path/to/file someuser@somehost:/some/remote/path/destfilename
scp -r /path/to/folder someuser@somehost:/some/remote/path/destfolder   # copy whole folder

# SYNC - flush buffer cache to storage disk
sync
sync /foo/bar  # flush buffer for bar file only

# GREP  -   (varies widely b/w osx and gnu/linux)
# grab only the matched text with -o, works on osx and gnu/linux
echo "foo bar baz" | grep -o "fo." # will only return "foo"
# print just the line after a matched line, here would print baz
printf "foo\nbar\nbaz\n" | grep -A1 'bar' | grep -v 'bar'
# grep for 2 patterns in same line
printf "foo bar baz" | grep 'bar' | grep 'foo'      #method1
printf "foo bar baz" | grep -E 'bar.*foo|foo.*bar'  #method2

# AWK - multi purpose tool, really a mini programming language
echo "foo bar baz" | awk '{print $2}'  # will print bar
echo "foo bar baz" | awk '{print $1"  "$3}'  # will print `foo  baz` , two spaces in between
awk '{$1=""; print $0}' somefile        # print all but the first field/column
awk '{$1=$2=""; print $0}' somefile        # print all but the first and second field/column
awk '/blah/{getline; print}' logfile   # print the next line after the line that matches patter "blah"

# SED - streaming editor
echo "2.03" | sed 's/\.//g'  # will print 203
echo "2.03" | sed 's/[0-9][0-9]/foo/g'  # will print 2.foo
echo "(foo)" | sed 's/[()]//g'  # will print "foo", dont have to escape parens like \( and \) with regex
printf "foo\nbar\nbaz\n" | sed -n 2p # get nth line of stdin, here the 2nd, blank output if line exceeds highest index
echo "foobar" | sed 's/..$//'   # remove last 2 chars, so output is "foob"
sed -i 's/foo/bar/g' file.txt   # inline substitute foo for bar in file.txt
cat somefile | sed -e 's/,/,\n/g'  # add a newline after every comma in file and output to stdout
cat somefile | sed -n '2p'          # print just the 2nd line of the file

# CUT - select data in each line by byte/char position or delimiter char
echo "foo; bar - baz" | cut -d ';' -f 2     # delimiter semicolon , extract field 2, so " bar - baz" will print
echo "foo;bar;baz;yar" | cut -d ';' -f 2-     # delimiter semicolon , extract all from field 2, so " bar;baz;yar" will print
echo "foo; bar - baz" | cut -c 5-           # remove first 4 chars of each line

# TR - translate chars, find and replace on specific chars
echo "2.1.1" | tr . -              # translate '.' to '-', output "2-1-1"
echo "2.1.1" | tr : '\n'           # translate ':' to '\n'(newline chars)
echo "2,1,1" | tr , \|             # translate ',' to '|'
echo "2.03" | tr -d .              # -d to delete, this will print 203
echo foo:bar:baz | tr : \\n        # split on ":" delimiter, replace ":" with newline
echo "\u0001 hi" | tr -cd '[:print:]' # strip out nonprintable characters, -c is complement(opposite of)

# TRUNCATE - shrink or extend file size
truncate --size 1 foofile  # only keep the first byte of file, truncate rest

# TEE - read from STDIN and write to STDOUT and regular files
echo "output in both" | tee /path/to/file
echo "output in both" | tee -a /path/to/file   # append to file

# GOACCESS - log file analyzer
goaccess logfile.log  # interactive TUI
goaccess logfile.log  -o report.html # generate a pretty html webpage report
goaccess --log-format=COMBINED logfile.log # specify logformat
    # nginx/apache logs are COMBINED format by default

# COLUMN
column -t -s, somecsv  # use comma to delimit columns and print csv file with aligned columns
awk -F',' '{print $2","$4}' some.csv | column -t -s  # only print column 4,2 with aligned columns

# TPUT - terminal settings and capabilities
    # also see [ansi color cheat](ansi_color.md)
tput cols     # number of columns in terminal window
tput lines    # number of rows in terminal window
tput setaf 1  # outpt ansi code for red foreground color
tput sgr0     # reset

# STTY
stty size    # get rows x column dimensions

# DATE
sudo date --set 1998-11-02  # change date
date +%s       # print unix time in number of seconds (since 1970)
date '+%Y-%m-%d'  # e.g. "2021-04-24"
date +%s -d"Jan 1, 1980 00:00:01"  # covert ISO time to unix epoch
date +%s -d"2023-01-06 00:00:01"  # covert ISO time to unix epoch
date -d @1520000000  # convert unix epoch ISO time
    date -r 123439819723 '+%m/%d/%Y:%H:%M:%S' # OSX - prints "08/26/5881:09:48:43"
    date -r 123439819723 # OSX - prints "Fri Aug 26 09:48:43 CDT 5881"
date --date "-7 days" +'%m-%d-%y' # if today is feb23-2023, this will print 01-30-23
date +"%Z %z"  # print time zone
date +%s%N     # print nanoseconds (%N doesnt work on OSX)
gdate +%s.%N   # coreutils package on OSX offers gdate, which can give nanoseconds
date +%s%3N   # nanoseconds with 3 most sig figs
perl -MTime::HiRes -e 'printf("%.0f\n",Time::HiRes::time()*1000)'   # not date, but universal way to get millisecond time in any OS

# TIMEDATECTL - controle system time and date, not on OSX
timedatectl show    # show properties of systemd-timedated
timedatectl status  # show current time settings
timedatectl list-timeszones
timedatectl set-ntp on   # enable NTP

# SORT - sort stdin of lines, waits for all input till EOF
echo "b\na" | sort   # will print a on first line, b on second line

# SHUF - generate random permutation of input lines
echo "a\nb\nc" | shuf  # will randomly 3 lines of some order of "a", "b", and "c"
echo "a\nb\nc" | shuf -n 1  # will select the first line in the randmly generated permutation

# UNIQ - remove identical value **adjacent** lines, use sort first if u want to remove non adjacent dups
echo "foo\nfoo\n\bar" | uniq        # will print one foo and then bar
echo "foo\nbar\n\foo" | uniq        # will print foo, then bar, then foo!, b/c the 2nd foo isn't adjacent

# RANDOM NUMBER GENERATION
echo $RANDOM    # RANDOM is a special env var that will contain some value from 0 - 32767
od -An -N1 -i /dev/random  # get a random byte from the special file /dev/random

# XARGS - read lines from stdin and execute a command on each line
echo "foo bar baz" | xargs -t echo    # -t prints what the command being run is for every iteration, good for debugging
echo "foo bar baz" | xargs -t -n 1 echo  # -n specifies max number of args to take for each iteration
find . -name foo -type f | xargs cat  # find all files named foo and spit out contents to stdout
find . -name foo -print0 | xargs -0 rm -v  # safer thans spaces/newlines for file items
# NOTE: https://stackoverflow.com/questions/6958689/running-multiple-commands-with-xargs
    # use "$arg" vs -I, specify -d '$\n' to prevent shell-like parsing
printf "foo\0bar\0baz" | xargs -d '\0' echo   # linux: specify delimiter char (must be single char)
echo "foo bar baz" | xargs -I % echo "prefix % postfix"  # can specify where to substitute input str
echo "foo bar baz" | xargs -I _ sh -c 'echo before; echo "_"; echo after' # sh trick here to run many commands
# print0 in find says to seperate items with a null char, -0 in xargs tells it to seperate by null char (vs space/newline)

# HEAD/TAIL - spit out beggining/last lines in a file
head foofile  # by default prints the first 10 lines of file
head -n-2 foofile  # print all except the last 2 lines
echo "foobar" | head -c 2  # grab first 2 chars of input, prints "fo"
tail foofile  # last 10 lines
tail -n+3 foofile # get all lines starting from line 3 and on
tail -f foofile  # spit out last lines and continue to print them as new ones are written

# BC - float point math
echo "3.1 * 4.5" | bc       # = 13.9
echo "11 * 3 / 4" | bc      # = 8, it rounds down for division

# strings - print out text strings in a binary file or any file
strings somebin

# NETCAT
nc -l 127.0.0.1 9001     # TCP listen on 9001
nc -u -l 127.0.0.1 9001     # UDP listen on 9001
nc -u 127.0.0.1 3000        # create UDP connection to 127.0.0.1 port 3000

# WC - word count
wc -l somefile   # count # of lines in file
wc -c somefile   # count # of chars in file
cat somefile | tr -cd ',' | wc -c   # count the number of commas in a file

# TAR
tar –xvzf documents.tar.gz   # uncompress tar file
    # -x extract, -v verbose, -z decompress each file, -f filename of tar file
tar –tvzf documents.tar.gz   # list tar file contents
    # -t to list contents

# ZIP
zip -r outputfile folder1 folder2
unzip -l foo.zip        # list contents, dont extract
unzip foo.zip                       # unzip contents in cur dir
unzip foo.zip -d /path/to/output  # unzip to specific foler

# BASE64 - encode and decode base64
echo "foobar" | base64                      # encode from stdin
echo "foobar" | base64 | base64 --decode      # decode from stdin, should print "foobar" here

# XSV - a rust tool to manipulate CSVs
xsv table somecsv.csv  # pretty print table to stdout
xsv count somecsv.csv  # print # of rows

# YQ - a golang data file processor for YAML/XML/JSON, has similar language as jq
yq '.a.b[0].c' file.yaml  # read a jq like path in yaml file
yq some.xml -o yaml     # convert xml to yaml
yq some.xml -o json     # convert xml to json
yq some.yaml -o xml     # convert yaml to xml
yq some.yaml -o json     # convert yaml to json

# XQ - convert xml to json and then use jq queries
xq . some.xml  # would spit our JSON conversion
xq .somekey some.xml

# PANDOC -universal doc converter
    # https://pandoc.org/MANUAL.html#general-options
pandoc foo.md -o foo.docx   # convert markdown to docx
pandoc foo.md -o foo.odt   # convert markdown to opendocument
pandoc foo.md --to jira -o output.jira  # explicitly specify output format

# FFMPEG - video conversion tool
ffmpeg -i path/to/video.mp4 -vn path/to/sound.mp3   # extract sound from a mp4 vid file and save as mp3

# SUBSYNC - https://github.com/spion/subsync
subsync @+5 < input.srt > output.srt  # shift all subtitles forward 5 seconds

## EMACS
c-x c-c to quit

# GNU GPG
gpg -e --no-symkey-cache file.txt  # encrypt file with assym public key, and dont cache the passphrase
gpg -c --no-symkey-cache file.txt  # encrypt file with symmetric key, and dont cache the passphrase
gpg -d --no-symkey-cache file.txt  # decrypt file, and dont cache the passphrase
gpg --list-keys # list all keys

gpg --full-generate-key  # gen new key, with FN/LN/email, default folder to store is /home/user/.gnupg/
# gen new key, set blank passphrase, bypass pinentry daemon
# ssh session, passphrase uses ncurses or gnome pinetry, cant launch, get error: `gpg: agent_genkey failed: Operation cancelled` error
# see https://superuser.com/questions/520980/how-to-force-gpg-to-use-console-mode-pinentry-to-prompt-for-passwords
gpg --full-generate-key --passphrase '' --pinentry-mode loopback

gpg --export-secret-keys --armor --output backupfile.asc johndoe@example.com # create backup of keys to a file, --armor pretty prints
gpg --export --armor --output pubkeys.asc johndoe@example.com # create file of pubkeys

# PASS
pass init ABCDEF12  # create new pass db in default location(/home/user/.password-store) with gpg id ABCDEF12(is last 8hex of pub key)
pass insert foo # create a password key called `foo`, will be prompted to enter password

# IOTOP - top like temrinal UI, but show io/disk usage by process (on osx and linux)
sudo iotop -o

# ULIMIT - see user limits (per process)
# hard limit is max a soft limit can be increased to, raising hard limits requires root
ulimit -a       # get all user limits (soft)
ulimit -a -H    # get all hard user limits
ulimit -H -n   # get hard limit for simultaneous opened files
ulimit -S -n   # get soft limit for simultaneous opened files
ulimit -u 30   # set max per-user process limit to 30

# SYSSTAT (linux pkg with many tools), has great colors
iostat          # show per device/filesystem disk read, with no arg calculated *since* last reboot
iostat -m       # display in megabytes
iostat sda sdb  # only display stats for certain devices
iostat 5        # refresh every 5 seconds forever, calculates average since last reading
iostat 2 3      # refresh 2 seconds, only sample 3 times
cifsiostat 1    # show cifs network mount io usage stats
mpstat 1        # show cpu usage, by usr/sys/idle

# MEMORY
# free - show memory/swap usage, total/used/free/cached
free -h   # -h is human readale
# /proc/meminfo
cat /proc/meminfo   # shows detailed memory usage

# VMSTAT
vmstat     # just one measurement, will calculate since last reboot
vmstat 3   # every 3 sec show free/swap/used/total memory usage, cpu performance, i/o

# FIO - flexible io tester
fio [options] [jobfile]

# STRESS (add load on cpu memory or io)
stress --cpu 2      # 2 threads, do hard cpu problem like square-root function
stress --io 4       # 4 threads add io activity to system
stress --vm 4       # 4 threads to do lots of memory ops
stress-ng --cpu 2   # improved version of stress, many more advanced tests


###### NETWORK TOOLS
# IP (linux, not OSX)
ip -stats link show lo    # show statistics on a network link named `lo`
ip addr                   # show IP addr, ethernet addr, state, etc

# ARP cache
arp -a   # display the apr cache
arp -i en1 -a  # display arp cache through specific interface

# NSLOOKUP - dns lookup
nskookup example.com
nslookup example.com 1.1.1.1 # use dns server 1.1.1.1 to lookup

# NMAP - network scanner
nmap -sn 1.1.1.*  # scan all 1.1.1.* IP addresses, and find live hosts
nmap -e en1 -sn 1.1.1.*  # specify interface en1 to search through

# DIG - dns lookup, better/newer than nslookup
dig example.com
dig @1.1.1.1 example.com # use dns server 1.1.1.1 to lookup
# google public dns servers are 8.8.8.8 and 8.8.4.4

# SNMP
# ref: https://www.networkmanagementsoftware.com/snmp-tutorial/
# assuming v 2c and community string is foobar
snmpwalk -Os -c foobar -v2c 192.168.1.1 some.oid.path

# Bandwidth usage
sudo bandwhich    # rust terrminal UI tool, nice, by connection, by process and by remote IP
nettop            # osx terminal UI tool, tree view, by process and each connect in process
iftop             # monitor a interface, usage by connection, has text bars and number rates

# LSOF, list file handles, swiss army knife since 'everything is a file' in unixy OSes
lsof
lsof | grep /path/to/mount   # find out wnat processes are accessing a mount, useful for umounting
lsof -a -p 1234             # get all fd's on process 1234

# SUDO
sudo ls             # run ls command as superuser(root)
sudo -u foouser ls  # run ls command as foouser
sudo bash           # start a bash session as root
su foouser          # login as foouser


######## PROCESSES ###########
# PS
ps -Ao pcpu,user,command -r | head -n 6   # Linux: get top 6 cpu consuming processes, -r (sort by current cpu usage)
ps ax -o command= | grep -E "^ssh"      # print only the command executed for process and grep to find one that starts with "ssh"

# HTOP
# "/" vim-like search
# quitting by hitting F10 will remember settings in .htoprc
# l - list FDs(files) open by process, k - kill process, x - list file locks
htop

kill            # send signal to process, by default sigterm
pgrep foo       # search for processes with "foo" in command and return PIDs
killall -3 foo  # send sigquit to all proceses with foo in the name, default is sigterm

# SIGNALS
1 -  sighup    # hangup
2 -  sigint    # interrupt, what ctrl-c usually sends
3 -  sigquit   # exit, and dump core, what ctrl-\ usually does
9 -  sigkill   # exit without cleanup
15 - sigterm   # exit,with cleanup
24 - sigtstp   # suspend,what ctrl-z usually does

# RSYNC
    # normally compares mod-time and file size to see if a file changed
    # rsync can ssh to backup: https://www.howtogeek.com/135533/how-to-use-rsync-to-backup-your-data-on-linux/
## USAGE EXAMPLES
rsync /src /dest  # basic copy/sync over files from one dir to another
rsync /src/ /dest  # trailing slash means copy contents of src dir, and not the src dir by name (adding a dir level)
rsync -a /src /dest  # -a (archive rlptgoD): (D)preserve devices and special
    # (r)ecurse dirs, (l)copy symlinks, (p)preseve perms, (t)preserve modtime,(g)prserve group,(o)preserve owner
rsync -r /src /dest  # -r is recurse into directories
rsync -z /src /dest  # -z compress changes during transfer (nice for slow network connection)
rsync -H /src /dest  # -H (hardlinks), will preserve hard links, otherwise same hardlinks will be treated as sepearte files
    # file rename/moves syncing with hardlinks: https://lincolnloop.com/blog/detecting-file-moves-renames-rsync/
    # if source file changes, use --inplace, inplace update on dest will preserve hard links
    # smb -> ext4 and smb -> NTFS  both seem to support this well
rsync --inplace /src /dest          # if file changed on dest, then dest file is changed in place, this will preserve hard links
                                    # without option, will see a file.xxxx type tmp file while that file is being transferred over
rsync --delete /src /dest  # delete will remove files in target dir2 that dont exist in source dir
rsync -v /src /dest      # show each file being transferred, total sent/received summary at end
rsync --stats /src /dest      # show very detailed summary info
rsync -h --progress /src /dest      # show progress(bytes transferred for each file), -h output numbers in human readable format
rsync -h --dry-run /src /dest       # (also -n), show just what would happens withotu doing it
    # dry-run shows if a hard-link is copied (-H option enabled), shows file deletions (--delete options)
rsync -vh --checksum /src /dest       # use checksum algorithm instead of file-size/mod-time to figure out if file needs transferring
# DELTA TRANSFERS
# for each file copied, rsync can tx just parts of file that changed
# each chunk of file on both sides has a md5 hash and cheap "rolling checksum" calculated
# oct'24 - BELOW NEEDS VERIFICATION:
    # delta-transfers wont really work if remote is a network file share, e.g. samaba
    # this is because entire file has to be read and thus transfered over network anyway to caluclate rolling checksums
    # ideally with network file share, you connect local rsync client to rsync server on remote file share

rsync -hvar --progress /src /dest  # freuent options

# RCLONE - rsync for cloud drives
    # written in Go - https://rclone.org/
    # ver 1.58+ supports bisync for 2-way, older ver only has one-way sync
rclone listremotes --long  # print all remote names and type to stdout
rclone ls some-remote:/somedir  # list objects in remote dir somedir
rclone copy /path/to/file some-remote:/remote/dir   # copy file to remote dir
rclone copy --ignore-existing /path/to/file some-remote:/remote/dir
    # if same file name exists dont overwrite
rclone copyto /path/to/file some-remote:/remote/path/newfilename  # rename file at dest
rclone move /path/to/file some-remote:/remote/dir/   # copy to remote, delete locally
rclone mount some-remote:/remote/dir/ /local/dir  # one-way mount remote dir
    # jan2023 - deleting file from remote(gdrive) did not sync to local mount
rclone purge remote:path    # delete path and all contents, including dirs, cant use filters
rclone delete --min-size 100M remote:path    # delete files with filters, dirs are not removed
                                            # filter here only delete if > 100MB
rclone --dry-run delete remote:path    # delete, but see what would be delted
RCLONE_CONFIG_PASS=foo rclone config   # if config is password protected can pass in password with env var
RCLONE_PASSWORD_COMMAND=/path/to/script rclone config # specify a command/script to run that outputs password to stdout
# store password in memory: https://forum.rclone.org/t/methods-to-store-config-password-in-memory/21610
rclone --config="/path/to/config" listremotes # specify a config file to use



# STAT - show metadata info of file, last access, modify time, change time, etc.
stat foo
stat -x foo   # osx only: extended info, on osx version, linux version does this by default
stat -t foo   # linux only: one line concise format (useful if u want to script it easier)
stat -c %Y foo # linux: get modtime of file in unix epoch
stat -f %m foo # osx: get modtime of file in unix epoch

# NETSTAT - get network related info
netstat     # print info about open network sockets
netstat -r  # print info about kernel routing table
netstat -i  # show aggregate stats by network interface (e.g. total received and sent bytes)

# FILE - determine file type (osx and ubuntu has it)
file foo   # example output: "foo: ASCII text"

# MD5 fingerprint
md5 somefile    # osx bin, spits out md5 fingerprint of file
md5sum somefile # ubuntu bin, same deal

# WATCH - run a command periodically
watch -n 2 -d date  # run `date` every 2 seconds, -d highlight differences

# FSWATCH - monitor some files and print changes
# on linux it uses inotify, kqueue on BSD, FSEvent on OSX
fswatch some/dir/ another/dir/ dir/somefile

# CHAFA - view images(jpg, png etc) in ASCII/text in terminal! (ugly but still cool)
    # supports sixels, kitty, iterm2
chafa foo.jpg

# CATIMG - like chafa
catimg foo.jpg

# MEDIAINFO     - show mediafile metadata (like mdls for osx)
mediainfo foo.mp4

# CALCURSE
# example config file: https://github.com/lfos/calcurse/blob/pu/contrib/caldav/config.sample
# https://www.calcurse.org/files/calcurse-caldav.html , has section for google oauth2 cal
# linux - caldav config file in ~/.config/calcurse/caldav/config
# linux - oauth creds stored in ~/.config/calcurse/caldav/oauth_cred
# linux - data stored in ~/.local/share/calcurse
calcurse                # start the TUI
calcurse -d 30          # print events for next 30 days
calcurse-caldav         # sync caldav
DISPLAY=:1 calcurse-caldav --init keep-remote  # initialize local cal, sync down from remote, dont mod remote!
    # set DISPLAY so xdg-open can use GUI browser, otherwise it'll open headless browser (google login fails, javascript error)

# VERACRYPT
veracrypt -tc sometruecryptfile  # mount an old truecrypt file

# YOUTUBE-DL
youtube-dl -F https://www.youtube.com/watch?v=dfidfa     # show available formats
youtube-dl -f 140 https://www.youtube.com/watch?v=dfidfa     # download specific format

# DU - list all files recursively in dir and their disk usage
du -a /foo

# CHOWN - change owner of files and dirs
chown newuser file
chown newuser:newgroup file
chown -R newuser dir

# SHRED  - overwrite data in file or whole device
sudo shred -v /dev/sdb1
shred foofile

# SSHFS
    # sshfs uses SSH and SFTP(ftp over ssh) to remote mount a filesystem
sshfs user@host:/dir/path localdir/
sshfs -o sshfs_debug user@host:/dir/path localdir/  # get debugging info
# two hop ssh for sshfs using local forwarding
ssh -f userB@systemB -L 2222:systemC:22 -N
sshfs -p 2222 userC@localhost:/remote/path/ /mnt/localpath/
```


## FILESYSTEMs/STORAGE-DEVICES
```sh
fdisk       # manipulate partitions
fdisk -l   # linux show all dev devices and storage device info

# show UUIDs of partitions on system (desirable for mounting in fstab)
sudo blkid

parted # show phsyical partitions available, some detailed info. doesnt exist on osx
        # has interactive menu
mount  # alone shows info about mounts
mount -t tmpfs tmpfs /somedir -o size=1024M  # create tmpfs(ram drive) 1024mb size
    # when you unmount data is deleted b/c ram drive is temporary storage

df      # will show block devices and where they are mounted
cat /etc/fstab  # fstab controls what gets mounted at boot, can see type, mount dir, mode, etc

lsblk -f /dev/sda1  #  show info on block type devices

# ntfs-3g, osx tool to mount ntfs filesystem
sudo /usr/local/bin/ntfs-3g /dev/disk2s1 /Volumes/myvol -oallow_other

# NETWORK FILE SYSTEM MOUNT
mount -v -t smbfs //someuser@192.168.1.1/folder destfolder/
mount -t smbfs smb://someuser:somepass@192.168.1.1/folder destfolder/
# mount afp share in osx
mount -t afp afp://someuser:somepass@192.168.1.1/folder destfolder/

# LINUX samba samba/cifs, -o lets u speficy options, like user/pass
mount -t cifs //192.168.1.1/folder destfolder/ -o username=foouser,password=foobar

# mount nfs share in linux
sudo mount -t nfs 192.168.1.1:/fullpath/to/folder destfolder/

# mount ntfs in linux
sudo mount -t ntfs -o nls=utf8,umask=0222 /dev/sdb1 destfolder/
```
