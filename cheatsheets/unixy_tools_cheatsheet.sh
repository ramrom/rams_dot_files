# 'NIX general tooling type stuff

# FIND: find files recursive starting with current dir
find . -type f -name "*pattern*"
# find all hard links to /path/foo that exist in /searchdir
find /searchdir/ -samefile /path/foo
find /searchdir/ -xdev -samefile /path/foo  # xdev means only search same partiion (deviceid) as what foo is on
find /tmp/ -inum 4065089 # find all hard links with a inode #

# get terminal info
infocmp

# grep (varies widely b/w osx and gnu/linux)
# grab only the matched text with -o, works on osx and gnu/linux
echo "foo bar baz" | grep -o "fo." # will only return "foo"
# print just the line after a matched line, here would print baz
printf "foo\nbar\nbaz\n" | grep -A1 'bar' | grep -v 'bar'

#awk - multi purpose tool
echo "foo bar baz" | awk '{print $2}'  # will print bar
awk '/blah/{getline; print}' logfile   # print the next line after the line that matches patter "blah"

# cut - select data in each line by byte/char position or delimiter char
echo "foo; bar - baz" | cut -d ';' -f 2     # delimiter semicolon , extract field 2, so " bar - baz" will print
echo "foo; bar - baz" | cut -c 5-           # remove first 4 chars of each line

# TR - translate chars, find and replace on specific chars
echo "2.1.1" | tr . -           # translate '.' to '-', output "2-1-1"
echo "2.03" | tr -d .           # -d to delete, this will print 203
echo foo:bar:baz | tr : \\n     # split on ":" delimiter, replace ":" with newline

# sed - streaming editor
echo "2.03" | sed 's/\.//g'  # will print 203
echo "(foo)" | sed 's/[()]//g'  # will print "foo", dont have to escape parens like \( and \) with regex
printf "foo\nbar\nbaz\n" | sed -n 2p # get 2nd line of stdin, blank output if line exceeds highest index
echo "foobar" | sed 's/..$//'  # remove last 2 chars, so output is "foob"

# date
sudo date --set 1998-11-02  # change date
date +%s       # print unix time in number of seconds (since 1970)

# netcat
nc -l 127.0.0.1 9001     #listen on 9001

# wc - word count
wc -l   # count # of lines

# sort - sort stdin of lines, waits for all input till EOF
echo "b\na" | sort   # will print a on first line, b on second line

# uniq - remove identical value **adjacent** lines, use sort first if u want to remove non adjacent dups
echo "foo\nfoo\n\bar" | uniq        # will print one foo and then bar

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
tail foofile  # last 10 lines
tail -n+3 foofile # get all lines starting from line 3 and on
tail -f foofile  # spit out last lines and continue to print them as new ones are written

# BC - float point math
echo "3.1 * 4.5" | bc       # = 13.9
echo "11 * 3 / 4" | bc      # = 8, it rounds down for division

# strings - print out text strings in a binary file or any file
strings somebin

# GNU GPG
gpg -e --no-symkey-cache file.txt  # encrypt file with assym public key, and dont cahce the passphrase
gpg -c --no-symkey-cache file.txt  # encrypt file with symmetric key, and dont cahce the passphrase
gpg -d --no-symkey-cache file.txt  # decrypt file, and dont cahce the passphrase

# HTOP
# "/" vim-like search
# quitting by hitting F10 will remember settings in .htoprc
htop

# IOTOP - top like temrinal UI, but show io/disk usage by process (on osx and linux)
sudo iotop -o

# sysstat (linux pkg with many tools), has great colors
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

# vmstat
vmstat     # just one measurement, will calculate since last reboot
vmstat 3   # every 3 sec show free/swap/used/total memory usage, cpu performance, i/o

# stress (add load on cpu memory or io)
stress --cpu 2      # 2 threads, do hard cpu problem like square-root function
stress --io 4       # 4 threads add io activity to system
stress --vm 4       # 4 threads to do lots of memory ops
stress-ng --cpu 2   # improved version of stress, many more advanced tests


###### NETWORK TOOLS
# ARP cache
arp -a   # display the apr cache

# NSLOOKUP - dns lookup
nskookup example.com
nslookup example.com 1.1.1.1 # use dns server 1.1.1.1 to lookup

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

# SUDO
sudo ls             # run ls command as superuser(root)
sudo -u foouser ls  # run ls command as foouser
sudo bash           # start a bash session as root
su foouser          # login as foouser

# processes
kill            # send signal to process, by default sigterm
pgrep foo       # search for processes with "foo" in command and return PIDs
killall -3 foo  # send sigquit to all proceses with foo in the name, default is sigterm

# signals
1 -  sighup    # hangup
2 -  sigint    # interrupt, what ctrl-c usually sends
3 -  sigquit   # exit, and dump core, what ctrl-\ usually does
9 -  sigkill   # exit without cleanup
24 - sigtstp   # suspend,what ctrl-z usually does

# RSYNC
    # rsync can ssh to backup: https://www.howtogeek.com/135533/how-to-use-rsync-to-backup-your-data-on-linux/
## USAGE EXAMPLES
rsync /src /dest  # basic copy/sync over files from one dir to another
rsync -a /src /dest  # -a (archive), preserves permissions, symlinks, and ownership, usually want this
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
rsync -vh --checksum /src /dest       # use checksum algorithm instead of file-size/mod-time to figure out if copying is needed
# NOTE: delta-transfers wont really work if remote is a network file share, e.g. samaba
    # this is because entire file has to be read and thus transfered over network anyway to caluclate rolling checksums
    # ideally with network file share, you connect local rsync client to rsync server on remote file share

rsync -hvar --progress /src /dest  # freuent options

# STAT - show metadata info of file, last access, modify time, change time, etc.
stat foo
stat -x foo   # osx only: extended info, on osx version, linux version does this by default
stat -t foo   # linux only: one line concise format (useful if u want to script it easier)

# FILE - determine file type (osx and ubuntu has it)
file foo   # example output: "foo: ASCII text"

# MEDIAINFO     - show mediafile metadata (like mdls for osx)
mediainfo foo.mp4

# list all files recursively in dir and their disk usage
du -a /foo

# CHOWN - change owner of files and dirs
chown newuser file
chown -R newuser dir

# CP
cp -l     # make copies but just hard links, gnu/linux has this, osx does not
cp -rl dirA dirB # recursively copy all of dir a to b, but just hard links, gnu/linux supports this, not osx

# shred  - overwrite data in file or whole device
sudo shred -v /dev/sdb1
shred foofile

###### FILESYSTEMs/STORAGE-DEVICES
fdisk       # manipulate partitions
fdisk -l   # linux show all dev devices and storage device info

# show UUIDs of partitions on system (desirable for mounting in fstab)
sudo blkid

parted # show phsyical partitions available, some detailed info. doesnt exist on osx
        # has interactive menu
mount  # alone shows info about mounts
df      # will show block devices and where they are mounted
cat /etc/fstab  # fstab controls what gets mounted at boot, can see type, mount dir, mode, etc

lsblk -f /dev/sda1  #  show info on block type devices

# NETWORK FILESYSTEM PROTOCOLS:
    # afp (apple filing protocol), nfs (unix designed), smb/cifs(windows designed, supported well by all)
    # osx: smbv3 performs > afs ( https://photographylife.com/afp-vs-nfs-vs-smb-performance)
    # cifs/smb info: https://linux.die.net/man/8/mount.cifs
        # supports hardlinks with unix extensions and/or servinfo
        # osx wont let you create hard links on samba share, but ls -i seems to recognize them fine
    # nfs
        # best for linux-to-linux, better than smb in this case. windows and osx dont support nfs really
        # supports hard links well
# NOTE: to see flags/options/attributes on a samba share, just look at `mount` command output
# OSX samba share -v verbose
# -o with username(or user) does not work
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
# NOTE!!!:
#   samba share ver 3, nounix set, serverino set, serverino seems to sorta support hard links
#   hard link a file, then modify one: it shows same inode number, BUT `du -hs` shows usage for 2 files
#   Also when i rsync they are diff inode # files on destination
#
#   in linux if i mnt with ver=1.0, i see unix set (and serverino set), and this behavious doesnt happen
#   samba 2/3 dont support hard links:
#       - https://unix.stackexchange.com/questions/403509/how-to-enable-unix-file-permissions-on-samba-share-with-smb-2-0
#       - https://en.wikipedia.org/wiki/Server_Message_Block
