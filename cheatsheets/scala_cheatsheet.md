# SCALA
- main docs: https://www.scala-lang.org/
    - source code repo: https://github.com/scala/docs.scala-lang.git
- barebone cheatsheet - https://docs.scala-lang.org/cheatsheets/index.html
- tour of scala: https://docs.scala-lang.org/tour/tour-of-scala.html
- first compiler was written in Pizza by Martin Odersky, by scala 2.0, compiler rewritten completely in scala
- defined by the scala language specification
    - main compiler for JVM
    - Scala.js is a compiler targeted for javascript (node.js or web)
    - Scala Native uses LLVM to make native binaries
- lightbend(formerly typesafe) founded by odersky, jonas boner(created akka), and paul phillips

## SCALA VERSIONS
### 2.12
- compiler uses new java 8 VM features
- trait compiles to java interface with default methods
- methods that take functions can be called in both directions using lambda syntax
- **NOT** binary compatible with 2.11, mostly source compatible
### 2.13
- major change to collection types; simpler, more perfromant, safer
- java8 is minimum, 2.12 and 2.13 def work on java11
- **NOT** binary compatible with 2.12
### 3
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
- has propery `enum` enumation type
- introduces union type and intersection type


## TYPE SYSTEM
- `val` - immutable variable, `var` - mutable variable
    - *NOTE* the value a `val` contains can mutate
    - e.g. changing field value works `case class Foo(var x: Int); val v = Foo(1); v.x = 10;`
- Trait - cant be instantiated directly
    - a class can implement MANY traits
    - can NOT specify a constructor parameter
- Abstract class - cant be instantiated
    - class can implement only ONE abstract class
    - can specify a constructor parameter
- nice typeclass definition: https://scalac.io/typeclasses-in-scala/
    - be able to define a trait contract for some types without modifying those types directly
    - essentially ad-hoc polymorphism, inspired from haskell type classes, and very similar to golang interfaces
- integer types - `Short` (16bit), `Int` (32bit?), `Long` (64bit?)
    - `Long` instantiation - `1000000000000000000L` or `100000: Long`
- `Any` - all objects implement this, `Nothing` - opposite of `Any`, no object implements this
- generics are a compile time check, and suffer from type erasure during runtime on the JVM
    ```scala
    val l1 = List(1, 2, 3)
    assert(l1.isInstanceOf[List[Int]], "l1 is a List[Int]")        // returns true, expected
    assert(l1.isInstanceOf[List[String]], "l1 is a List[String]")  // returns true!

    val seq : Seq[Int] = Seq(1,2,3) // compiler validates generics at compile time
    val seq : Seq = Seq(1,2,3)   // this is what JVM runtime actually has, generic type info is erased
    ```
### CLASSES
- multiple inheritence, diamond problem -> scala serializes the tree
    - order matters, so last trait that implements same method will get defined
### IMPLICITS
- good doc on scala implicits: https://docs.scala-lang.org/tutorials/FAQ/finding-implicits.html
- implicit conversion: automatically convert a type to another type if a implicit converter func exists in scope
    - 
    ```scala
    implicit def inttostring(i: Int): String = { s"int is: ${i}" }
    def printstring(s: String): Unit = { println(s) }
    printstring("hi")   // prints "hi"
    printstring(3)   // prints "int is 3", implicitly converted using implicit conversion function
    ```
- scala 3 implicits are overhauled
    - `given` keyword to declare implicit, `using` to pass in implicit
    - `Conversion[A,B]` typeclass introduced to define implicit conversion from A->B
### COMPANION OBJECT
- defining `apply` method lets you instantiate companion class without `new` keyword
    - `val a = Foo("dude")` compiles to `val a = Foo.apply("dude")`
- companion class and object can access each others private members
### CASE CLASS
- e.g. `case class Foo(i: Int, s: String)`
- constructor params are `val`s by default
- get a default `apply` and `unapply` automatically defined
    - pattern matching needs `unapply` defined if you want to match on fields
- get `toString` and `equal` methods auto-implemented
### FUNCTIONS
- partial application - can pass subset of arguments to function invocation, then pass rest in later
- call-by-name parameters are evaluated only when val is used in func body, e.g. func sig: `foo(i: => Boolean)`


## COLLECTIONS
- scala 2.13 collections: https://docs.scala-lang.org/overviews/collections-2.13/overview.html
### TUPLES
- `val t = ("a","b","c")`
- access fields: `t._1` (returns `a`), `t._4` (errors, field 4 doesnt exist)
### LIST/ARRAY
- `List` is immutable, underlying is linked-list, so indexing is slow
- `Vector` is immutable, indexing is fast
- `l.last` - return last item in collection
- multidimensional
    - `val v = Array.ofDim(2,2)[Int]; v(0) = Array(1,1); v(0)(1)`
    - `val v = collection.mutable.ArrayBuffer.fill(3,3)(1)`
- remove a item
    - `List(11, 12, 13, 14, 15).patch(2, Nil, 1)`
        - from index 2, remove 1 element with Nil (only Nil works)
    - `List(11,12,13,14,15).zipWithIndex.filter(_._2 != 2).map(_._1)`
        - will remove index 2
    - `val trunced = internalIdList.take(index) ++ internalIdList.drop(index + 1)`
- foreach over a List of tuple
    - `List((1,2),(3,5)).foreach { (v: (Int, Int)) => println(s"v._1 and v._2") }`
        - slightly confusing syntax, need one arg and specify it's a tuple
    - `List(3,4,5).zipWithIndex.foreach { case (a, b) => println(s"${a} and ${b}") }`
        - can use pattern match to unapply the tuple to name the fields
- slice an "array" (`Array` or `List` or `String`)
    - `List(1,2,3,4).slice(3,4)` -> returns `List(4)`
    - `"hi there".slice(2,5)` -> returns `" th"`
- `fold` `val l = List(1,2,3); val sum = l.fold(0)((x,y) => x + y)`    -> `sum` will = 6
    - `foldLeft` iterates from leftmost element to right, `foldRight` iterates from rightmost element to left
- `++` concat 2 collections, `::` prepend to list, `:+` append, `+:` prepend
    - `1 :: List(3)` -> returns `List(1,3)`
    - `val l = List(1); 4 +: l :+ 3`  returns new list `List(4,1,3)`
- `find` - `List(1,2,3).find(_ % 2 == 0)`   -> returns `Some(2)`
- mutable
    - `ArrayBuffer` -> underlying data struct is array, can be resized
    - `Array` - is mutable like `ArrayBuffer`, NOT resizable
        - generally backed by JVM basic array, more efficient than `ArrayBuffer`
    - `ListBuffer` -> underlying data struct is linked list
        - to append: `l.append(1)` or `l += 1`
### MAP/ASSOCIATIVE-ARRAY
- https://docs.scala-lang.org/overviews/collections-2.13/maps.html
- examples
    ```scala
    val m: Map[String, Int] = Map.empty
    val m = Map("a"->1, "b"->2)
    m + ("foo" -> 3)        // returns a NEW map which also contains ("foo"-> 1)
    m += (2->3)             // will raise exception, cant mutate, use mutable Map
    m.keys                  // returns a Set containing keys
    m.getOrElse("z",10)     // since "z" key doesnt exist, the default 10 is returned
    val mu = scala.collection.mutable.Map(1->2)   // mutable map (will be HashMap)
    mu + (2->3)   // like immutable man, returns a NEW map which also contains (2->3)
    mu += (2->3)    // append (2->3) to mu
    mu -= 2    // remove key/val with key=2 from mu
    ```
### STREAMS
- like collection but lazily evaluated so can be optimized when chaining them together
- regular collections that u might chain with things like `map` and `filter` will eagerly create intermediate data structures
- deprecated in 2.13.0 in favor of `LazyList`
- streams/LazyList allow us to represent infinite computations, e.g. a fibonacci sequence, sequence of all natural numbers

## STRINGS
- toString method is called if fooObject isnt a String
- index returns a `Char` - `val s = "hello"; s(1);` returns `e`
- `map` operates on each char in string, `"hi".map(_+"a")` -> returns `ArraySeq("ha", "ia")`
- multi-line string with `"""` - e.g. `val s: String = """ i can add literal " double quote """`
- escape with `\` - `val s: String = "escaped with \" \\ new line \n woo"`
- findandreplace: ` "foo bar baz".replaceAll("ba","zz")` -> outputs `"foo zzr zzz"`
- `StringBuilder` commonly used for building strings
    - `val b = new StringBuilder; b += "hi"; b += " there"; b.toString`
- get substring(aka slice): `val s = "hello there"; s.substring(2,4)` - returns `String` `ll`
- prints `this is Foo(3)`
    ```scala
    case Class Foo(a: Int); foo = Foo(3); println("this is ${foo}")
    ```

## MATH
- `scala.math.pow(2.1,3.4)` -> 2 to power of 3

## MONADS
### Either
- `flatMap` and `map` are right-biased, mapping on left val returns same val
    - `Right(1).map { x => x + 1 }   # returns Right(2)`
    - `val a: Either[Int, Int] = Left(1).map { x => x + 1 }   # returns Left(1)`
### Option
- `flatMap`/`map` operate on `Some` and pass on `None`
- `foo.getOrElse(2)` - if `foo` is `Some(1)` returns `1`, if `None` returns `2`
- `isDefined` returns `true` if `Some`, `false` if `None`
- `isEmpty` - opposite of `isDefined`
### Try
- returns `Failure` if excpetion thrown, or `Success` if not
- `import scala.util.Try; Try(1 + 1)`   -> returns `Success(2)`
- `import scala.util.Try; Try(throw new Exception("foo"))`   -> returns `Failure(exception = java.lang.Exception: foo)`
    - `Try { 1 + 1 } match { case Success(s) => println("worked"); case Failure(ex) => println(ex) }` - success
    - `Try { throw new Error() } match { case Success(s) => println("worked"); case Failure(ex) => println(ex) }` - failure
### EitherT
- type from cats

## FOR COMPREHENSIONS
- syntax sugar for chaining `flatMap`
- good martin example on for comprehensions: https://www.artima.com/pins1ed/for-expressions-revisited.html
- generator: `for (i <- 1 until 3) yield i` -> returns `Vector(1,2,3)`

## LOOPS
- `for (i <- 1 until 5) println(i)`  - regular for loop
- `for (i <- List(1,2,3)) println(i)`  - regular for loop

## CONCURRENCY
### FUTURES
- is a monad
- async with execution contexts: `Future { 1 + 1 }`
    - `import scala.concurrent.ExecutionContext.Implicits.global`
- an execution context is a abstraction that include a thread pool
- `map` and `flatMap` chain futures together in a linear sequence, each async runs when the previous one finishes
- `Future.sequence()` takes a `List[Future]` and produces a `Future[List]`
    - all run in parralel, if any one of the futures fails then the output future fails
### MUTEX
- mutex on variables: `synchronize { 1 + 1 }`

### PATTERN MATCHING
- matching must be exhaustive
- `case entries @ _ :: _ :: (_: List[_]) => {`
    - more than one record
- can pattern match in field names, this will print `a or dude`
    ```
    (1,"dude") match { 
        case (2, "z") | (3,"n") => print("1st case")
        case (1, "a" | "dude") => print("a or dude")
        case (_, _) => print("catch all")
    }
    ```

### DATE/TIME
- `System.nanoTime` - get JVMs nano time count
- `System.currentTimeMillis` - get JVMs millisecond time count
- TIME/DATE: use java times and date, it is now better than jodatime
- joda time parsing and conversion:
    - https://stackoverflow.com/questions/20331163/how-to-format-joda-time-datetime-to-only-mm-dd-yyyy/20331243

## IO
### FILE
- run command and redirect to file
    ```scala
    import sys.process._
    import java.io.File
    ("ls -al" #> new File("files.txt")).!
    ```
### FILE READ
- import scala.io.Source; Source.fromFile("/tmp/httpie_tmp_output2").getLines.toList   // list of lines
- import scala.io.Source; Source.fromFile("/tmp/httpie_tmp_output2").getLines.mkString // file as one big string
    - should close file too: val a = Source.fromFile("example.txt"), a.close
### ENVIRONMENT VARS
- using java `System`: 
    - `System.getenv()` -> return `Map[String,String]` of env-var/value
    - `System.getenv("SHELL")` -> get value of a var, will be `null` if var doesnt exist
- using `scala.util.Properties`
    - `scala.util.Properties.envOrElse("PWD", "undefined")` -> get value of var `PWD` or default to value `undefined`
    - `scala.util.Properties.envOrNone("PWD")` -> return `Option` instead, `None` if env var doesnt exist

## ENUMERATION
- play 2.5 json doesnt supports scala enumerators
- can use enumeratum

## IMPLICITS
- coder doesnt need to explicilty pass in an arg/type that is implicit, the compiler will find it within scope
- scala 3 overhauled implicits

## BUILD TOOLS
- sbt, see [sbt](build_dependency_tools_cheatsheet.md#sbt)
- mill, see [build tools](build_dependency_tools_cheatsheet.md#mill)

## MACWIRE/DEPENDENCY-INJECT
- macwire are basically macros, except written in scala, versus c++ macros which are a syntax of their own
- macwire happens pre-compile, guice i think happens runtime
    - desired qualities:
    > 1. Late binding, e.g. At the last moment, I can override ANY component in the graph WITHOUT refactoring my wirings. (Yes: Guice, cake, registry. No: macwire modules)
    > 2. Nearly as fast as `new` (Yes: macwire modules, cake. No: Guice)
    > 3. Multibinding (Yes: Guice, macwire modules sorta. No: cake)
    > Also other things, but those are the big ones that differ in those approaches. (edited)
- `@module` annotation above class declarations make classes vals' available in scope


## AUTOMATION TESTING
- https://www.scalatest.org/user_guide/using_scalatest_with_sbt
- org.mockito.ArgumentCaptor, can capture arguments, can we used in "when" mocks or "verify" method calls
- private method testing, supported by ScalaTest
    ```scala
    import org.scalatest.PrivateMethodTester._
    val someMethodRef = PrivateMethod[SomeReturnType]('nameOfPrivateMethodToAccess')
    val result = someObjectToTest invokePrivate someMethodRef(arg1, arg2)
    ```
- PlaySpecification/spec2, to skip test
    - `skipped("some reason")`
    - `append .pendingUntilFixed("message about the issue")`
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
- supports async
    - Play WS(webservice) - client HTTP lib, a wrapper that uses diff backend like Netty and AsyncHttpClient
- docs: https://www.playframework.com/documentation
- precompile routes file is converted to scala code, then it's compiled and macwire can dep inj there
- 2.8
    - supports java 11

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


## SCRIPTING
- create a runnable program
    ```scala
    // scala 3 - create Hello.scala with `@main` annotation
    @main def hello = println("Hello, world")

    // scala 2 - implement App trait to make class executable
    class Scala2Program extends App {
        println("hello world")

        // for cli args
        println(args(0))    // 1st val in args array is name of exe source file
        println(args(1))    // 1st arg starts at 2nd index of args array
    }

    // works for scala 2 and 3
    object Scala2Scala3 {
      def main(args: Array[String]): Unit = {
        println("works in scala 2 and 3")
      }
    }
    ```
- then can run script like so `scala Hello.scala arg1`
- exit a program: `System.exit(1)` - exit with code 1


## AMMONITE
- https://ammonite.io/
- block input:
    @ { <enter>
        x + y...
        z + f
    } <enter>
- imports
    ```scala
    @ import $ivy.`com.lihaoyi::upickle:3.1.3` // import scala ivy dep (use `::`)
    @ import $ivy.`com.google.guava:guava:18.0`  // import java ivy dep, (use `:`)
    ```
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

## OTHER MAJOR LIBS/FRAMEWORKS
- [http4s](https://http4s.org/) - minimal highly FP web framework
    - compiles to Scala.js and Scala Native, uses fs2
- fs2 - streaming library
- cats: https://typelevel.org/cats/datatypes/ior.html
    - lots of useful FP types
- catseffect: https://typelevel.org/cats-effect/docs/2.x/datatypes/io
    - `IO` type and "non-effecting" types
- fs2 - streaming and concurrency, build on cats-effects and cats
- great http lib (inspired by python requests) - https://github.com/com-lihaoyi/requests-scala
- upickle - https://com-lihaoyi.github.io/upickle/
     - parse json text - `val s:String = """{"a":1}"""; ujson.read(s)`
### AKKA
- one of akka streams main goals is to implement backpressure
### SLICK
- print sql statement: https://stackoverflow.com/questions/23434286/view-sql-query-in-slick

### RANDOM
- sleep for 1 second: `Thread.sleep(1000)`
