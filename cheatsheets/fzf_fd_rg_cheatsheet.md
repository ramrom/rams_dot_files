## RG:
- uses rust regex, it's perl-like: https://docs.rs/regex/1.3.9/regex/bytes/index.html#syntax
- rg vs ag vs ack vs grep: https://beyondgrep.com/feature-comparison/

- gets close to rgrep: `rg -uuu`
    - u:nogitingore, uu:hidden, uuu:binary
- list filetype defs
    `rg --type-list`
- search go and sh types, not javascript
    `rg -tgo -tsh -Tjs`
- print results in json!
    `rg --json`
- would search in file /bar/befooyar/dude/wut
    - `rg -g '**/*foo*/**' pattern`
- -o to to only return what matched, and -r to replace what was matched with capture groups or whatever
    `echo "foo-bar baz" | rg -o ".*-(b..).*$" -r '$1'`
        - will return "bar"
- use `-g` globs to search specific files and dirs
    `rg -g 'foo/bar/**' -g '!*bar*' -g 'yar/xy*'`
        - match all files in foo/bar and recurce, and filenames starting with xy in folder yar
        - but exclude any file/folder with bar in it.
        - order matter, for multiple matches, later globs take precedence

## FZF:
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

## FD:
fd -p        - match on full path (default file/dir name)
fd --type f  - close to find, old match on file types
fd -t f -d 1 -H "foo$" -x ls -al   - find all files in current dir, including hidden, that end in "foo" and run ls -al on them
fd . somedir/ -x sh -c 'printf "something"; echo {}; echo "hi"'            - use sh trick here to run complex commands
