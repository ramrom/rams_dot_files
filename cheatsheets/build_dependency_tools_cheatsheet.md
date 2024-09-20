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
- maven in 5min: https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html
- multi-module projects: https://www.baeldung.com/maven-multi-module
- has `goals` and `phases`
    - building a phase will build all phases dependenent on it
- default phases: `validate`(validate project info), `compile`, `test`, `package`(build jar)
    - `integration-test`, `verify`, `install`, `deploy`
- cool extension that lets u use non-xml formats: https://github.com/takari/polyglot-maven
### COMMANDS
- `mvn --version` -> show maven version, show home bin, show current java version
- `mvn package` -> build the `package` phase, generally a later phase
    - will compile, run tests, build jar
- running tests
    - `mvn test -Dtest=TestCircle` - run all tests in class name `TestCircle`
        - `mvn test -Dtest=com.full.path.SomeTest` - can specify full path
        - `mvn test -Dtest=TestCircle#xyz test` - same as above but also only with method name `xyz test`
        - `mvn test -Dtest=Test*#xyz*` - can use `*` wildcard in test class and method name
    - `mvn -DexcludeGroups="foo"`  - dont run suites/tests tagged with `foo` (Junit5)
        - `mvn package -Dgroups=!"bar"` - `!` negation syntax also excludes
    - `mvn -Dgroups="bar"`  - only run suites/tests tagged with `bar` (Junit5)
        - see https://howtodoinjava.com/junit5/junit-5-tag-annotation-example/
    - `mvn -X ...`  - debug level console logging, `mvn -q ...` (quiet) no logging, 
        - *NOTE* this controls only maven logs itself, not like java application logs

## GRADLE
- newest and honeslty best, itself written in groovy
- built it's own dependency management to replace ivy
- instead of XML supports either Kotlin or Groovy code for the DSL
    - `build.gradle` for groovy, `build.gradle.kts` for kotlin
- building blocks are `tasks`, versus ant's `targets` and mavens `phases`

## BAZEL
- built by google and open-sourced, for java projects
- does a lot of caching
- cares a lot about correctness and reliability and performance

## MILL
- for for java/scala projects
- open source built by lihaoyi, written in scala

## BLOOP
- build server developed by scala center
- https://scalacenter.github.io/bloop/docs/what-is-bloop
- supports 2 main protocols
    -  Nailgun server protocol
    - BSP **reccomended** (used by metals and intellij)

## LSP
- see [LSP section in this doc](tech_standards_info.md)

## SCALA CLI
- https://scala-cli.virtuslab.org/
- more for scripting and rapid prototyping
- not really a build tool, can easily specify scala version and jvm version

## SBT
- the main tool used in scala projects
- files
    - `build.sbt` -> main project defs
    - `project/plugins.sbt` -> defines sbt plugins
    - `project/build.properties` -> sbt version, etc
    - `project/Dependencies.scala` -> list deps, import in `build.sbt`
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
- sbt has BSP support in 1.4.0, see https://www.scala-lang.org/blog/2020/10/27/bsp-in-sbt.html

## NPM
- package manager for javascript
- started as managing node.js modules, but works for front-end with browserify or webback
- default location of modules in project is `node_modules` folder
- official docs: https://npmjs.org/doc/
- uninstalling: https://docs.npmjs.com/misc/removing-npm.html
- `~/.npm` dir caches modules already downloaded
- `package.json` - specification file for a projects module dependencies
- `package-lock.json` - specific version of all libs and transitive deps installed based on `package.json`
    - npm v7 will read `yarn.lock` file for metadata if it exists, but still generate `package-lock.json` file
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

## FRONT END TOOLING
- babel - javascript traspiler
- terser - javascript minifier
- webpack - bundles many js files into one, written in javascript
- vite - bundler like webpack, generally faster
- browserify - javascript bundler
- turbopack - bundler like webpack, written in rust, orders of magnitudes faster, developed by devs on Next.js

## YARN
- package manager for javascript
- developed by facebook and open sourced
- generally faster than npm, uses local caches for speedups, does parrallel installs
- 

## NVM
- node version manager, install/manage/switch between different node versions

## BOWER
- package manager for javascript specialized for just front-end
- bower includes styles packaging natively (npm needs `npm-sass` or `sass-npm`)
- uses a flat dependency tree (npm uses nested deps), so user needs to figure that out

## SDKMAN
- manage/install/switch between different java/scala/kotlin installs
- generally installs the languages in `~/.sdkman/candidates/` dir
- https://sdkman.io/usage#use
### COMMANDS
- `sdk install java 17.0.6-tem` - install a java version
- `sdk current`
    - show current versions of all candidates
- `sdk current java`
    - show current version of java
- `sdk use java foo-11`
    - use foo-11 version for just current shell
- `sdk list java`
    - see all java versions available to install, which are installed, and which one is currently used
- `sdk default java 17.0.6-tem` - set default java version for all shells
- `sdk config`  - will open to edit the default config file
