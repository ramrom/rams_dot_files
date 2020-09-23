# JENKINS

## API
main reference: https://wiki.jenkins.io/display/JENKINS/Remote+access+API

### Query/Read
base job build ULR: `https://foojenkins.org/job/someJob/build/1`
- build info in json: `https://foojenkins.org/job/someJob/build/1/api/json`
- build console text: `https://foojenkins.org/job/someJob/build/1/consoleText`

last run build: `https://foojenkins.org/job/someJob/lastBuild`
- `/api/json` and `/consoleText` routes work for this

### Create
create a build: `POST https://foojenkins.org/job/someJob/build`
create with params: `POST https://foojenkins.org/job/someJob/buildWithParameters?a=1&b=2`
    - works wwhen i URL encode the params here in POST, not sure about form encoded in body
