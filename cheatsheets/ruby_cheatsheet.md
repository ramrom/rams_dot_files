# RUBY

## SCRIPTING
```sh
ruby -e 'puts "hi"'   # execute ruby code
ruby -e 'puts ARGV[0]' foo   # read inputs, will print "foo"
ruby -e 'puts ARGV[0].to_i + ARGV[1].to_i' 1 2    # read inputs, which are always strings, prints "3"
```

## GEM
- `gem install --user-install somegem` - install as user (root is default)

## HIGHER ORDER FUNCTIONS
- lambda
    - will error if exact number of args are not given
    - return statement will return control to calling function
- proc
    - very similar to lambda
    - if proc takes N args, and called with N-1, last arg will be `nil`, if called with N+1, last arg is ignored
    - return statement will return from proc and calling function
- code blocks
    - an anonymous function that can be invoked from within another function

```ruby
# puts
STDERR.puts "failure!" # this writes to stderr, puts normally writes to stdout

# Find all objects of a type and do something to them
ObjectSpace.each_object(Array) { |ob| puts ob.object_id }

# Find which parent class or module defines a method
Array.instance_method(:map)

# For class methods
Array.method(:try_convert)

# Get source location
Array.instance_method(:map).source_location

# pp source code for method
Array.instance_method(:map).source.display

# To get mem consumption of object
require 'objspace'
i = 342423423423423423432342
ObjectSpace.memsize_of(i)

# Another method, probably better to get an idea of mem size:
Marshal.dump(a).size

f = File.open 'path/somefile'; 
require 'json'; j = JSON.parse(f)
j.each_with_index { |data,i| f= File.open("newfile#{i}",'w'); f.write(data.to_json); f.close }


# add ANSI colors to strings
#
# Example Usage: `puts "I'm bold and green and backround red".bold.green.bg_red`

class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end
```
