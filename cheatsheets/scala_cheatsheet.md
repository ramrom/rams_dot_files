# SCALA
- main docs: https://www.scala-lang.org/
    - source code repo: https://github.com/scala/docs.scala-lang.git
- first compiler was written in Pizza by Martin Odersky, by scala 2.0, compiler rewritten completely in scala
- defined by the scala language specification
    - main compiler for JVM
    - Scala.js is a compiler targeted for javascript (node.js or web)
    - Scala Native uses LLVM to make native binaries
- scala-lang cheatsheet: https://docs.scala-lang.org/cheatsheets/index.html
- tour of scala: https://docs.scala-lang.org/tour/tour-of-scala.html
- martin example on for comprehensions: https://www.artima.com/pins1ed/for-expressions-revisited.html
- lightbend(formerly typesafe) founded by odersky, jonas boner(created akka), and paul phillips

## SCALA 2.11 2.12 2.13
- 2.12
    - compiler uses new java 8 VM features
    - trait compiles to java interface with default methods
    - methods that take functions can be called in both directions using lambda syntax
    - **NOT** binary compatible with 2.11, mostly source compatible
- 2.13
    - major change to collection types; simpler, more perfromant, safer
    - java8 is minimum, 2.12 and 2.13 def work on java11
    - **NOT** binary compatible with 2.12

## SCALA 3
- scala 2 compiler is probably the most infamous piece of bad scala code, pure spaghetti
- DOTTY
    - http://dotty.epfl.ch/docs/
    - new compiler based on DOT calculus that Martin and others formalized over 8 years
        - DOT calculus is a formal mathematical description of the scala language
    - used for scala 3
- scala 2.13.5 and scala 3 is completely compatible with each other
- scala 2 source -> JVM .class file; scala 3 source -> TASTy files -> JVM .class file
    - TAST (typed abstract syntax tree), a data structure that describes you scala code
    - class files lose a lot of gramattic/semantic information about scala, but TASTy preserves it

- string interpolation:
    - prints `this is Foo(3)`
        ```scala
        case Class Foo(a: Int); foo = Foo(3); println("this is ${foo}")
        ```
    - toString method is called if fooObject isnt a String
- nice typeclass definition: https://scalac.io/typeclasses-in-scala/
    - essentially ad-hoc polymorphism, inspired from haskell type classes, and very similar to golang interfaces
- https://docs.scala-lang.org/cheatsheets/index.html
- good doc on scala implicits: https://docs.scala-lang.org/tutorials/FAQ/finding-implicits.html
- scala 2.13 collections: https://docs.scala-lang.org/overviews/collections-2.13/overview.html
- run command and redirect to file
    ```scala
    import sys.process._
    import java.io.File
    ("ls -al" #> new File("files.txt")).!
    ```
- TIME/DATE: use java times and date, it is now better than jodatime


## DATA STRUCTURES
### LIST/ARRAY
- remove a item
    - `List(11, 12, 13, 14, 15).patch(2, Nil, 1)`
        - from index 2, remove 1 element with Nil (only Nil works)
    - `List(11,12,13,14,15).zipWithIndex.filter(_._2 != 2).map(_._1)`
        - will remove index 2
    - `val trunced = internalIdList.take(index) ++ internalIdList.drop(index + 1)`
- slice an "array" (`Array` or `List` or `String`)
    - `List(1,2,3,4).slice(3,4)` -> returns `List(4)`
    - `"hi there".slice(2,5)` -> returns `" th"`
### MAP/ASSOCIATIVE-ARRAY
- https://docs.scala-lang.org/overviews/collections-2.13/maps.html

```scala
val m: Map[String, Int] = Map.empty
m += ("foo", 1)    // appending an item for mutable Map
```


## CONCURRENCY
- async with thread pools: `Future { 1 + 1 }`
- mutex on variables: `synchronize { 1 + 1 }`

### PATTERN MATCHING
- `case entries @ _ :: _ :: (_: List[_]) => {`
    - more than one record

- import scala.concurrent.ExecutionContext.Implicits.global

- joda time parsing and conversion:
    - https://stackoverflow.com/questions/20331163/how-to-format-joda-time-datetime-to-only-mm-dd-yyyy/20331243

### FILE READ
- import scala.io.Source; Source.fromFile("/tmp/httpie_tmp_output2").getLines.toList   // list of lines
- import scala.io.Source; Source.fromFile("/tmp/httpie_tmp_output2").getLines.mkString // file as one big string
    - should close file too: val a = Source.fromFile("example.txt"), a.close

PlaySpecification/spec2, to skip test:
    - skipped("some reason")
    - append .pendingUntilFixed("message about the issue")

## ENUMERATION
- play 2.5 json doesnt supports scala enumerators
- can use enumeratum

## IMPLICITS
- coder doesnt need to explicilty pass in an arg/type that is implicit, the compiler will find it within scope
- scala 3 overhauled implicits

## MACWIRE/DEPENDENCY-INJECT
- macwire are basically macros, except written in scala, versus c++ macros which are a syntax of their own
- macwire happens pre-compile, guice i think happens runtime
    - desired qualities:
    > 1. Late binding, e.g. At the last moment, I can override ANY component in the graph WITHOUT refactoring my wirings. (Yes: Guice, cake, registry. No: macwire modules)
    > 2. Nearly as fast as `new` (Yes: macwire modules, cake. No: Guice)
    > 3. Multibinding (Yes: Guice, macwire modules sorta. No: cake)
    > Also other things, but those are the big ones that differ in those approaches. (edited)
- portkey uses @module annotation above class declarations, it must make classes vals' available in scope


## AUTOMATION TESTING
- https://www.scalatest.org/user_guide/using_scalatest_with_sbt
- org.mockito.ArgumentCaptor, can capture arguments, can we used in "when" mocks or "verify" method calls
- private method testing, supported by ScalaTest
    ```scala
    import org.scalatest.PrivateMethodTester._
    val someMethodRef = PrivateMethod[SomeReturnType]('nameOfPrivateMethodToAccess')
    val result = someObjectToTest invokePrivate someMethodRef(arg1, arg2)
    ```
### SCALATEST
- https://www.scalatest.org/user_guide/using_the_runner#filtering
- using with sbt: https://www.scalatest.org/user_guide/using_scalatest_with_sbt
- example with sbt
    `sbt 'project foo' 'testOnly *partString* -- -l excludeFlag'`
    `sbt 'project foo' 'testOnly -- -l excludeFlag'`
        - exclude tagged with `excludeFlag`
    `sbt 'project foo' 'testOnly *partString* -- -l "excludeFlag1 excludeFlag2" -- -n includeFlag'`
        - with these 2 exclude flags, this is logical OR, so if test has one of the tags or both, it's excluded
    `sbt 'project foo' 'testOnly -- -z "some partial string in desc"'`
        - with these 2 exclude flags, this is logical OR, so if test has one of the tags or both, it's excluded
- ignoring entire suites
    ```
    import org.scalatest.Ignore

    @Ignore
    class SomeSuiteSpec {
        ...
    }
    ```
### REST ASSURED
- ENVIRONMENT sets env
- INCLUDE, EXCLUDE env vars specify tags


## PLAY FRAMEWORK
- docs: https://www.playframework.com/documentation
- precompile routes file is converted to scala code, then it's compiled and macwire can dep inj there
- 2.8
    - supports java 11
### PLAY JSON
- https://www.playframework.com/documentation/2.8.x/ScalaJson
- parse json string -> play AST JsValue -> json string
    ```scala
    val a: String = """ {"a":1,"b":[1,2,"c"]} """
    val j: JsValue = Json.parse(a)
    (j \ "b" \ 2).get  // returns JsString("c")
    println(a == j.toString)  // should print true
    ```
- pretty print: `Json.prettyPrint(someJsValue)`

- scala native object -> play JsValue
    - `Json.toJson(foocaseclassinstance)`
        - uses play default conversions
    - can define your own implicit `Write[foocaseclassinstance]`
- play JsValue -> scala object
    - `Json.parse("[1,2,3]").as[Seq[Int]]`
        - throws `JsResultException` if it fails
    - `Json.parse("[1,2,3]").validate[Seq[Int]]`
        - `validate` returns `JsSuccess` or `JsError`

## JSON PARSING
- weePickle: https://github.com/rallyhealth/weePickle

## AMMONITE
- https://ammonite.io/
- block input:
    @ { <enter>
        x + y...
        z + f
    } <enter>
- loading external script:
    - if script in in subfolder `foo` and named `MyScript.sc` `import $file.foo.MyScript`
        - then `MyScript.someFunc("arg")`
    - if script is in grandfather dir and named `MyScript.sc` `import $file.^.^.MyScript`
    - can then `import MyScript._` to grab everything in it
- watch mode!, will run a script, and rerun if changes occur on it
    - `amm -w foo.sc`
- predef: open REPL to see results, inspect values, ca be combined with watch
    - `amm --watch --predef foo.sc`
- can shebang scala source code script with ammonite
    ```scala
    #!/usr/local/bin/amm
    val a = "hi there"
    println(a)
    ```

## CATS
- cats: https://typelevel.org/cats/datatypes/ior.html
- catseffect: https://typelevel.org/cats-effect/docs/2.x/datatypes/io

## BUILD TOOLS
- sbt, see [sbt](build_dependency_tools_cheatsheet.md#sbt)
- mill, see [build tools](build_dependency_tools_cheatsheet.md#mill)

## AKKA
- one of akka streams main goals is to implement backpressure

## SLICK
- print sql statement: https://stackoverflow.com/questions/23434286/view-sql-query-in-slick

### RANDOM
- sleep for 1 second: `Thread.sleep(1000)`
