# JENKINS
A CI/CD open source tool
uses the [groovy language](groovy_cheatsheet.md)

## PIPELINE LANGUAGE
- https://www.jenkins.io/doc/book/pipeline/syntax/

## BUILD DEFINITIONS
- https://stackoverflow.com/questions/50398334/what-is-the-relationship-between-environment-and-parameters-in-jenkinsfile-param
    - Jenkinsfile behaviour with environment variables, global variables, build parameters

## API
main reference: https://wiki.jenkins.io/display/JENKINS/Remote+access+API
### GENERAL NOTES
- can only query build numbers in known history (same as what u see in UI)
- can create a api token and use basic auth to use the API
### QUERY/READ
base job build ULR: `https://foojenkins.org/job/someJob/build/1`
- build info in json: `https://foojenkins.org/job/someJob/build/1/api/json`
- build console text: `https://foojenkins.org/job/someJob/build/1/consoleText`
- last run build: `https://foojenkins.org/job/someJob/lastBuild`
    - `/api/json` and `/consoleText` routes work for this
#### ADVANCED QUERIES
using HTTPie here
- `http https://foojenkins.org/job/someJob/api/json pretty==true tree==builds[id,queueId,url,description]`
    - get info of all builds for job, but retrieve only certain fields
- `http https://foojenkins.org/job/someJob/api/json pretty==true tree==builds[id,queueId,url,description,actions]`
    - actions for each build only give `_class`, _i want all_
        - one action is **CauseAction** which will have the user that started it
    - using `actions[*]` instead of `actions` gives me one level in but not 2 or 3 levels in from there
- `http https://foojenkins.org/job/someJob/api/json depth==3`
     - gives a LOT including each builds detailed actions
### CREATE
create a build: `POST https://foojenkins.org/job/someJob/build`
create with params: `POST https://foojenkins.org/job/someJob/buildWithParameters?a=1&b=2`
    - works wwhen i URL encode the params here in POST, not sure about form encoded in body

this works too, _i think_, (HTTPie example here):
- `http POST --form https://foojenkins.org/job/someJob/build json='{"parameter":[{"name":"a","value":"1"},{"name":"b","value":"2"}]}'`

## CLI
- https://www.jenkins.io/doc/book/managing/cli/

## GROOVY
- cli linter https://www.npmjs.com/package/npm-groovy-lint
    - `npm-groovy-lint Jenkinsfile` - shows warning/errors/info
