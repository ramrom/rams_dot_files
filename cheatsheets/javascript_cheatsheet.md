# JAVASCRIPT
- decent doc on js event loop in browser - https://developer.mozilla.org/en-US/docs/Web/JavaScript/Event_loop
    - main thread is the event loop on queue, that handle any javascript code
    - there are other threads, particularly ones that handle networking calls and will add to event queue
- callack hell: http://callbackhell.com/
- ECMAScript Modules (ESM) - official standard for packaging javascript code into modules
    - uses `import` and `export` keywords
- typescript uses `require` function to import modules when targetting CommonJS module format.

## DIALECTS
- coffeescript
- typescript

## TYPE SYSTEM
- javascript arrays are hashmaps under the hood, so an index is really a key into the hashmap

## INTROSPECTION
- `typeof` - return a string describing the type
    - `typeof(3)` -> returns `'number'`, `typeof("foo")` -> `'string'`, `typeof(nil)` -> `'undefined'`
    - `typeof({})` -> `'object'`, `typeof(false)` -> `'boolean'`, `typeof([1,2])` -> `'object'`

## NPM
- node package manager
- see [build cheat](build_dependency_tools_cheatsheet.md)

## NVM
- node version manager
- see [build cheat](build_dependency_tools_cheatsheet.md)

## RUNTIMES
- V8 - written by google, used in chromium browsers
- spidermonkey - used in firefox
- javascriptcore - used in safari
- deno - modern runtime in rust, uses V8, supports typescript/javascript
- bun - runtime written in zig

## CONCURRENCY
- javascript is inherently single-threaded
- uses a main event loop and relies on callbacks to be concurrent
### PROMISES
- added in ECMAScript in june 2015
- a function that returns a value that will be completed in the future
- created to help reduce callback hell, can chain promises together with `then` for success, `catch` for failure/exception
### ASYNC/AWAIT
- introduced in ECMAScript in 2017 (ES8)
 - `async` keyword that defines a function that returns a promise
 - `await` function is syntax sugar to use when calling a async function in another async function
 - much nicer to read and handle promises and looks like synchronous code
### TIMERS
- `setTimeout` and `setInterval` are async non-blocking scheduler methods that are built-in to javascript
- `setTimeout` 
    - run a function after a time delay
    - e.g. `let timerId = setTimeout(my_timed_func, delay, param1, param2...)`
    - can cancel with `Window.clearTimeout()`
- `setInterval` 
    - run a function every x interval
    - e.g. `let intervalId = setInterval(my_repeating_func, interval, param1, param2...)`
    - can canel with `Window.clearInterval()`

## ANGULAR
- "AngularJS" - refers to old framewor, version 1.x , and is EOL
- "Angular" refers to 2.x
- Zone.js - core mechanism for automatic change detection
    - monkey-patches browser APIs like `setTimeout`, `Promise`, and event listeners
    - when async events finishes, `NgZone` service notified, which triggers check for updates across entire component tree
    - each Zone is a execution context that persists across async tasks
    - expensive, _every_ async event triggered a change detection cycle for whole app
- Zoneless Angular
    - replaces Zone.js
    - much faster, entire component tree is not scanned
    - signals - fine grained reactvity
    - zoneless mode angular v20+, use DOM events, signal updates, async pipe for change detection

## LIBS
- [jquery](https://jquery.com/) - manipulate HTML DOM
- [chartjs](https://github.com/chartjs/Chart.js) - popular charting lib
