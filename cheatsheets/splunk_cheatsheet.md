# SPLUNK CHEATSHEET
- good practices: https://wiki.audaxhealth.com/display/ENG/Splunk+Query+Best+Practices
- keyboard shortcuts: https://docs.splunk.com/Documentation/Splunk/9.0.4/Search/Parsingsearches

## SYNTAX
- to search literal string with spaces use double quotes: e.g. `stringA "stringB with spaces"`
- a query is implicitly `AND`'ed b/w strings
    - query `foo bar baz` is equivalent to `foo AND bar AND baz`
- parentheses work as expected in boolean expressions
    - `foo (bar OR baz)` is equivalent to `(foo AND bar) OR (foo AND baz)`
- regular expression are supported: https://docs.splunk.com/Documentation/SCS/current/Search/AboutSplunkregularexpressions
    - they are PCRE
- inverse grep: `NOT "some stuff"`
- table will parse "fields" if text is "foo=bar" or json fields like { "foo": "bar" }
- running a subquery and using the output of that in a new query
    - `"outside string" [ search "some string" "another string" | table Some_Field ]`
        - so a list of `Some_Field` here (ORed) will be ANDed with `"outside string"`
- reverse the order by timestamp: `foosearch | reverse`
