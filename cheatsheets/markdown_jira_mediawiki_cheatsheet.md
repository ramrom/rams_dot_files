# MARKDOWN/JIRA CHEATSHEET:

## MARKDOWN REFERENCES
- https://en.wikipedia.org/wiki/Markdown
- https://www.markdownguide.org/basic-syntax/
- very original spec: https://daringfireball.net/projects/markdown
- original md: https://commonmark.org/
- github flavored md: https://github.github.com/gfm/
- https://devhints.io/markdown
- hack to add comments (and metadata) to a markdown: https://stackoverflow.com/questions/4823468/comments-in-markdown

## Paragraphs
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
###### HEADER 6

__bold__  
**bold**  (double asterix is more compatible than double underscore, esp in middle of word)  
_italic_  
*italic*  (asterix is more compatible than underscore, esp in middle of word)  
___boldanditalic___  
***boldanditalic*** (triple asterix is more compatible than triple underscore, esp in middle of word)  
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

### Code blocks
```ruby
def foo
    puts "hi"
end
```

- Some markdown flavors support latex code between dollar signs
$some latex code$

\* \_ \{ \) \[ \- \! \| \# \+ \. \` - backslash will escape these characters

Tables:
|   |   |   |   |   |
|---|---|---|---|---|
|   |   |   |   |   |
|   |   |   |   |   |
|   |   |   |   |   |


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
