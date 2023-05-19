# BUILD DEPENDENCY TOOLS CHEATSHEET

## MAKE
- oldest build tool, was used for java but really focused on c/c++ ecosystem
- main build defintion file is `Makefile`

# ANT
-  built by apache
-  stand for Another Neat Tool
- initially part of tomcat codebase built around year 2000
- doesnt support plugins, mainly a just a build tool
- all xml based and main file is `build.xml`
- apache Ivy was initially developed as subproject of Ant

## MAVEN
- built by apache to replace Ant
- Ants lack of dep management and massive xmls spurred Maven development
- uses apachy ivy for dependency management
- also uses xml like ant, but follows "convention over configuration"
    - uses predefined commands as the conventions
- way more sophisticated than ant, this is a full framework that supports plugins
- `pom.xml` - project object model, core config file
### COMMANDS
- `mvn --version` -> show maven version, show home bin, show current java version

## GRADLE
- newest and honeslty best, itself written in groovy
- built it's own dependency management to replace ivy
- instead of XML supports either Kotlin or Groovy code for the DSL
    - `build.gradle` for groovy, `build.gradle.kts` for kotlin
- building blocks are `tasks`, versus ant's `targets` and mavens `phases`

## BAZEL
- built by google and open-sourced, for java projects
- cares a lot about correctness and reliability and performance

## MILL
- for for java/scala projects
- open source built by lihaoyi, written in scala

## SBT
- the main tool used in scala projects
- as of `1.3.0` it uses Coursier to fetch artifacts/dependencies
- `%%` automatically uses scala version, `%` dev must specify
    - `"org.scala-tools" % "scala-stm_2.11.1" % "0.3"` equiv to `"org.scala-tools" %% "scala-stm" % "0.3"`
- get timings of sbt tasks:
    - time sbt -Dsbt.task.timings=true clean update test
- sbt update resolves and fetches deps
 sbt "test-only some.path.to.test another.path.to.test"
 sbt "testOnly some.path.to.test another.path.to.test"
 integration tests: `sbt "it:testOnly some.path.to.test another.path.to.test"`
- use test description filter `sbt 'testOnly *SSO* -- -z "foo bar desc"'`
   - !!!NOTE!!! the "--z" filter only works with ScalaTest, not PlaySpecification
- possible to define diff scala versions for subprojects, but has limits, can work around limits though
- to show evictions: `sbt evicted`
 - to show test deps classpath: `sbt 'show Test/dependencyClasspath'`
    - show order of which jars are loaded for project `Test`
- `sbt dependencyTree` to show dep tree (needs sbt 1.5 or greater)

## NPM
- package manager for javascript
- started as managing node.js modules, but works for front-end with browserify or webback
- default location of modules in project is `node_modules` folder
- official docs: https://npmjs.org/doc/
- uninstalling: https://docs.npmjs.com/misc/removing-npm.html
- `~/.npm` dir caches modules already downloaded
- `package.json` - specification file for a projects module dependencies
- `.npmrc` - configuration for how npm behaves
- bins are located in `node_modules/.bin` dir
- global vs local
    - a local/regular install will be scoped to current dir and all sub dirs, current dir will have `node_modules` folder
        - run `npm root` to find the current dir's root `node_modules` dir
    - `-g` for global, this is a system wide install
- list installed packages - `npm list`
    - dir of install location is first line
    - list globally installed package: `npm list -g`
- list top level packages and their most direct dependency
    `npm list --depth=1`
- remove extranous packages
    `npm prune`

## YARN
- package manager for javascript
- developed by facebook and open sourced
- generally faster than npm, uses local caches for speedups, does parrallel installs

## NVM
- node version manager, install/manage/switch between different node versions

## BOWER
- package manager for javascript specialized for just front-end
- bower includes styles packaging natively (npm needs `npm-sass` or `sass-npm`)
- uses a flat dependency tree (npm uses nested deps), so user needs to figure that out

## SDKMAN
- manage/install/switch between different java/scala/kotlin installs
- https://sdkman.io/usage#use
### COMMANDS
- `sdk current`
    - show current versions of all candidates
- `sdk current java`
    - show current version of java
- `sdk use java foo-11`
    - use foo-11 version for just current shell
- `sdk list java`
    - see all java versions available to install, which are installed, and which one is currently used
- `sdk install java 17.0.6-tem` - install a java version
