# LUA
- devhits: https://devhints.io/lua
- created in brazil in 1993
- motto: "mechanisms instead of policy"
- Lua is compiled by Lua compiler into byte code, then byte code interpreted by Lua VM
- LuaJIT uses JIT compiler that generates machine code directly
    - JIT still compiles to byte code before being interpreted by Lua VM
    - LuaJIT interpreter records runtime stats when executing byte code, loops and function calls are tracked
        - when threshold exceeded, JIT compiler triggers, and converts that to machine code using it's IR(intermediate representation)
- LuaJIT only supports Lua 5.1

## FEATURES
- has "metamechanisms" to build complex language features: tables, closures, coroutines
- it's simple, very fast, super C-compatible
    - binary size is 200KB for embedding
- it's garbage collected
- has closures, functions that capture variables one scope up from the env
- technically all functions are anonymous
    - declaring a named func e.g. `function foo(x) return x end` is same as `foo = function(x) return x end`
        - so named functions are really anonymous and stored in a var
- there is no exception handling/throwing, i.e. the try/catch stuff
    - a big reason is C doesnt support this
    - use `pcall` func that takes a func and args, calls that func and returns `true` is success or `false`,`err_msg` if failure
- all variables are global by default (placed in a table named `_G`)
    - declare local vars with `local v = 'hi'`

## COROUTINE
- is fundamental type, a preemtable thread
- lua comes with a coroutine library
- can do suspend and resume exection

## TABLE
- (associative arrays) are fundamental mechanism
- can make class/OOP type stuff
- can use it to make arrays, sets, lists, records
- can make modules
- can simulate OOP style
    - the `:` operator helps a lot
    - `setmetatable` is a function build into the language
        - can call it to tie to a table, and table contains member data, and can take a methods as references with `self`
