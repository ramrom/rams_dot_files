# GROOVY
- dynamically-typed but can also type variables
- built for the JVM
- https://groovy-lang.org
- https://groovy-lang.org/install.html -> can use sdkman to install
- https://groovy-lang.org/single-page-documentation.html - decent cheatshseet
- learn x in y - https://learnxinyminutes.com/docs/groovy/
- it's the primary scripting language for [jenkins pipelines](jenkins_cheatsheet.md)

## INSTALL
- `groovy -version` - get version
- `groovysh` -> REPL
- `groovyc` -> compiler
- cli linter https://www.npmjs.com/package/npm-groovy-lint , nice for Jenkinsfiles
    - `npm-groovy-lint Jenkinsfile` - shows warning/errors/info

## EXAMPLES
```groovy
println "hi"    // print to stdout

a = [x: 1]      // a Map type
if (a instanceof Map) { println "i'm a map" }       // instanceof builtin for primitive types
```
