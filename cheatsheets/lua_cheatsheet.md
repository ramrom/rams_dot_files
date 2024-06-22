# LUA
- devhits: https://devhints.io/lua
- home page - https://www.lua.org/home.html
- 5.3 ref guide: https://www.lua.org/manual/5.3/
- programming in lua is great guide - https://www.lua.org/pil/
- learn lua in y min - https://learnxinyminutes.com/docs/lua/
- nice comparison to other langs: http://lua-users.org/wiki/LuaComparison
- created in brazil in 1993
- motto: "mechanisms instead of policy"
- Lua is compiled by Lua compiler into byte code, then byte code interpreted by Lua VM

## LUAJIT
- LuaJIT uses JIT compiler that generates machine code directly
    - JIT still compiles to byte code before being interpreted by Lua VM
    - LuaJIT interpreter records runtime stats when executing byte code, loops and function calls are tracked
        - when threshold exceeded, JIT compiler triggers, and converts that to machine code using it's IR(intermediate representation)
- LuaJIT only supports Lua 5.1
- often used as "scripting engines" for extensibility 
    - big applications like nginx, redis, neovim, vlc, apache HTTP server, weeChat, wireshark
- LuaJIT is only like 8k lines of extra code!!!
    - https://staff.fnwi.uva.nl/h.vandermeer/docs/lua/luajit/luajit_features.html

## FEATURES
- has "metamechanisms" to build complex language features: tables, closures, coroutines
- it's simple, very fast, super C-compatible
    - binary size is 200KB for embedding
- it's garbage collected
- has closures, functions that capture variables one scope up from the env
- technically all functions are anonymous
    - declaring a named func e.g. `function foo(x) return x end` is same as `foo = function(x) return x end`
        - so named functions are really anonymous and stored in a var
- lua [throws exceptions](https://www.lua.org/pil/24.3.html) (uses `setjmp` from C)
    - there is no exception handling however, i.e. the try/catch stuff
        - a big reason is C doesnt support this
    - can use `pcall` func that takes a func and args, calls that func and returns `true` is success or `false`,`err_msg` if failure
- all variables are global by default (placed in a table named `_G`)
    - declare local vars with `local v = 'hi'`

## CONTROL STRUCTURES AND LOOPS
```lua
if (a = 1) then
    print("hi")
elseif (b=2) then
    print("b="..b)
else
    print("else")
end

while (i < 10) do
    i = i + 1
    if (z == 30) then break end  -- break will exit the current loop scope
end

repeat
until (somevar == 3)

for i=1,5 do
    print("hi")
end

-- iterate through array-like tables, use `ipairs`, i is index
for i,v in ipairs(t) do 
    -- body
end

-- iterate through record-like tables, use `pairs`
for k,v in pairs(t) do 
    -- body
end
```

## FUNCTIONS
```lua
local foo = function(a, b)
    print(a)
    print(b)
end

foo(1)          -- unspecified args are set to nil,  this prints 1 , then nil
foo(1,2,3)      -- exta args are silently discarded, this prints 1, then 2

-- variadic args , `...` means variable number of args
-- all arguments are collected into a table, accessible as hidden param named `arg`
function foo(...) 
    print(...) 
end
foo("hi", "there") -- will splat to `print("hi","there")` in function foo

function foo() return 1,2 end   -- function can return multiple values
x,y = foo()                     -- assign multiple return values to variables

-- if function has single argument and it's a literal string or table, then no parens are needed
function onearg(myarg)
    print(myarg)
end
onearg("dude")  -- same as below
onearg "dude"
```

## TABLE
- only data structure, an object, used for **everything**
    - it's sorta fundamentally a associative arrays
    - can use it to make arrays, sets, lists, records, queues, etc
    - can contain a mix of many field=value and values
        - e.g. `a = { 1, f1 = 3, { "foo", 3 }, f2 = function() print("hi") end, 2, "val", function() print("a") end, z = {1, "a"} }`
    - value can be any type: number/string/bool/function or another table, field can number/string
- 1-based indexing: first item starts at index _1_, not _0_
    - lua inspired from Sol language, designed by petroleum engineers with no programming experience, they didnt get why u start from 0
    - tjdevries on why 1 index makes sense - https://www.youtube.com/watch?v=0uQ3bkiW5SE&ab_channel=TJDeVries
- tables are basis for modules, you attach all functions and data to them
- can define a function that takes a receiver. `a = { var = 0 }; function a.inc(self, num) self.var = self.var + num end`
- function with `:` operator - can omit `self`, e.g. `function a:inc(num) self.var = self.var + num end`
    - the `:` operator is syntax suger for adding `self` param to func call
    - so `a:inc(3)` is equivalent to `a.inc(a, 3)`
    - operator makes it more OOP-like
- metatables are tables with functions in it
- `setmetatable` is a function build into the language, lets you override behaviour of other tables
    - can call it to tie to a table, and table contains member data, and can take a methods as references with `self`
- OOP style can be simulated with the `:` and `setmetatable` features
- key/value("associate-array"-like) items dont affect the index order of non-key/value ("array"-like) items
    ```lua
    a = {}              -- create blank table
    table.insert(a,1)  -- {1}
    table.insert(a,3)  -- {1, 3}
    a['k'] = 4         -- {1, 3, "k": 4 }

    -- has dottable field names
    a.k                 -- returns 4
    a['k']              -- returns 4

    a[10] = {1,2}           -- {1, 3, "k": 4, 10: {1,2} }
    a[2]                    -- returns 3
    table.insert(a,"hi")    -- {1, 3, "hi", "k": 4, 10: {1,2} }
    a[3]                    -- returns "hi"
    a = nil                 -- assign nil to delete a table
    ```

## METHODS AND SYNTAX
- global variables evaluate to `nil` if not initialized
- `pcall` lua method catches errors
    - `local ok, _ = pcall(vim.cmd, 'boguscmd')`, `ok` is bool, `false` if error was raised
- `[[ some multi line text ]]` - use double brackets for multi-line string literals
- introspect type - `a=1; print(type(a))` -> prints string `number`
- pretty print a table
    - see func in https://stackoverflow.com/questions/41942289/display-contents-of-tables-in-lua

## CONCURRENCY
- lua has coroutines, it is fundamental type, a cooperatively scheduled conncurent primitive
- api is exposed throgh `coroutine` table
- programmer sets yield points to yield control, programmer has to resume exection
- each coroutine has it's own stack and local vars
```lua
-- examples
c = coroutine.create(function() print('hi') end); 
print(c) -- thread: 0x8071d98
print(coroutine.status(c))  -- suspended
coroutine.resume(c)  -- prints hi
print(coroutine.status(c))  -- dead

c2 = coroutine.create(function() print('hi'); coroutine.yield(); print('hi again') end); 
coroutine.resume(c2)  -- prints hi
coroutine.resume(c2)  -- prints hi again
print(coroutine.status(c2))  -- dead
```

## HELPFUL CODE
- deep query a table, handling nils
    ```lua
    -- t = {a = {b = {c = 5}}}
    -- lookup(t, 'a', 'x', 'b') -- Returns nil
    -- lookup(t, 'a', 'b', 'c') -- Returns 5

    function lookup(t, ...)
        for _, k in ipairs{...} do
            t = t[k]
            if not t then
                return nil
            end
        end
        return t
    end
    ```
