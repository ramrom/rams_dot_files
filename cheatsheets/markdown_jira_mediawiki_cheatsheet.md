# MARKDOWN/JIRA/MEDIAWIKI CHEATSHEET

## MARKDOWN
- invented by John Gruber in 2004
    - very original spec: https://daringfireball.net/projects/markdown
- in 2014 official spec CommonMark made: https://commonmark.org/
- see https://en.wikipedia.org/wiki/Markdown
- https://www.markdownguide.org/basic-syntax/
- github flavored md: https://github.github.com/gfm/
    - adds tables, fenced code block highlighting, and more
    - GH has API to convert markdown source to html 
        - https://docs.github.com/en/rest/markdown/markdown?apiVersion=2022-11-28#render-a-markdown-document
- https://devhints.io/markdown
- hack to add comments (and metadata) to a markdown: https://stackoverflow.com/questions/4823468/comments-in-markdown
- treesitter grammar for markdown: https://github.com/tree-sitter-grammars/tree-sitter-markdown
### TOOLS
- pandoc can do basic markdown conversion to html/odf/docx and others
- [marked](https://github.com/markedjs/marked) - nice js tool that converts md to html
    - has support for CommonMark and GH flavored md
- [grip](https://github.com/joeyespo/grip) is python cli tool that calls GH API to convert markdown to html/css
- [markdownlint](https://github.com/markdownlint/markdownlint) - linter for markdown, ruby project

```markdown
### PARAGRAPHS
- to create paragraphs seperate lines with one or more blank lines
- to create line breaks in same paragraph, end line wiht two or more spaces

### Horizontal rule: add 3 or more asterix, underscore, or dash
---
-------------------------------
***
**************
___
__________________________


# HEADER 1
## HEADER 2

HEADER 1 ALT
=

HEADER 2 ALT
-

### HEADER 3
#### HEADER 4
##### HEADER 5
###### HEADER 6

double asterix is more compatible than double underscore, esp in middle of word
__bold__  
**bold**  

asterix is more compatible than underscore, esp in middle of word
_italic_  
*italic*  

triple asterix is more compatible than triple underscore, esp in middle of word
___boldanditalic___  
***boldanditalic*** 

`monospace`  
``monospece with `embedded` backticks``
~~strikethrough~~  

* bullet 1
* bullet 2

- bullet 1
    - subbullet 1
    - subbullet 2
- bullet 2

1. numbered 1
    - unor 1
    - unor 2
1. numbered 2
    1. num sub 1
        1. sub sub 1
    1. num sub 2

> blockquote
> blockquote line 2

> blockquote
> line 2
>> nested blockquote


<foo@foo.com>  - turn email into link

[link name](https://someplace.com)

[ref style link][someid]

[someid]: https://www.foo.com "optional title, ref style links can be declared anywhere in doc"

## Foo Header
[foo header link sub space with dash lower case](#foo-header)

![image name](someimage.png "icon")
![image name](https://somewhere/someimage.png)

### checkboxes, supported by github markdown
- [ ] (for unchecked checkbox)
- [x] (for checked checkbox)

- Some markdown flavors support latex code between dollar signs
$some latex code$

\* \_ \{ \) \[ \- \! \| \# \+ \. \` - backslash will escape these characters

### TABLES
- delimiter b/w header and content is a row with only `-` chars and `|`s

| Syntax      | Description |
| ----------- | ----------- |
| Header      | Title       |
| Paragraph   | Text        |

The `:` controls alignment in rendered output: left, center, or right 
| Syntax      | Description | Test Text     |
| :---        |    :----:   |          ---: |
| Header      | Title       | Here's this   |
| Paragraph   | Text        | And more      |


### FOOTNOTES
footnotes are not basic markdown, definitely in extended flavors 
Here's a simple footnote,[^1] and here's a longer one.[^bignote]

[^1]: This is the first footnote.

[^bignote]: Here's one with multiple paragraphs and code.

    Indent paragraphs to include them in the footnote.

    `{ my code }`

    Add as many paragraphs as you like.
```

### CODE BLOCKS
```ruby
def foo
    puts "hi"
end
```



## MEDIAWIKI
- https://www.mediawiki.org/wiki/Help%3aFormatting
- `''italic''` - italic
- `'''bold'''` - bold
- `''''bold + italic''''` - bold + italic
- headers/levels
    - `== Level 2 ==` to `====== Level 6 ======` , level 2 biggest, 6 renders smallest



## JIRA
- https://jira.atlassian.com/secure/WikiRendererHelpAction.jspa?section=all

.  - bring up search menu

JIRA MARKUP:
\* - use backslash, escape char for literals

h1. biggest heading
h6. smallest heading

*strong*  (bold)
_emphasis_ (italic)
+inserted+  (underlined)
-deleted-  (strikethrough)
^superscript^
~subscript~
{{monospaced}}  (kind of different font)

bq. some blocked quote

{quote}
line 1
line 2
{quote}

---    solid line
--     smaller solid line
----   horizontal ruler

* bullet
** subbullet

# number
## subnumber
# number 2
#* bullet under number

{noformat}
preformatted piece of text
 so *no* further _formatting_ is done here
{noformat}

{color:#FF0000}text{color}

{code:title=Bar.java|borderStyle=solid}
// Some comments here
public String getFoo()
{
    return foo;
}
{code}

{code:JSON}
{ "a": 1, "b": [ 1, 2, true] }
{code}

{panel:title=My Title|borderStyle=dashed|borderColor=#ccc|titleBGColor=#F7D6C1|bgColor=#FFFFCE}
a block of text surrounded with a *panel*
yet _another_ line
{panel}
