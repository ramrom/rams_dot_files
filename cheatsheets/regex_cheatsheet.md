# REGEX

## GOOD REFERENCES
- https://devhints.io/regexp
- https://www.regular-expressions.info/posix.html
- https://remram44.github.io/regex-cheatsheet/regex.html
    - has POSIX ERE, BRE, Perl, vim, python
- test regexes: https://regex101.com/

Linux/GNU:
use grep -P for PCRE (perl) style regexes
grep -E, is ERE, but doesn't have things like \d

OSX:
use grep -E, this apparently has things like \d, apple confusing shit...


## Character classes
.	Any character, except newline
\d	Digit           - PCRE
[[:digit:]] Digit   - PCRE, ERE, BRE
\D	Not digit        - PCRE
[^[:digit:]] Digit   - PCRE, ERE, BRE
\w	Word
\W	Not word
\s	Whitespace               - PCRE
[[:space:]] Whitespace       - PCRE, ERE, BRE
\S	Not whitespace           - PCRE
[^[:space:]] Not Whitespace  - PCRE, ERE, BRE
[abc]	Any of a, b, or c
[a-e]	Characters between a and e
[1-9]	Digit between 1 and 9
[^abc]	Any character except a, b or c

## Anchors
\G	Start of match
^	Start of string
$	End of string
\A	Start of string
\Z	End of string
\z	Absolute end of string
\b	A word boundry
\B	Non-word boundry
^abc	Start with abc
abc$	End with abc

## Escaped characters
\. \* \\	Escape special character used by regex
\t	Tab
\n	Newline
\r	Carriage return

## Groups
(abc)	Capture group
(a|b)	Match a or b
(?:abc)	Match abc, but don’t capture

## Quantifiers
a*	Match 0 or more
a+	Match 1 or more
a?	Match 0 or 1
a{5}	Match exactly 5
a{,3}	Match up to 3
a{3,}	Match 3 or more
a{1,3}	Match between 1 and 3

## Lookahead & Lookbehind
a(?=b)	Match a in baby but not in bay
a(?!b)	Match a in Stan but not in Stab
(?<=a)b	Match b in crabs but not in cribs
(?<!a)b	Match b in fib but not in fab

## Examples
repeating a character sequence. (gnu grep)
echo "abba habba looba zzz aza " | grep -P '(a\w+a\s)+'   -> find match
echo "abba habba looba zzz aza " | grep -P '^(a\w+a\s)+$'   -> does NOT find match, the "zzz " kills it
