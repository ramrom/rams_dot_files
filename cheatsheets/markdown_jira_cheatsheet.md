# MARKDOWN/JIRA CHEATSHEET:
-----------------------

## MARKDOWN REFERENCES
----------------------------------------
- https://en.wikipedia.org/wiki/Markdown
- original md: https://commonmark.org/
- https://www.markdownguide.org/basic-syntax/
- github flavored md: https://github.github.com/gfm/
- https://devhints.io/markdown

## Paragraphs
- to create paragraphs seperate lines with one or more blank lines
- to create line breaks in same paragraph, end line wiht two or more spaces

### Horizontal rule: add 3 or more asterix, underscore, or dash
---
-------------------------------
***
**************
___
-------------------


# header 1
## header 2
###### header 6

__bold__  
**bold**  (double asterix is more compatible than double underscore, esp in middle of word)  
_italic_  
*italic*  (asterix is more compatible than underscore, esp in middle of word)  
___boldanditalic___  
***boldanditalic*** (triple asterix is more compatible than triple underscore, esp in middle of word)  
`monospace`  
``monospece with `embedded` backticks``
~strikethrough~  

horizontal rule:
---

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

## Foo Header
[foo header link sub space with dash lower case](#foo-header)

![image name](someimage.png "icon")
![image name](https://somewhere/someimage.png)

### Code blocks
```ruby
def foo
    puts "hi"
end
```

\* \_ \{ \) \[ \- \! \| \# \+ \. \` - backslash will escape these characters

Tables:
|   |   |   |   |   |
|---|---|---|---|---|
|   |   |   |   |   |
|   |   |   |   |   |
|   |   |   |   |   |

## JIRA:
-----------------------
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

{panel:title=My Title|borderStyle=dashed|borderColor=#ccc|titleBGColor=#F7D6C1|bgColor=#FFFFCE}
a block of text surrounded with a *panel*
yet _another_ line
{panel}
