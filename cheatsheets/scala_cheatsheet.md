# SCALA
- string interpolation:
    - prints `this is Foo(3)`
        ```scala
        case Class Foo(a: Int); foo = Foo(3); println("this is ${foo}")
        ```
    - toString method is called if fooObject isnt a String
- nice typeclass definition: https://scalac.io/typeclasses-in-scala/
- https://docs.scala-lang.org/cheatsheets/index.html
- carter recomendation: scala implicits: https://docs.scala-lang.org/tutorials/FAQ/finding-implicits.html
- run command and redirect to file
    ```scala
    import sys.process._
    import java.io.File
    ("ls -al" #> new File("files.txt")).!
    ```

import scala.concurrent.ExecutionContext.Implicits.global

- joda time parsing and conversion:
    - https://stackoverflow.com/questions/20331163/how-to-format-joda-time-datetime-to-only-mm-dd-yyyy/20331243

### json
    ```scala
    val a: String = """ {"a":1,"b":[1,2,"c"]} """
    val j: JsValue = Json.parse(a)
    println(a == j.toString)  // should print true
    ```

file reading
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
    - org.scalatest.PrivateMethodTester._
    - val someMethodRef = PrivateMethod[SomeReturnType]('nameOfPrivateMethodToAccess)
    - val result = someObjectToTest invokePrivate someMethodRef(arg1, arg2...)

## REST ASSURED
- ENVIRONMENT sets env
- INCLUDE, EXCLUDE env vars specify tags

******* PLAY FRAMEWORK **************************
- docs: https://www.playframework.com/documentation
- per mike r. - precompile routes file is converted to scala code, then it's compiled and macwire can dep inj there

PLAY JSON:
- parse a json string into play AST JsValue
    ```scala
    Json.parse("""{"id":1,"name":"dude"}""")
    ```


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


## AKKA
---------------------------------------
- mark waks: akka streams main goal is to implement backpressure