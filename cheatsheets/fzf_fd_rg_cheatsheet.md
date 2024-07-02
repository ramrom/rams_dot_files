# FZF RG FD
- fd + rg synergy: `fd filenamepattern | xargs rg contentpattern`
    - fd offers more power filtering that rg's globs and whatnot
    - rg outputs results nicer, fd's `-x` with rg isnt as pretty, so piping into rg better

## RG
- uses rust regex, it's perl-like: https://docs.rs/regex/1.3.9/regex/bytes/index.html#syntax
- rg vs ag vs ack vs grep: https://beyondgrep.com/feature-comparison/

- ignoring files to search
    - search hidden: `rg --hidden`
    - u:`--no-ingore`, uu:`--no-ignore --hidden`, uuu:`--no-ignore --hidden --binary`
    - `rg -uuu` gets close to rgrep
- list filetype defs
    `rg --type-list`
- search go and sh types, not javascript
    `rg -tgo -tsh -Tjs`
- print results in json!
    `rg --json`
- max dir deptt `rg --max-depth=1 foo` (search `foo` only 1 dir deep)
- would search in file /bar/befooyar/dude/wut
    - `rg -g '**/*foo*/**' pattern`
- -o to to only return what matched, and -r to replace what was matched with capture groups or whatever
    `echo "foo-bar baz" | rg -o ".*-(b..).*$" -r 'yar'`
        - will return "yar"
- use `-g` globs to search specific files and dirs
    `rg -g 'foo/bar/**' -g '!*bar*' -g 'yar/xy*'`
        - match all files in foo/bar and recurce, and filenames starting with xy in folder yar
        - but exclude any file/folder with bar in it.
        - order matter, for multiple matches, later globs take precedence
- search for files with a pattern but not another pattern
    `rg --files-with-matches 'somepattern' | xargs rg --files-without-match 'notthispattern'`
- get context (lines before or after) a search hit
    - `rg -A 1 -B 2 'foo'` - print the one line after and 2 lines before each search hit

## FZF
- https://github.com/junegunn/fzf, main README has good docs
 - preview with bat
    - `fzf --preview 'bat --style=numbers --color=always {} | head -500'`
- only take 40% of screen
    - `fzf --height 40`
- open vim windows for all fzf matches
    ```sh
    vim -o `fzf -m`
    ```
- invoke bat on result
    - `fzf | xargs bat`
- exact match searching only
    `fzf -e`
- fuzzy search only the 2nd field (default delimiter is space)
    `fzf -nth=2`
- enable multi select (+m means disable multi select)
    `fzf -m`
- if 1 match select it
    - `fzf -1`
search:
    > foo         (fuzzy foo)
    > !foo        (exact, not foo)
    > 'foo        (exact match foo)
    > ^foo        (exact prefix, foo at beg of line)
    > foo$        (eact suffix, foo at end of line)
    > 'foo\ bar   (exact match with space "foo bar")
    > foo | bar   (fuzzy, foo or bar)
    > foo bar     (fuzzy, foo and bar)
- interpret ansi as well, (slower performace)
    `fzf --ansi`
- `**` autocompletion (can change this trigger sequence)
    - `cd **<TAB>`  - fzf on dirs from current dir
    - `kill <TAB>` or `kill **<TAB>`   - will fzf over process list
    - `ssh **<TAB>`    - will fzf over ssh history of IPs and hostnames
    - `unset **<TAB>`, `export **<TAB>`, `unalias **<TAB>` - over aliases/env vars
- `<ctrl-r>`
    - at cmd line, fzf over command history, relavent sorted, hit `ctrl-r` again to chrono order
- `foo some string bar <ctrl-t>`
    - at cmd line, fzf over files/dir and selection text inserted after `foo some string bar`
- `<alt-c>`  (option is alt in osx)
    - at cmd line, fzf over dirs and cd to selection


## FD
- *NOTE* jul'24 - if .gitigore has `!.foo` then fd will show the hidden file, `.foo` even if you ask it to ignore hidden files
```sh
fd "^\.foo|yar$"  # regex search, here find all files starting with ".foo" OR files ending with "yar"
fd -H "foo"       # search hidden files
fd -H -I "foo"    # search hidden files and git ignored files
fd -p             # match on full path (default file/dir name)
fd -e pdf         # find all files with extension pdf
fd --type f       # close to find, old match on file types

fd . foo/ -S +2ki    # find all files greater than 2kb in folder foo
fd . foo/ -S +2ki -x du -hs   # find all files greater than 2kb in folder foo and print their human readable size

# find all files in current dir, including hidden, that end in "foo" and run ls -al on them
fd -t f -d 1 -H "foo$" -x ls -al

fd -d 4 --min-depth 2   # only show items with depth between 2 and 4
fd --exact-depth 3      # only show items exactly 3 dirs deep

# use sh trick here to run complex commands
fd . somedir/ -x sh -c 'printf "something"; echo {}; echo "hi"'
```


## BAT
- default color scheme is "Monokai Extended Bright"
