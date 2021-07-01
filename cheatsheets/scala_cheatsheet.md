# SCALA
- scala-lang cheatsheet: https://docs.scala-lang.org/cheatsheets/index.html
- tour of scala: https://docs.scala-lang.org/tour/tour-of-scala.html
- martin example on for comprehensions: https://www.artima.com/pins1ed/for-expressions-revisited.html

## SCALA 3
- scala 2 compiler is probably the most infamous piece of bad scala code, pure spaghetti
- DOTTY
    - http://dotty.epfl.ch/docs/
    - new compiler based on DOT calculus that Martin and others formalized over 8 years
        - DOT calculus is a formal mathematical description of the scala language
    - used for scala 3
- scala 2.13.5 and scala 3 is completely compatible with each other
- scala 2 source -> JVM .class file, scala 3 source -> TASTy files
    - TAST (typed abstract syntax tree), a data structure that describes you scala code

- string interpolation:
    - prints `this is Foo(3)`
        ```scala
        case Class Foo(a: Int); foo = Foo(3); println("this is ${foo}")
        ```
    - toString method is called if fooObject isnt a String
- nice typeclass definition: https://scalac.io/typeclasses-in-scala/
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


### RANDOM
- sleep for 1 second: `Thread.sleep(1000)`


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

## ENUMERATION:
- play 2.5 json doesnt supports scala enumerators
- can use enumeratum

## MACWIRE/DEPENDENCY-INJECT:
- macwire are basically macros, except written in scala, versus c++ macros which are a syntax of their own
- macwire happens pre-compile, guice i think happens runtime
    - desired qualities:
    > 1. Late binding, e.g. At the last moment, I can override ANY component in the graph WITHOUT refactoring my wirings. (Yes: Guice, cake, registry. No: macwire modules)
    > 2. Nearly as fast as `new` (Yes: macwire modules, cake. No: Guice)
    > 3. Multibinding (Yes: Guice, macwire modules sorta. No: cake)
    > Also other things, but those are the big ones that differ in those approaches. (edited)
- portkey uses @module annotation above class declarations, it must make classes vals' available in scope

## SCALATEST
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


## AUTOMATION TESTING
- https://www.scalatest.org/user_guide/using_scalatest_with_sbt
- org.mockito.ArgumentCaptor, can capture arguments, can we used in "when" mocks or "verify" method calls
- private method testing, supported by ScalaTest
    ```scala
    import org.scalatest.PrivateMethodTester._
    val someMethodRef = PrivateMethod[SomeReturnType]('nameOfPrivateMethodToAccess')
    val result = someObjectToTest invokePrivate someMethodRef(arg1, arg2)
    ```

## REST ASSURED
- ENVIRONMENT sets env
- INCLUDE, EXCLUDE env vars specify tags

## PLAY FRAMEWORK
------------------------------
- docs: https://www.playframework.com/documentation
- precompile routes file is converted to scala code, then it's compiled and macwire can dep inj there

## JSON PARSING
- weePickle: https://github.com/rallyhealth/weePickle

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


## AMMONITE
----------------------------------------
- https://ammonite.io/
- block input:
    @ { <enter>
        x + y...
        z + f
    } <enter>
- loading external script:
    - if script in in subfolder foo and named MyScript.sc `import $file.foo.MyScript`
        - then MyScript.someFunc("arg")
    - if script is in grandfather dir and named MyScript.sc `import $file.^.^.MyScript`
    - can then `import MyScript._` to grab everything in it
- watch mode!, will run a script, and rerun if changes occur on it
    - amm -w foo.sc
- predef: open REPL to see results, inspect values, ca be combined with watch
    - amm --watch --predef foo.sc
- can shebang scala source code script with ammonite
    ```scala
    #!/usr/local/bin/amm
    val a = "hi there"
    println(a)
    ```


## SLICK
-------------------------
- print sql statement: https://stackoverflow.com/questions/23434286/view-sql-query-in-slick


## SBT
----------------------------------------
- get timings of sbt tasks:
    - time sbt -Dsbt.task.timings=true clean update test
- sbt update resolves and fetches deps
 sbt "test-only some.path.to.test another.path.to.test"
 sbt "testOnly some.path.to.test another.path.to.test"
 integration tests: sbt "it:testOnly some.path.to.test another.path.to.test"
 sbt 'testOnly *SSO* -- -z "foo bar desc"'
   - !!!NOTE!!! the "--z" filter only works with ScalaTest, not PlaySpecification
- possible to define diff scala versions for subprojects, but has limits, can work around limits though
- to show evictions: `sbt evicted`


## AKKA
---------------------------------------
- one of akka streams main goals is to implement backpressure
