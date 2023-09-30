# SPLUNK CHEATSHEET
- good practices: https://wiki.audaxhealth.com/display/ENG/Splunk+Query+Best+Practices
- keyboard shortcuts: https://docs.splunk.com/Documentation/Splunk/9.0.4/Search/Parsingsearches
- table will parse "fields" if text is "foo=bar" or json fields like { "foo": "bar" }
- inverse grep: `NOT "some stuff"`
- running a subquery and using the output of that in a new query
    - `"outside string" [ search "some string" "another string" | table Some_Field ]`
        - so a list of `Some_Field` here (ORed) will be ANDed with `"outside string"`
