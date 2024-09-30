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
- start REPL just by typing `lua`, or start with script `lua -e some-script.lua`

## LUAJIT
- LuaJIT uses JIT compiler that generates machine code directly
    - JIT still compiles to byte code before being interpreted by Lua VM
    - LuaJIT interpreter records runtime stats when executing byte code, loops and function calls are tracked
        - when threshold exceeded, JIT compiler triggers, and converts that to machine code using it's IR(intermediate representation)
- LuaJIT only supports Lua 5.1
- often used as "scripting engines" for extensibility 
    - major applications that use it: roblox, nginx, redis, neovim, vlc, apache HTTP server, weeChat, wireshark
- LuaJIT is only like 8k lines of extra code!!!
    - https://staff.fnwi.uva.nl/h.vandermeer/docs/lua/luajit/luajit_features.html

## FEATURES
- has "metamechanisms" to build complex language features: tables, closures, coroutines
- it's simple, very fast, super C-compatible
    - binary size is 200KB for embedding
- it's garbage collected
- `function`s are closures, they capture thier environment
- lua [throws exceptions](https://www.lua.org/pil/24.3.html) (uses `setjmp` from C)
    - there is no exception handling however, i.e. the try/catch stuff
        - a big reason is C doesnt support this
    - can use `pcall` func that takes a func and args, calls that func and returns `true` is success or `false`,`err_msg` if failure
- all variables are global by default (placed in a table named `_G`)
    - declare local vars with `local v = 'hi'`

## CONTROL STRUCTURES AND LOOPS
```lua
if (a == 1) then
    print("hi")
elseif (b==2) then
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

-- regular for loop will print nil if integer index doesnt exist
a = { 1,2 }  -- traditional looking array
for i=1,4 do
    print(a[i])   -- prints  1,2,nil,nil
end

-- ipairs is builtin function, first arg i is index
-- iterate through array-like tables, will treat first index with nil as a terminaion
a = { 10,20 }; a[4] = 30   -- a has a gap, 3rd index is nil
-- below will print  1,10,2,20
for i,v in ipairs(a) do 
    print(i)
    print(v)
end

-- `pairs` iterates through record-like tables
-- this will iterate through every item, not just integer keys, and doesnt stop when it sees a nil
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

-- technically all functions are anonymous, so named functions are really anonymous and stored in a var
function foo(x) return x end
foo = function(x) return x end      -- same as above
```

## TABLE
- main docs: https://www.lua.org/pil/2.5.html
- only data structure, an object, used for **everything**
    - it's sorta fundamentally a associative arrays
    - can use it to make arrays, sets, lists, records, queues, etc
    - value can be any type: number/string/bool/function or another table, field can number/string
        - e.g. `a = { 1, f1 = 3, { "foo", 3 }, f2 = function() print("hi") end, 2, "val", function() print("a") end, z = {1, "a"} }`
            - index 1 has `1`, index 2 has `{"foo", 3 }`, index 3 has `2`, index 4 has `"val"`, index 5 has a function
- to represent a conventional array use integer keys
    - `a = { 1, x = 2 }; a[3] = 10; a[6] = 3` , `a` has `nil` at index 2, 4, and 5
- 1-based indexing: first item starts at index _1_, not _0_
    - lua inspired from Sol language, designed by petroleum engineers with no programming experience, they didnt get why u start from 0
    - tjdevries on why 1 index makes sense - https://www.youtube.com/watch?v=0uQ3bkiW5SE&ab_channel=TJDeVries
- tables are basis for modules, you attach all functions and data to them
- can define a function that takes a receiver. `a = { var = 0 }; function a.inc(self, num) self.var = self.var + num end`
- function with `:` operator - can omit `self`, e.g. `function a:inc(num) self.var = self.var + num end`
    - the `:` operator is syntax suger for adding `self` param to func call
    - so `a:inc(3)` is equivalent to `a.inc(a, 3)`
    - operator makes it more OOP-like
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

    b = a                   -- b points to same table as a
    b['k'] = 10
    print(a['k'])           -- prints 10
    b['k'] = nil            -- like global vars, assign nil to a table field to delete it
    a = nil                 -- remove variable/reference to table
    b = nil                 -- now table has zero references to it, memory manager will garbage collect table
    ```
### METATABLE
- a metatable is a way for tables to "inherit" methods/behaviour and data, see https://www.lua.org/pil/13.html
- `setmetatable` is a function build into the language, lets you override behaviour of other tables
    - can call it to tie to a table, and table contains member data, and can take a methods as references with `self`
- OOP style can be simulated with the `:` and `setmetatable` features
- `getmetatable` will print the metatable of a table
- metatables have special fields for various operators:
    - arithmetic: `+` -> `__add`, `-` -> `__sub`, `*` -> `__mul`, and also `__div`, `__unm`, `__pow`, `__concat`
    - comparison: `>` -> `__gt`, `<` -> `__lt`, `=` -> `__eq`
    - other: `__tostring`, `__index`
- types and metatables
    - numbers, booleans, and nil don't have a metatable `getmetatable(3)  -- returns nil`
        - _NOTE_ apparently ou still set a metatable for them tho
    - every string shares the same metatable

## STRINGS
- patterns and character classes for finding substring - https://www.lua.org/pil/20.2.html
```lua
s="hi there. dude"
s.find(s, "th")   -- will return start and end index of substring if found, nil otherwise
s.find(s, "d.")   -- `.` is wildcard for any single charater, looks for substring start with `d` and any one char after
s.find(s, "e%.")  -- `%` is escape, here we look for literal substring `e.`
```

## LIBRARIES
- build in `require` method is main way to load a external file and it's modules
- see https://www.lua.org/pil/8.1.html
- `require("foo")`, virtual file here is `foo`
    - looks in a path, but path is really a list of patterns, not dirs like in shell
    - say path is `?;?.lua;/yar/?.lua`, lua tries to load file `foo` in cur dir, then `foo.lua` in cur dir, then `/yar/foo.lua`
    - path is set by: global `LUA_PATH`, then env var `LUA_PATH`, then some default like `"?;?.lua"`
- `_LOADED` global variable is a table of loaded files, `require` uses this to detect if a virtual file is already loaded
- `dofile` vs `require`
    - require wont reload a file if already loaded (by using `_LOADED`)
    - require will search a path for a file

## METHODS AND SYNTAX
- global variables evaluate to `nil` if not initialized
- `pcall` lua method catches errors
    - `local ok, _ = pcall(vim.cmd, 'boguscmd')`, `ok` is bool, `false` if error was raised
- `[[ some multi line text ]]` - use double brackets for multi-line string literals
- introspect type - `a=1; print(type(a))` -> prints string `number`
    - `"str"` -> `"string"`, `nil`->`"nil"`, `false`->`"false"`, `{}` -> `"table"`, `function() end` -> `"function"`
- pretty print a table
    - see func in https://stackoverflow.com/questions/41942289/display-contents-of-tables-in-lua
- `tonumber` - convert string to number

## CONCURRENCY
- lua has coroutines, it is fundamental type, a cooperatively scheduled conncurent primitive
- api is exposed throgh `coroutine` table
- programmer sets yield points to yield control, programmer has to resume exection
- each coroutine has it's own stack and local vars
    - *UNSURE* each cortouine has 1:1 mapping to a OS thread
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
