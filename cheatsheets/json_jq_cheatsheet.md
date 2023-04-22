# JSON
- json spec: https://www.json.org
- json-spec python cli validation example:
    - `json validate --schema-file=/foo/bar/some_schema.json --document-file=somefile.json`

## JQ
```bash
# to get keys of a object:
echo "[1, 2, {"a":1,"b":2} ]" | jq '.[2] | keys'    # will output [ "a", "b" ]

# quote keyname if it has special characters
echo '{"a.b/c d#f": 1}' | jq '."a.b/c d#f "'   # will output 1

# lenth of array:
echo "[1, 2, 222] " | jq '. | length'    # will output 3

# can do many statements with comma:
echo '{"a":1,"b":2}' | jq '.a, .b, .' # will output 1, then 2 on next line, then full has on subsequent lines

# flatten a array
echo '[1,2,[3,[4]]]' | jq 'flatten'  # prints [1,2,3,4]

# adding 2 jsons together
# -n tells jq to not read input from stdin or a file (will pass in null), useful for json math and compute json from scratch
a="[1,2,3]"
b="[11,4]"
jq --argjson arg1 "$a" --argjson arg2 "$b" -n '$arg1 + $arg2'  # will output [1,2,3,11,4]

# using contains method on sting field, need to remove null values first
jq --arg FOO $somevar 'select(.somefield != null) | select(.somefield | contains($FOO))'
jq --arg NUM $somenum '.[ NUM | tonumber ]'  # arg vars are strings, need to convert to number to index an array

# -r option strips `"` quotations characters from strings
echo '{"a":"z"}' | jq '.a'    # prints `"z"`
echo '{"a":"z"}' | jq -r '.a'    # prints `z`

# @tsv, @csv, @sh
echo '[[1,2],[3,4]]' | jq '.[] | @tsv' # print tab seperated values for each array
echo '[[1,2],[3,4]]' | jq '.[] | @csv' # print comma seperated values for each array
echo '[[1,2],[3,4]]' | jq '.[] | @sh' # print single quoted values seperated by space (good for POSIX tools)

# jq regex on a field
# this will output `{ "id":"foo", "val": 3 } { "id":"fo", "val": "hi" }`
regex=fo
echo '[ { "id":"foo", "val": 3 }, { "id":"fo", "val": "hi" }, { "id":"bar", "valz": "hey" } ]' | \
    jq --arg RGX $regex '.[] | select(.id | test($RGX))'
#  to select just the first item, wrap it in an array and index, output:`{ "id":"foo", "val": 3 }`
echo '[ { "id":"foo", "val": 3 }, { "id":"fo", "val": "hi" }, { "id":"bar", "valz": "hey" } ]' | \
    jq --arg RGX $regex '[.[] | select(.id | test($RGX))][0]'

# force color with -C and no color with -M, e.g. jq will remove color when stdout is pipe or redir to file
echo '{"a":"z"}' | jq -C . > foo
echo '{"a":"z"}' | jq -c . > foo # -c is compact, so no indents/newlines, but keeps color
cat foo  # this should have color and indents that jq formatted
```
