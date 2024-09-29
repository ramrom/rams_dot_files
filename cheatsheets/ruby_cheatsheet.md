# RUBY
- https://www.ruby-lang.org/en/
- https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/
    - Matz said "3x3" - ruby 3 JIT is 3x faster than ruby 2

## HISTORY
- ruby 3
    - introduced `Ractor`(ruby actors) class, each one has it's own RIL(ruby interpreter lock), this allows true OS thread parallelism

## DOCS
- official - https://ruby-doc.org/
- https://www.tutorialspoint.com/ruby/index.htm
- XinYmin: https://learnxinyminutes.com/docs/ruby/
- cheatsheet: https://www.scribd.com/document/2944819/Ruby-Syntax-Cheatsheet


## BUILD TOOLS
### GEM
- the way to package libraries and code
- `gem install --user-install somegem` - install as user (root is default)
### BUNDLER
- https://bundler.io/
- gem that lets you specify project dependencies
- `Gemfile` - main file where u declare deps
- `Gemfile.lock` - exact versions or every gem to use based on last bundle on `Gemfile`

## VARIABLES
### SCOPE
- local(method scope) `var`
- instance(object scope) `@var`
- class(global within all class instances) `@@var`
- global(program) `$var`

## CONCURRENCY
- ruby 1.8/1.9 - https://bugfactory.io/articles/multithreading-in-the-mri-ruby-interpreter/
- https://dev.to/enether/working-with-multithreaded-ruby-part-i-cj3

## IDIOMS
- `!` - methods ending in exclamation marks mutate the internal data
- `?` - methods ending in question mark return a boolean


## ITERATORS
- Enumerable module that mixed into array and maps
```ruby
# RANGE
(-1..2).to_a                # returns [-1, 0, 1, 2]
('a'..'c').to_a             # returns ['a', 'b', 'c']
(0..2) == Range.new(0,2)    # true
(1..4).each { |i| puts i }  # supports enumerator

[1,2,3].each_with_object([]) do |item, obj|
    puts "item is #{item}"
    obj << item * 2
end                                     # output is [2,4,6]

[:a, :b, :c].each_with_index do |val, idx|
    puts "#{idx}; #{val}"
end
 
# NOTE: collect is essentially the same method as map
[1,2,3,4].map{ |a| a * 3 }.filter{ |a| a.even? }   # output is [6,12]
["a", "b", 4].any? { |i| i.class == Integer }   # output true
["a", [1,2], 4].all? { |i| i.class == String }   # output false

x = [ { a: 1, b: 2}, { a: 2, b: 2}, {a: 1, b: 10} ]
x.group_by { |i| i[:a] }  # output {1=>[{:a=>1, :b=>2}, {:a=>1, :b=>10}], 2=>[{:a=>2, :b=>2}]}
```

## DATA STRUCTS
- Hash for associative array and Array for arrays are core built-in data structs
```ruby
# slice returns subhash of a hash
a = { "a" => 3, b: 4, 1 => "dude" }
a.slice("a", :b)        # returns { "a" => 3, b: 4 }

# ActiveSupport has except, the opposite of slice
a.except("a", :b)        # returns { 1 => "dude" }

## ARRAY
a = Array.new(3)          # initialze array of size 3 with nils
a = [1,2]
a.append(3)                # append to end of array
a << 4                     # same as append 
a.prepend(7)               # add to beginning of array
b = [1,2]
b.insert(1, 10)            # insert value 10 at index 2, so [1,10,2]
b.insert(4, 20)            # insert 20 at idx 4, if len exceeded nils values padded in, so this is [1,10,2,nil,20]
a.first                    # returns 1
a.last                     # returns 2
a = [3,1,2]; a.sort        # return [1,2,3]
a = [3,1,2]; a.sort!       # modifies a to [1,2,3]
a.include?(10)             # return false
[1,2,3].max                # returns 3
[1,2,3].min                # returns 1
a=[1,2,3]; a(1..2)         # slice, inclusive, returns [2,3]
[1,2,3,4].find{ |i| i.even? }  # will return 2

# HASH
h = { foo: {bar: {baz: 1}}}
h.dig(:foo, :bar, :baz)     #=> 1
h.dig(:foo, :zot, :xyz)     #=> nil

g = { foo: [10, 11, 12] }
g.dig(:foo, 1)              #=> 11
g.dig(:foo, 1, 0)           #=> TypeError: Integer does not have #dig method
g.dig(:foo, :bar)           #=> TypeError: no implicit conversion of Symbol into Integer

h = {a: 1, b: 2}
h.keys          # returns  [ :a, :b ]
h.key?(:a)      # return true
h.value?(3)     # return false
```
### STRINGS
```ruby
"hi there"[1..2]            # returns "ub"
```

## IO
```ruby
# puts
STDERR.puts "failure!" # this writes to stderr, puts normally writes to stdout
```

## CONTROL FLOW
```ruby
if true
    "is true"
elsif false
    "else if"
else
    "else"
end

i=1; num=5;
while i < num  do
   puts("Inside the loop i = #{i}" )
   i +=1
end

begin
    puts "in loop"
    i -= 1
end while i > 0

# lonely operator (safe navigation), if expression evaluates to nil, then lonely operator on nil will return nil
a = nil
a.foo           # throws no method error
a&.foo&.bar  # returns nil
```

## TYPES
```ruby
# CLASSES
class Foo
    attr_accessor :field1
    attr_writer :field2
    attr_reader :field2

    def initialize(f1, f2)
        @field1 = f1
        @field2 = f2
    end
end

f = Foo.new
```
### HIGHER ORDER FUNCTIONS
- lambda
    - will error if exact number of args are not given
    - return statement will return control to calling function
- proc
    - very similar to lambda
    - if proc takes N args, and called with N-1, last arg will be `nil`, if called with N+1, last arg is ignored
    - return statement will return from proc and calling function
- code blocks
    - an anonymous function that can be invoked from within another function


## INTROSPECTION
```ruby
a=1
a.object_id             # will return some integer, uniquely identifies an object
a.class                 # return Integer
a.class.class           # return Class
a.class.class.class     # return Class  :)
a.kind_of? Integer      # returns true

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
```
- doc on memory introspection - https://blog.skylight.io/hunting-for-leaks-in-ruby/

## SCRIPTING
```sh
ruby -e 'puts "hi"'   # execute ruby code
ruby -e 'puts ARGV[0]' foo   # read inputs, will print "foo"
ruby -e 'puts ARGV[0].to_i + ARGV[1].to_i' 1 2    # read inputs, which are always strings, prints "3"
```

## FILE HANDLING
```ruby
f = File.open 'path/somefile'; 
require 'json'; j = JSON.parse(f)
j.each_with_index { |data,i| f= File.open("newfile#{i}",'w'); f.write(data.to_json); f.close }
```

## COLOR
```ruby
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

## RAILS
- guide - https://guides.rubyonrails.org/index.html
- rails sessions - https://www.justinweiss.com/articles/how-rails-sessions-work/
- rails autoload magic - https://www.urbanautomaton.com/blog/2013/08/27/rails-autoloading-hell/

## MAJOR LIBS/FRAMEWORKS
- awesome ruby, collection of good libs - https://awesome-ruby.com/
- sidekiq
- arel - used by ActiveRecord to build AST for sql query
    - https://jpospisil.com/2014/06/16/the-definitive-guide-to-arel-the-sql-manager-for-ruby
- celluloid - used to be used by sidekiq
    - critique - https://www.mikeperham.com/2015/10/14/should-you-use-celluloid/
- unicorn - popular forking web server
    - use with nginx - https://www.honeybadger.io/blog/how-unicorn-talks-to-nginx-an-introduction-to-unix-sockets-in-ruby/
