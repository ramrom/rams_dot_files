# LUA
- devhits: https://devhints.io/lua
- home page - https://www.lua.org/home.html
- 5.3 ref guide: https://www.lua.org/manual/5.3/
- programming in lua is great guide - https://www.lua.org/pil/
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
- examples
    ```lua
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

## TABLE
- first item starts at index _1_, not _0_
- only data structure, an object, used for **everything**
    - it's sorta fundamentally a associative arrays
    - can use it to make arrays, sets, lists, records, queues, etc
    - can contain a mix of many field=value and values
        - e.g. `a = { 1, f1 = 3, { "foo", 3 }, f2 = function() print("hi") end, 2, "val", function() print("a") end, z = {1, "a"} }`
    - value can be any type: number/string/bool/function or another table, field can number/string
- can make modules
- can simulate OOP style
    - define a function that takes a receiver. `a = { var = 0 }; function a.inc(self, num) self.var = self.var + num end`
        - can call `a.inc(self, 3)`
        - the `:` operator makes it more OOP, can call without `self`, so `a:inc(3)`
            - can also declare method with `:` to omit `self` -> `function a:inc(num) self.var = self.var + num end`
    - `setmetatable` is a function build into the language
        - can call it to tie to a table, and table contains member data, and can take a methods as references with `self`
- create table and insert - `t={} table.insert(t,"item1") table.insert(t,{})`
- dottable field name, `a={ f1 = 1, f2 = 2}; a["f1"] = 3; a.f1 = 2`
- to delete a table field assign `nil` to it

## METHODS AND SYNTAX
- `pcall` lua method catches errors
    - `local ok, _ = pcall(vim.cmd, 'boguscmd')`, `ok` is bool, `false` if error was raised
- `[[ some multi line text ]]` - use double brackets for multi-line string literals
- introspect type - `a=1; print(type(a))` -> prints string `number`
- variadic args - `function foo(...) print(...) end`, `...` means variable number of args
    - all arguments are collected into a table, accessible as hidden param named `arg`
- global variables evaluate to `nil` if not initialized
- if function has single argument and it's a literal string or table, then no parens are needed
- iterate through array-like tables, use `ipairs`, i is index: `for i,v in ipairs(t) do body end`
- iterate through record-like tables, use `pairs`: `for k,v in pairs(t) do body end`
- pretty print a table
    - see func in https://stackoverflow.com/questions/41942289/display-contents-of-tables-in-lua
- tables 
    ```lua
    a = {}              - {}
    table.insert(a,1)  -- {1}
    table.insert(a,3)  -- {1, 3}
    a["k"] = 4         -- {1, 3, "k": 4 }
    a[10] = {1,2}     -- {1, 3, "k": 4, 10: {1,2} }
    a(2)            -- returns 3
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
