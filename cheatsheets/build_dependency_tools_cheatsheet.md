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

## GRADLE
- newest and honeslty best, itself written in groovy
- built it's own dependency management to replace ivy
- instead of XML supports either Kotlin or Groovy code for the DSL
    - `build.gradle` for groovy, `build.gradle.kts` for kotlin
- building blocks are `tasks`, versus ant's `targets` and mavens `phases`

## NPM
- node package manager
- official docs: https://npmjs.org/doc/
- uninstalling: https://docs.npmjs.com/misc/removing-npm.html
- list globally installed package
    `npm list -g`
- list packages installed in most local project, dir of install location is first line
    `npm list`
- list top level packages and their most direct dependency
    `npm list --depth=1`
- remove extranous packages
    `npm prune`

## NVM
- node version manager, install/manage/switch between different node versions
