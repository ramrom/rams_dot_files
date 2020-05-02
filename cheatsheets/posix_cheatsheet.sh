# Posix type stuff

# list all files recursively in dir and their disk usage
du -a /foo

# find a file recursive starting with current dir
find . -type f -name "*pattern*"

# get terminal info
infocmp

#awk - multi purpose tool
echo "foo bar baz" | awk '{print $2}'  # will print bar

# cut - select data in each line by byte/char position or delimiter char
echo "foo; bar - baz" | cut -d ';' -f 2  # delimiter semicolon , extract field 2, so " bar - baz" will print

# tr - translate chars, find and replace on specific chars
echo "2.03" | tr -d .  # -d to delete, this will print 203

# sed - streaming editor
echo "2.03" | sed 's/\.//g'  # will print 203

# head/tail - spit out beggining/last lines in a file
head foofile  # by default prints the first 10 lines of file
tail foofile  # last 10 lines
tail -f foofile  # spit out last lines and continue to print them as new ones are written

# bc - float point math
echo "3.1 * 4.5" | bc       # = 13.9
echo "11 * 3 / 4" | bc      # = 8, it rounds down for division
