# 'Nix general tooling type stuff

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

#awk - multi purpose tool
echo "foo bar baz" | awk '{print $2}'  # will print bar

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

# wc - word count
wc -l   # count # of lines

# sort - sort stdin of lines, waits for all input till EOF
echo "b\na" | sort   # will print a on first line, b on second line

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
tail -f foofile  # spit out last lines and continue to print them as new ones are written

# BC - float point math
echo "3.1 * 4.5" | bc       # = 13.9
echo "11 * 3 / 4" | bc      # = 8, it rounds down for division

# LSOF, list file handles, swiss army knife since 'everything is a file' in unixy OSes
lsof

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

# HTOP
# "/" vim-like search
htop

# GNU GPG
gpg -e --no-symkey-cache file.txt  # encrypt file with assym public key, and dont cahce the passphrase
gpg -c --no-symkey-cache file.txt  # encrypt file with symmetric key, and dont cahce the passphrase
gpg -d --no-symkey-cache file.txt  # decrypt file, and dont cahce the passphrase

# signals
1 -  sighup    # hangup
2 -  sigint    # interrupt, what ctrl-c usually sends
3 -  sigquit   # exit, and dump core, what ctrl-\ usually does
9 -  sigkill   # exit without cleanup
24 - sigtstp   # suspend,what ctrl-z usually does

# processes
kill            # send signal to process, by default sigterm
pgrep foo       # search for processes with "foo" in command and return PIDs
killall -3 foo  # send sigquit to all proceses with foo in the name, default is sigterm

# RSYNC
rsync /dir /dir2  # basic copy/sync over files from one dir to another
rsync -a /dir /dir2  # -a (archive), preserves permissions, symlinks, and ownership, usually want this
rsync -r /dir /dir2  # -r is recurse into directories
rsync -z /dir /dir2  # -z compress changes during transfer (nice for slow network connection)
rsync -H /dir /dir2  # -H (hardlinks), will preserve hard links, otherwise same hardlinks will be treated as sepearte files
rsync --delete /dir /dir2  # delete will remove files in target dir2 that dont exist in source dir
rsync -h --progress /dir /dir2      # show progress, -h output numbers in human readable format
rsync -vh --dry-run /dir /dir2       # show just what would happens withotu doing it
    # dry-run shows if a hard-link is copied (-H option enabled), shows file deletions (--delete options)
rsync -vh --checksum /dir /dir2       # use checksum algorithm instead of file-size/mod-time to figure out if copying is needed

rsync -hvar --progress /dir /dir2  # freuent options

# STAT - show metadata info of file, last access, modify time, change time, etc.
stat foo
stat -x foo   # osx only: extended info, on osx version, linux version does this by default
stat -t foo   # linux only: one line concise format (useful if u want to script it easier)

# FILE - determine file type (osx and ubuntu has it)
file foo   # example output: "foo: ASCII text"

# list all files recursively in dir and their disk usage
du -a /foo

# CP
cp -l     # make copies but just hard links, gnu/linux has this, osx does not

# shred  - overwrite data in file or whole device
sudo shred -v /dev/sdb1
shred foofile

# MEMORY
# free - show memory/swap usage, total/used/free/cached
free -h   # -h is human readale
# /proc/meminfo
cat /proc/meminfo   # shows detailed memory usage


###### FILESYSTEMs/STORAGE-DEVICES
fdisk       # manipulate partitions
fdisk -l   # linux show all dev devices and storage device info

parted # show phsyical partitions available, some detailed info. doesnt exist on osx
        # has interactive menu
mount  # alone shows info about mounts
df      # will show block devices and where they are mounted
cat /etc/fstab  # fstab controls what gets mounted at boot, can see type, mount dir, mode, etc
# NETWORK FILESYSTEM PROTOCOLS:
    # afp (apple filing protocol), nfs (unix designed), smb/cifs(windows designed, supported well by all)
    # osx: smbv3 performs > afs ( https://photographylife.com/afp-vs-nfs-vs-smb-performance)
    # cifs/smb info: https://linux.die.net/man/8/mount.cifs
        # supports hardlinks with unix extensions and/or servinfo
        # osx wont let you create hard links on samba share, but ls -i seems to recognize them fine
    # nfs
        # best for linux-to-linux, better than smb in this case. windows and osx dont support nfs really
        # supports hard links well
# mount samba share in osx, -v verbose
# -o with username(or user) does not work
mount -v -t smbfs //someuser@192.168.1.1/folder destfolder/
mount -t smbfs smb://someuser:somepass@192.168.1.1/folder destfolder/
# mount afp share in osx
mount -t afp afp://someuser:somepass@192.168.1.1/folder destfolder/

# mount samba/cifs in linux, -o lets u speficy options, like user/pass
mount -t cifs //192.168.1.1/folder destfolder/ -o username=foouser,password=foobar
# mount nfs share in linux
sudo mount -t nfs 192.168.1.1:/fullpath/to/folder destfolder/
# mount ntfs in linux
sudo mount -t ntfs -o nls=utf8,umask=0222 /dev/sdb1 destfolder/
