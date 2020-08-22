# JQ

# to get keys of a object:
echo "[1, 2, {"a":1,"b":2} ]" | jq '.[2] | keys'    # will output [ "a", "b" ]

# lenth of array:
echo "[1, 2, 222] " | jq '. | length'    # will output 3

# can do many statements with comma:
echo '{"a":1,"b":2}' | jq '.a, .b, .' # will output 1, then 2 on next line, then full has on subsequent lines

# using contains method on sting field, need to remove null values first
jq --arg FOO $somevar 'select(.somefield != null) | select(.somefield | contains($FOO))'

# -r option strips `"` quotations characters from strings
echo '{"a":"z"}' | jq '.a'    # prints `"z"`
echo '{"a":"z"}' | jq -r '.a'    # prints `z`

# jq regex on a field
regex=fo
echo '[ { "id":"foo" }, { "id":"fo" }, { "id":"bar" } ]' | jq --arg RGX $regex 'keys | select(. | test($RGX))'
# this will output `{ "id":"foo" } { "id":"fo" }`

# force color with -C and no color with -M, e.g. jq will remove color when stdout is pipe or redir to file
echo '{"a":"z"}' | jq -C . > foo
echo '{"a":"z"}' | jq -c . > foo # -c is compact, so no indents/newlines, but keeps color
cat foo  # this should have color and indents that jq formatted
