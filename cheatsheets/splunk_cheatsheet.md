# SPLUNK CHEATSHEET
- good practices: https://wiki.audaxhealth.com/display/ENG/Splunk+Query+Best+Practices
- keyboard shortcuts: https://docs.splunk.com/Documentation/Splunk/9.0.4/Search/Parsingsearches

## SYNTAX
- to search literal string with spaces use double quotes: e.g. `stringA "stringB with spaces"`
- a query is implicitly `AND`'ed b/w strings
    - query `foo bar baz` is equivalent to `foo AND bar AND baz`
- parentheses work as expected in boolean expressions
    - `foo (bar OR baz)` is equivalent to `(foo AND bar) OR (foo AND baz)`
- inverse grep: `NOT "some stuff"`
- searching parsed field
    - exact match - `field1=foo`
    - wildcard match = `field1=*yar*`
    - comparison - `foo bar | where field2>10`
- regular expression are supported: https://docs.splunk.com/Documentation/SCS/current/Search/AboutSplunkregularexpressions
    - they are PCRE
- table will parse "fields" if text is "foo=bar" or json fields like { "foo": "bar" }
- running a subquery and using the output of that in a new query
    - `"outside string" [ search "some string" "another string" | table Some_Field ]`
        - so a list of `Some_Field` here ("OR"-ed) will be "AND"-ed with `"outside string"`
- reverse the order by timestamp: `foosearch | reverse`
- timechart examples - https://docs.splunk.com/Documentation/SCS/current/SearchReference/TimechartCommandExamples
    - `...| timechart span=1h count` - log count every hour
    - `...| timechart span=1h count by host` - log count every hour for each host
    - `... | timechart span=1m avg(CPU) BY host` - average CPU field every minute for each host
