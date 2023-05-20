# LUA
- devhits: https://devhints.io/lua
- created in brazil in 1993
- motto: "mechanisms instead of policy"

## FEATURES
- has "metamechanisms" to build complex language features
    - table (associative arrays) are fundamental mechanism
        - can make class/OOP type stuff
        - can use it to make arrays, sets, lists, records
        - can make modules
- it's simple, very fast, super C-compatible
    - binary size is 200KB for embedding
- it's garbage collected
- has closures, functions that capture variables one scope up from the env
- technically all functions are anonymous
    - declaring a named func e.g. `function foo(x) return x end` is same as `foo = function(x) return x end`
        - so named functions are really anonymous and stored in a var
- can simulate OOP style
    - the `:` operator helps a lot
    - `setmetatable` is a function build into the language
        - can call it to tie to a table, and table contains member data, and can take a methods as references with `self`
- there is no exception handling/throwing, i.e. the try/catch stuff
    - a big reason is C doesnt support this
    - use `pcall` func that takes a func and args, calls that func and returns `true` is success or `false`,`err_msg` if failure
- thread is fundamental type, they are essentially a coroutine
    - lua comes with a coroutine library
    - can do suspend and resume exection
