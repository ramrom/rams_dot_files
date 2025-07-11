# BUILD DEPENDENCY TOOLS CHEATSHEET
- transitive dependency - if project deps on lib A and lib A deps on lib B, then project transitively deps on lib B
- vendoring - including a 3rd party library direclty into the project without using some dependency management tool to fetch it
    - convention is to store the library code in the projects `/vendor` dir
- shading - a technique to allow for multiple versions of the same library to be used in the same project without conflict

## MAKE
- oldest build tool, was used for java but really focused on c/c++ ecosystem
- main build defintion file is `Makefile`

# ANT
- built by apache
- stand for Another Neat Tool
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
- setting java version
    - maven will use the shell's `JAVA_HOME` java version
    - baeldung - https://www.baeldung.com/maven-java-version
        - in `configuration` tag we can set a target and source java version
        - spring boot lets u set a `property` `<java.version>17</java.version>` in `pom.xml`
- artifacts
    - looks in local cache at `/.m2/repository/` for artifacts before trying to fetch
    - if not in cache, looks in repo list, which can be anywhere including local or remote networks
        - `~/.m2/settings.xml` might specify a repository
    - a `mirror` is a repository that syncs with another repo, usually more remote repo
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
- built by google in 2015 from internal tool Blaze
- bazel was open-sourced version of Blaze, intended for java projects, particularly large monorepos
- does a lot of caching
- cares a lot about correctness and reliability and performance
- supports BSP, see https://github.com/JetBrains/hirschgarten

## MILL
- for for java/scala projects
- open source built by lihaoyi, written in scala

## BLOOP
- build server developed by scala center - https://scalacenter.github.io/bloop/
- uses zinc for incremental compiling
- https://scalacenter.github.io/bloop/docs/what-is-bloop
- supports 2 main protocols
    -  Nailgun server protocol
    - BSP **reccomended** (used by metals and intellij)
- defines projects via JSON files: https://scalacenter.github.io/bloop/docs/configuration-format/
- supports importing builds from other build tools like sbt, mill, gradle

## LSP
- language servers - https://langserver.org/
    - introduced in 2016 for microsoft VSCode, then made an open standard
- uses JSON RPC for message passing b/w client and server
- DAP (debug adapter protcol) - abstracts debugging tool, complementary to LSP
- extension: tree view protocol
- extension: decoration protocol, for displaying non-editable text
    - e.g. inlay hints, dignostic virtual text
### BSP
- build server protocol, abstracts the build tool, complementary to LSP
- see https://build-server-protocol.github.io/
- LSP server can be a _client_ to build server using BSP to talk to it
- editor/lsp-client (LSP)-> language server (BSP)-> build tool
    - editor sends file changed event in LSP, lang serv says compile in BSP to build tool, bld tool compiles and returns diagnostic
- bloop was first build server to implement BSP, scala metals lang server uses BSP to talk to bloop
    - sbt adds BSP support in 1.4.0
### SCALA METALS 
- a language server built on top of [scala meta library](https://scalameta.org/), METALS = META(scalameta) + LS(language server)
- scalameta constructs a semanticDB(a open specification), which powers gotodef, findrefs, etc
    - e.g. files like `FooSourceFile.scala.semanticdb` in BSP's(e.g. `.bloop`) folder
- metals uses scala presentation compiler - special compiler just for IDE tooling, it's async/partial/cancellable/fast
- uses scalafix for refactoring
- 2024 - uses BSP to talk to [bloop](https://scalacenter.github.io/bloop/) by default
    - will convert any build system (e.g. `build.sbt`) into bloop JSON definitions automatically
    - can configure other build servers like sbt itself: https://scalameta.org/metals/docs/build-tools/sbt
- metals 1.3.x requires java 11 or java 17
- sept2024 - nvim-metals seems to start the latest metals server that works for that scala ver
    - e.g. 2.13.6 scala starts metals ver 0.11.x
- sept2024 - _NOTE_ for reseting project, make sure `project/.bloop` and `project/project/` dirs deleted for base bloop to install right

## IVY
- [apache ivy](https://ant.apache.org/ivy/) is a dependency fetching and management tool
- developed along side apache Ant

## COURSIER
- https://get-coursier.io/
- pure scala written artifact fetcher
- on osx coursier caches is located in `~/Library/Caches/Coursier/`
- `coursier install sometool` - to install
- `coursier uninstall sometool` - remove
- `coursier list` - list installed apps

## SBT
- the main tool used in scala projects
#### LIBRARY MANAGEMENT
- https://www.scala-sbt.org/1.x/docs/Library-Management.html
- [resolver](https://www.scala-sbt.org/1.x/docs/Resolvers.html) -  configuration for repository that contains jars and their dependencies
    - uses the standard Maven2 repo by default
- [files/dirs](https://www.scala-sbt.org/1.x/docs/Directories.html)
    - `build.sbt` -> main project defs, written in a scala based DSL
    - `project/plugins.sbt` -> defines sbt plugins
    - `project/build.properties` -> sbt version, etc
    - `project/`  - any `*.scala` and `*.sbt` files are loaded, add helpers here
        - common convention is have a `Dependencies.scala` file that list deps
        - since `build.sbt` and these files are scala they need to be compiled first, this is called the `meta-build` (vs `proper-build`)
        - can go recursive, so `project/project/*.scala`  files get compiled b4 `meta-build`, so it's a `meta-meta-build`
    - `lib/` - store for unmanaged libraries, all included in classpath for `compile`,`test`,`run`
- sbt 1.3.0+ uses Coursier to fetch artifacts/dependencies, instead of Ivy
- artifact format
    - basic pattern: `libraryDependencies += groupID % artifactID % revision`
    - `%%` automatically uses scala version, `%` dev must specify
        - e.g. `"org.scala-tools" % "scala-stm_2.11.1" % "0.3"` equiv to `"org.scala-tools" %% "scala-stm" % "0.3"`
- `sbt update` resolves and fetches deps
- conflict manager - entity that handles when dep tree requires 2 different version of same lib
    - default manager will use latest version
    - can use `dependencyOverrides` to override/specify a version of a dep
### OTHER
- sbt 1.4.0+ has BSP support, see https://www.scala-lang.org/blog/2020/10/27/bsp-in-sbt.html
- sbt 1.0+ uses [zinc incremental compiler](https://github.com/sbt/zinc), only compiles new changes
- `sbt help foo` - help on command `foo`
- Projects
    - `sbt projects` - list projects
    - `sbt 'project foo' compile` - only compile project `foo`
    - create project
        - scala2 - `sbt new scala/hello-world.g8`
        - scala3 - `sbt new scala/scala3.g8`
- get timings of sbt tasks
    - `time sbt -Dsbt.task.timings=true clean update test`
- Testing
    - `sbt "test-only some.path.to.test another.path.to.test"`
    - `sbt "testOnly some.path.to.test another.path.to.test"`
    - use test description filter `sbt 'testOnly *SSO* -- -z "foo bar desc"'`
       - _NOTE_ the `-z` filter only works with ScalaTest, not PlaySpecification
- possible to define diff scala versions for subprojects, but has limits, can work around limits though
### DEPENDENCIES
- to show evictions: `sbt evicted`
 - to show test deps classpath: `sbt 'show Test/dependencyClasspath'`
    - show order of which jars are loaded for project `Test`
- full: `sbt "inspect tree clean"`
- more specific sbt: `whatDependsOn <org> <module> <version>`
    - needs plugin [dep graph](https://www.scala-sbt.org/sbt-dependency-graph/index.html)
- `sbt dependencyTree` to show dep tree (needs sbt 1.5 or greater)

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
- `npm config list` - see the current configuration
    - will display the location of `.npmrc` files that are applied
- `.npmrc` - configuration for how npm behaves
    - per-project - e.g.`/path/to/projct/.npmrc`
    - per-user - e.g.`~/.npmrc`
    - global - e.g.`$PREFIX/.npmrc`
    - built-in npm - e.g.`/path/to/npminstall/.npmrc`
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
- list all dependency paths dependend on `foo-package`
    - `npm ls --all foo-package`
- dependencies
    - docs: https://docs.npmjs.com/cli/v8/configuring-npm/package-json#dependencies
    - `^` carat in package name, e.g. `foo: "^1.2.3"` , npm allowed to upgrade to newer versions in same major version
    - `~` carat in package name, e.g. `foo: "~1.2.3"` , npm allowed to upgrade to newer versions in same minor version


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

## NVM
- node version manager, install/manage/switch between different node versions
- commands
    - `nvm list` - list installed node.js versions
    - `nvm version` - current active node.js versoin
    - `nvm --version` - version of nvm itself

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
- `sdk default java 17.0.6-tem` - set default java version for all shells
    - this changes the `current` symlink in `~/.sdkman/candidates/java/current` to point to the new version
- `sdk current`
    - show current default versions of all candidates
- `sdk current java`
    - show current default version of java
- `sdk use java foo-11`
    - use foo-11 version for just current shell
- `sdk list java`
    - see all java versions available to install, which are installed, and which one is currently used
- `sdk config`  - will open to edit the default config file
    - file located at `~/.sdkman/etc/config`

## JENKINS
- a FOSS build system: [see main cheat](./jenkins_cheatsheet.md)

## GITHUB ACTIONS
- a build system in github, competes with Jenkins
