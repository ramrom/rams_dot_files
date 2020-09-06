# 'Nix general tooling type stuff

# list all files recursively in dir and their disk usage
du -a /foo

# find a file recursive starting with current dir
find . -type f -name "*pattern*"

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
echo "2.1.1" | tr . -  # translate '.' to '-', output "2-1-1"
echo "2.03" | tr -d .  # -d to delete, this will print 203
# split on ":" delimiter, each on newline
echo foo:bar:baz | tr : \\n

# file - determine file type (osx and ubuntu has it)
file foo   # example output: "foo: ASCII text"

# sed - streaming editor
echo "2.03" | sed 's/\.//g'  # will print 203
echo "(foo)" | sed 's/[()]//g'  # will print "foo", dont have to escape parens like \( and \) with regex

# wc - word count
wc -l   # count # of lines

# sort - sort stdin of lines, waits for all input till EOF
echo "b\na" | sort   # will print a on first line, b on second line

# xargs - read lines from stdin and execute a command on each line
find . -name foo -type f | xargs cat  # find all files named foo and spit out contents to stdout

# head/tail - spit out beggining/last lines in a file
head foofile  # by default prints the first 10 lines of file
tail foofile  # last 10 lines
tail -f foofile  # spit out last lines and continue to print them as new ones are written

# bc - float point math
echo "3.1 * 4.5" | bc       # = 13.9
echo "11 * 3 / 4" | bc      # = 8, it rounds down for division

# arp cache
arp -a   # display the apr cache

# nslookup - dns lookup
nskookup example.com
nslookup example.com 1.1.1.1 # use dns server 1.1.1.1 to lookup

# dig - dns lookup, better/newer than nslookup
dig example.com
dig @1.1.1.1 example.com # use dns server 1.1.1.1 to lookup
# google public dns servers are 8.8.8.8 and 8.8.4.4

# GNU GPG
gpg -c --no-symkey-cache file.txt  # encrypt file, and dont cahce the passphrase
gpg --no-symkey-cache file.txt  # decrypt file, and dont cahce the passphrase
