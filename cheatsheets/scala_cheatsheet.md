# SCALA
- first compiler was written in Pizza by Martin Odersky, by scala 2.0, compiler rewritten completely in scala
- defined by the scala language specification
    - main compiler for JVM
    - Scala.js is a compiler targeted for javascript (node.js or web)
    - Scala Native uses LLVM to make native binaries
- lightbend(formerly typesafe) founded by odersky, jonas boner(created akka), and paul phillips
- major entities using scala: 
    - twitter - used where ruby/rails is slow/poor
    - netflix - search algos, RESET apis and reccomendations
    - airbnb - used fast data processing, in data pipelines
    - others: foursquare, databricks, netflix, tumblr, disney streaming, tubi

## DOCS
- main docs: https://www.scala-lang.org/
    - source code repo: https://github.com/scala/docs.scala-lang.git
- barebone cheatsheet - https://docs.scala-lang.org/cheatsheets/index.html
- tour of scala: https://docs.scala-lang.org/tour/tour-of-scala.html
- good web playground: https://scastie.scala-lang.org/
- haoyi's 2020 blog on scala's future - https://www.lihaoyi.com/post/TheDeathofHypeWhatsNextforScala.html

## BUILD TOOLS
- main is sbt, but also mill and bloop
- sbt, see [sbt](build_dependency_tools_cheatsheet.md#sbt)
- mill, see [build tools](build_dependency_tools_cheatsheet.md#mill)
- modern systems use coursier for artifact fetching
- scala metals - main robust LSP for scala (see build system above)
    - see [LSP in build systems](build_dependency_tools_cheatsheet.md#LSP)


## JAVA COMPATIBILITY
- master list: https://docs.scala-lang.org/overviews/jdk-compatibility/overview.html
- some good notes: https://docs.scala-lang.org/scala3/book/interacting-with-java.html
    - possible to use scala traits in java and java interfaces in scala
    - can convert java collections to scala and vice versa with coverters
    - can convert java Optional to scala Option
    - scala can subclass java classes and vice versa
- tail recursion call
    - tail recursion can be changed to a loop and that’s what Scala compiler does. 
    - tail calls in general require stack frame replacement support from the underlying platform, but Java doesn’t provide that
    - IntelliJ has a nice feature which can show which funcs it thinks are tail recursive

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
- `lazy` - keyword that makes evaluation lazy, so only on first access, not delaration
    ```scala
    lazy val later = { println("hi"); 3 }
    // ...
    later   // prints "hi" and assigns 3 to later
    lazy val now = { println("hi"); 3 }  // prints "hi" and assigns 3 to now
    ```
- `def` - keyword to define a function
- Trait - cant be instantiated directly
    - a class can implement MANY traits
    - can NOT specify a constructor parameter
- Abstract class - cant be instantiated
    - class can implement only ONE abstract class
    - can specify a constructor parameter
- typeclass - not a formal semantic feature in scala
    - nice typeclass definition: https://scalac.io/typeclasses-in-scala/
    - decent blog: https://danielwestheide.com/blog/the-neophytes-guide-to-scala-part-12-type-classes/
    - be able to define a trait contract for some types without modifying those types directly
    - essentially ad-hoc polymorphism, inspired from haskell type classes, and very similar to golang interfaces
    - generally implemented with generic traits and implicits
    - nice 30min vid - https://www.youtube.com/watch?v=VDSWjHgM5HA&list=WL
        - scala typelcasses are concise. are compile-time (F#/java/kotlin all runtime reflection)
        - major examples: `scala.CanEqual[A,B]`, `scala.math.Ordering[A]`, `cats.Show[A]`, `io.circe.Codec[A]`
- integer types - `Short` (16bit), `Int` (32bit?), `Long` (64bit?)
    - `Long` instantiation - `1000000000000000000L` or `100000: Long`
- `Any` - root type in scala class heirarchy - https://www.scala-lang.org/api/current/scala/Any.html
    - all objects implement this, `Nothing` - opposite of `Any`, no object implements this
- generics are a compile time check, and suffer from type erasure during runtime on the JVM
    ```scala
    val l1 = List(1, 2, 3)
    assert(l1.isInstanceOf[List[Int]], "l1 is a List[Int]")        // returns true, expected
    assert(l1.isInstanceOf[List[String]], "l1 is a List[String]")  // returns true!

    val seq : Seq[Int] = Seq(1,2,3) // compiler validates generics at compile time
    val seq : Seq = Seq(1,2,3)   // this is what JVM runtime actually has, generic type info is erased
    ```
- VARIANCE - tells us if type constructor is subtype of another type constructor
    - https://docs.scala-lang.org/tour/variances.html
    - 3 main variances: invariance, covariance, and contravariance
    - covariant: given B is subtype of A, then `F[[_]]` is covariant if `F[B]` is subtype of `F[A]`, denoted by `F[+T]`
    - contravariant: inverse of covariant, given B subtype of A, `F[A]` is subtype of `F[B]`, denoted by `F[-T]`
    - invariant: no gaurantee of subtyping relationship between `F[A]` and `F[B]`
### CONTROL STRUCTURES
- `if` statements are expressions, not statements
    - `val a = if (somebool) 1 else 2`  - u can basically to ternary operators like this
### HIGHER KINDED TYPES
- A higher-kinded type is a type that abstracts over some type that, in turn, abstracts over another type
- introduced in scala 2.5, example usage is in scala std lib
- examples:
    ```scala
    // a "interface", could be used for many "container" types like List, Array, Option
    // good fast read; https://www.baeldung.com/scala/higher-kinded-types
    trait Collection[T[_]] {
      def wrap[A](a: A): T[A]
      def first[B](b: T[B]): B
    }

    trait Collection[T[F]] { ... } // F here is same as _ , _ more common syntax b/c it's more clear

    // monad could be defined like
    trait Monad[M[_]] {
      def unit[A](value: A): M[A]
      def flatMap[A,B](instance: M[A])(func: A => M[B]): M[B]
    }
    ```
- monad transformer
    - generally refers to alterning a nested monad type
    - two of the most popular transformers are cats' `EitherT` and `OptionT`
        - e.g. `IO[Option[A]]` -> `OptionT[A]`
### ADT
- sum types - usually implemented with inheritence and case classes
    - `Either[A,B]`(2.13) is sealed abstract class, 2 subtypes, both case classes `Left` and `Right`
    - similar for `Option[A]`
- product types - usually a case class, but also regular class
### CLASSES
- multiple inheritence, diamond problem -> scala serializes the tree
    - order matters, so last trait that implements same method will get defined
- can specify extra constructors using methods named `this`
    - each `this` must have diff signature, and must internally call another constructor
### IMPLICITS
- coder doesnt need to explicilty pass in an arg/type that is implicit, the compiler will find it within scope
- scala 3 overhauled implicits
- good doc on scala implicits: https://docs.scala-lang.org/tutorials/FAQ/finding-implicits.html
- implicit conversion: automatically convert a type to another type if a implicit converter func exists in scope
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
- essentially a singleton, only one instance
    - `class Foo(i: Int) { ... }; object Foo { ... }`
- companion class and companion object can access each others private members
- `apply` - can call companion object w/o specifying `apply`
    - e.g. `val a = Foo("dude")` compiles to `val a = Foo.apply("dude")`
    - main use it to use method to instantiate companion class without `new` keyword
    - function overload `apply` for many constructors
- CASE OBJECT - like companion object but is serializable, has hashCode method, has toString method
### CASE CLASS
- similar to Java's Record types
- e.g. `case class Foo(i: Int, s: String)`
- constructor params are `val`s by default
- get a default `apply` and `unapply` automatically defined
    - `apply` method calls the default constructor
    - pattern matching needs `unapply` defined if you want to match on fields
- `toString`, `equal`, and `hashcode` methods auto-implemented and overridden
    - `equal` will test if content of two objects are the same, not identity
    ```scala
    case class Foo(i: Int); f = Foo(1); f2 = Foo(1); f == f2  // return true
    class Bar(i: Int); b = Bar(1); b2 = Bar(1); b == b2  // returns false
    ```
- `copy` method - guarantees shallow copies only
- `Product` trait autoimplemented, get `productArity`, `productElement`, `productIterator`
    - case classes can't have more than 22 parameters b/c it implements this trait
- `tupled` method - `case class Foo(i: Int, b: String); (Foo.apply _).tupled((3, "hi"))`  - creates `Foo` object from tuple
- *CANNOT* inherit from another case class
- implements `Serializable` trait
### FUNCTIONS
- PARTIAL APPLICATION - can pass subset of arguments to function invocation, then pass rest in later
    - e.g. `def foo(x: Int, y: Int): Int = { x + y}; foo(3, _)` -> this return a `Int => Int` function
- VARIADIC (repeated) arguments, postfix `*` identifier
    - e.g. `def foo(a: String*) = { for( arg <- args ){ println("Arg: " + arg) }}; foo("hi","there"); foo("onearg")`
        - arg `a` here is treated as an array
    - if we want to pass in `List` type, need to use splat operator to convert it
        - e.g. `val mylist = List("a","b"); foo(mylist:_*)`
    - this is similar to varargs feature in Java
- CALL-BY-NAME parameters are evaluated only when val is used in func body, e.g. func sig: `foo(i: => Boolean)`
### IMPLICITS
- implicit args must be in seperate curry and at end
```scala
case class Foo()
implicit val f: Foo = Foo()
def func(msg: String)(implicit f: Foo) = msg + f.toString
func("hi")      // return `hiFoo()`
```
### ANONYMOUS FUNCTIONS
```scala
// `a` here is actually a object with an `apply` function defined
// really defined Function[Int, Int] class
val a = (x: Int) => x * 2
a(3)        // returns 6
a.apply(3)  // returns 6

val a = (x: Int, y: (i: Int) => 10 * i) => y(x)    // anon function with a argument taking an anon function
a(3)    // returns 30
```
### INTROSPECTION
```scala
val a: Any = "hi"
a.isInstanceOf[String]  // returns true
a.isInstanceOf[Int]     // returns false
```


## PATTERN MATCHING
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

## FOR COMPREHENSIONS
- syntax sugar for nesting `flatMap` and `withFilter`
- good martin example on for comprehensions: https://www.artima.com/pins1ed/for-expressions-revisited.html
    - general form: `for ( seq ) yield expr`, where `seq` can be a generator, definition, or filter
- generator: `for (i <- 1 until 3) yield i` -> returns `Vector(1,2,3)`
### REGULAR LOOPS
- `for (i <- 1 until 3) println(i)`  - no `yield` makes this like a regular for loop
    - `for (i <- 1 until 3) yield println(i)`  - with `yield` this returns a `List((),(),())`
- `for (i <- List(1,2,3)) println(i)`

## DATA STRUCTURES
- scala 2.13 collections: https://docs.scala-lang.org/overviews/collections-2.13/overview.html
### TUPLES
- `val t = ("a","b","c")`
- access fields: `t._1` (returns `a`), `t._4` (errors, field 4 doesnt exist)
### LIST/ARRAY
- IMMUTABLE
    - `List` is immutable, underlying is linked-list, so indexing is slow
    - `Vector` is immutable, indexing is fast
- MUTABLE
    - `scala.collection.mutable.ArrayBuffer` -> underlying data struct is array, can be resized
    - `Array` - is mutable like `ArrayBuffer`, NOT resizable
        - generally backed by JVM basic array, more efficient than `ArrayBuffer`
    - `ListBuffer` -> underlying data struct is linked list
        - to append: `l.append(1)` or `l += 1`
    - `scala.collection.mutable.Set` - mutable Set
    - `scala.collection.mutable.Map` - mutable Map
        `m.addOne(3->4)` - add an item
        `m.remove(4)` - remove a key, returns `None` if key didnt exist, `Some(value)` the value if it did exist
    - also has `PriorityQueue` and others
- MULTIDIMENSIONAL
    - `val v = Array.ofDim(2,2)[Int]; v(0) = Array(1,1); v(0)(1)`
    - `val v = collection.mutable.ArrayBuffer.fill(3,3)(1)`
- METHODS
    - `head` - return first element
    - `last` - return last element
    - `tail` - return same list minus first element
    - `take` will return new list with first n items, e.g. `List(1,2,3).take(2)` -> `List(1,2)`
    - `drop` will return new list, removing first n items, .e.g. `List(1,2,3).drop(1)` -> `List(2,3)`
    - `slice` - grab a subrange of items in list (works on `String` too)
        - `List(1,2,3,4).slice(3,4)` -> returns `List(4)`
        - `"hi there".slice(2,5)` -> returns `" th"`
- `zipWithIndex` -> return list of tuple with 2nd field as index value
    `List(5,3,2).zipWithIndex` -> returns `List((5,0),(3,1),(2,2))` 
- `foreach` over a List of tuple
    - `List((1,2),(3,5)).foreach { (v: (Int, Int)) => println(s"v._1 and v._2") }`
        - slightly confusing syntax, need one arg and specify it's a tuple
    - `List(3,4,5).zipWithIndex.foreach { case (a, b) => println(s"${a} and ${b}") }`
        - can use pattern match to unapply the tuple to name the fields
- `map`
    - can pass a code block with "global state", e.g. cumulative sum list:
        - `List(1,2,3,4).map { var c = 0; i => { c = c + i; c; } }` -> returns `List(1,3,6,10)`
- `scanLeft` , `scanRight`
    - cumulative sum: `List(1,2,3).scanLeft(0)(_ + _)` -> returns `List(0,1,3,6,10)`
- `fold` `val l = List(1,2,3); val sum = l.fold(0)((cum,value) => cum + value)`    -> `sum` will = 6
    - `fold` does NOT gaurantee order, could be a tree operation, can decompose into sublists, created to support parralelism
    - `foldLeft` iterates from leftmost element to right, `foldRight` iterates from rightmost element to left
        - cumulative sum e.g.: `List(1,2,3,4).foldLeft(List[Int](0))( (cum, i) => cum :+ (i + cum.last)).drop(1)` -> `List(1,3,6,10)`
- String conversion
    ```scala
    List(1,2).toString                 //  returns "Seq(1, 2)"
    List(1,2).mkString("/")            // returns "1/2"
    List(1,2).mkString("[", ",", "]")  // returns "[1,2]"
    ```
- remove a item
    - `List(11, 12, 13, 14, 15).patch(2, Nil, 1)`
        - from index 2, remove 1 element with Nil (only Nil works)
    - `List(11,12,13,14,15).zipWithIndex.filter(_._2 != 2).map(_._1)`
        - will remove index 2
    - `val trunced = internalIdList.take(index) ++ internalIdList.drop(index + 1)`
- `search` - binary search on a `IndexedSeq`, list must be sorted and `search` takes an `Ordering`
    - binary search if list is `IndexedSeq`, otherwise linear search
    - `List(1,10,15).search(10)` -> returns `Found(foundIndex = 1)`
    - `List(1,10,15).search(11)` -> returns `InsertionPoint(insertionPoint = 2)`
- `find` - `List(1,2,3).find(_ % 2 == 0)`   -> returns `Some(2)`, `None` returned if no match found
- `groupBy` - `List(1,2,3).groupBy( v => v % 2)` - returns `HashMap(0 -> List(2), 1 -> List(1, 3))`
- `maxBy[B](f: A => B)(implicit ord: Ordering[B])` - return element that has maximum `B`, where `B` must be ordered
    - e.g. get mode of list of duplicate items:
        `List("a","b","a","c","a","c").groupBy(v => v).map( (k,v) => (k, v.size)).maxBy( (k,v) => v)` -> returns `("a",3)`
- OPERATORS
    - `++` concat 2 collections
    - `::`, `+:` prepend to list
        - `1 :: List(3)` -> returns `List(1,3)`
    - `:+` append
        - `val l = List(1); 4 +: l :+ 3`  returns new list `List(4,1,3)`
### MAP/ASSOCIATIVE-ARRAY
- https://docs.scala-lang.org/overviews/collections-2.13/maps.html
```scala
val m: Map[String, Int] = Map.empty
val m = Map("a"->1, "b"->2)
m + ("foo" -> 3)        // returns a NEW map which also contains ("foo"-> 1)
m += (2->3)             // will raise exception, cant mutate, use mutable Map
m.keys                  // returns a Set containing keys
m.values                  // returns a Iterable containing values
m.getOrElse("z",10)     // since "z" key doesnt exist, the default 10 is returned

val mu = scala.collection.mutable.Map(1->2)   // mutable map (will be HashMap)
mu + (2->3)   // like immutable man, returns a NEW map which also contains (2->3)
mu += (2->3)    // append (2->3) to mu
mu -= 2    // remove key/val with key=2 from mu

Map(1->2,3->4) ++ Map(1->1,5->4)  // returns Map(1->1,3->4,5->4)

Map(1->2, 2->3).map( (k,v) => (k, v*2))  // return Map(1->4, 2->6)
```
### STACK
```scala
import scala.collection.mutable.Stack

val s = Stack[Int]()
s.push(1)
s.pop()     // return 1
s.pop()     // raises NoSuchElementException when empty
s.push(4,5) // can push many items in one call
s.length      // num of elements in stack
s.clear()   // delete all elements in stack
s.head      // peek the top element on the stack
```
### SET
- TYPES
    - `scala.collection.immutable.HashSet`
    - `scala.collection.immutable.TreeSet`
```scala
val set = Set("a","b","a")      // return Set("a", "b")

// can remove/add items with `-`/`+` : ``
set - "a"   // returns Set("b")
set + "z"   // returns Set("a", "z")

Set(1,2) ++ Set(2,4)  // add two sets, here you get Set(1,2,4)
Set(1,2) -- Set(2,4)  // subtract a set, here you get Set(1)

Set(1,2) & Set(2,4,5) // returns intersection of sets, so Set(2)
```
### RANGE
```scala
val r = Range.inclusive(1,10)   // includes 10
val r2 = Range(1,10)   // wont include 10
r.toList        // convert to List

val rangeTo = 1 to 10           // includes 10
val rangeUntil = 1 until 10     // exlcudes 10
val oddRange = 1 to 100 by 2

Range(1,10000).foreach { i => i * i }  // supports iterator
```
### ITERATOR
```scala
val l = List(1,2)
val i = l.iterator      // will return type Iterator[Int]
i.hasNext       // true
i.next       // return 1
i.next       // return 2
i.next       // throw NoSuchElementException
```
### STREAMS
- like collection but lazily evaluated so can be optimized when chaining them together
- regular collections that u might chain with things like `map` and `filter` will eagerly create intermediate data structures
- deprecated in 2.13.0 in favor of `LazyList`
- streams/LazyList allow us to represent infinite computations, e.g. a fibonacci sequence, sequence of all natural numbers
- `List(1,2,3,4).map(_ + 1).map(_*_).filter(_ > 10)` -> will have 2 more intermediate collections/allocations
- `Stream(1,2,3,4).map(_ + 1).map(_*_).filter(_ > 10).toList`
    - `Stream` is like an iterator, it's lazy until something consumes it, `toList` here
    - could pass this into a for e.g. `for ( elem <- Stream(1,2,3) ) println( s"A value is ${elem}" )`
### LAZYLIST
- lazy evaluation, only evaluated until something like `toList` is called
- `LazyList(1,2,3).map(_+3).filter(_%2==0).toList`    -> returns `List(4,6)`

## STRINGS
- toString method is called if fooObject isnt a String
- index returns a `Char` - `val s = "hello"; s(1);` returns `e`
- `map` operates on each char in string, `"hi".map(_+"a")` -> returns `ArraySeq("ha", "ia")`
- string interpolation: `val i = 3; String s = s"i is $i"`
- multi-line string with `"""` - e.g. `val s: String = """ i can add literal " double quote """`
- escape with `\` - `val s: String = "escaped with \" \\ new line \n woo"`
- findandreplace: ` "foo bar baz".replaceAll("ba","zz")` -> outputs `"foo zzr zzz"`
- `StringBuilder` commonly used for building strings
    - `val b = new StringBuilder; b += "hi"; b += " there"; b.toString`
- get substring(aka slice): `val s = "hello there"; s.substring(2,4)` - returns `String` `ll`
- prints `this is Foo(3)`
    ```scala
    case Class Foo(a: Int); foo = Foo(3); println(s"this is $foo")
    ```
### REGEX
```scala
val myregex = """\d\d..\d\d""".r    // returns type `Regex`
```

## MONADS
- they are monoids in the class of endofunctors, like duh!
- a type that supports `Unit` and `flatMap` (and often other like `map`)
- e.g. for `Option`
    - flatMap -> `def flatMap[B](f: A => Option[B]): Option[B]`
    - map -> `def map[B](f: A => B): Option[B]`
### Either
- `flatMap` and `map` are right-biased, mapping on left val returns same val
    - `Right(1).map { x => x + 1 }   # returns Right(2)`
    - `val a: Either[Int, Int] = Left(1); a..map { x => x + 1 }   # returns Left(1)`
- `cond` - nice if/else sugar, `Left` if `false`, `Right` if `true`
    - `Either.cond(1 == 2, "right", "left")` return `Left("left")`
- `getOrElse(arg)` - return Right value or the given arg if it's a Left value
    - `Right(12).getOrElse(17)` -> returns 12
    - `Left(12).getOrElse(17)`  -> returns 17
- `left` - left projection, Either becomes left-biased instead of right-biased
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

## RANDOM
- sleep for 1 second: `java.lang.Thread.sleep(1000)`
- get system properties `scala.sys.props` - e.g. os name, java home, java version, java class path

## CONCURRENCY
- `scala.sys.allThreads` - method to return list of a active threads in current thread's group
### FUTURES
- is a monad
- is *eager*, starts running moment it's declared
- async with execution contexts: `scala.concurrent.Future { 1 + 1 }`
    - `import scala.concurrent.ExecutionContext.Implicits.global`
    - `val r = scala.concurrent.Await.result(Future{1}, 10.seconds)` - blocking call to wait for future, after 10sec throw timeout error
        - for `Future[T]` the result `r` here is `Try[T]`
    - `scala.concurrent.Await.ready(Future{1}, 0.nanos)` - make blocking call immediately on a future, dont care about result
- an execution context is a abstraction that include a thread pool
- `map` and `flatMap` chain futures together in a linear sequence, each async runs when the previous one finishes
- `Future.sequence()` takes a `List[Future[T]]` and produces a `Future[List[T]]`
    - all run in parralel, if any one of the futures fails then the output future fails
    - e.g. `Future.sequence(List(Future { 1 }, Future { 2 }))` => `Future(Success(List(1,2)))`
### MUTEX
- mutex on variables: `synchronize { 1 + 1 }`

## DATE/TIME
- `System.nanoTime` - get JVMs nano time count
- `System.currentTimeMillis` - get JVMs millisecond time count
- TIME/DATE: use java times and date, it is now better than jodatime
- joda time parsing and conversion:
    - https://stackoverflow.com/questions/20331163/how-to-format-joda-time-datetime-to-only-mm-dd-yyyy/20331243

## MATH
- `scala.math.pow(2.1,3.4)` -> 2 to power of 3
- `scala.math.min(1,4)` -> returns 1
- `scala.math.max(1,4)` -> returns 4
- `scala.math.abs(-1)` -> returns 1
- mod: `10 % 3`  -> res: 1
- random numbers
    - `scala.util.Random.nextInt(100)` - generate random # b/w 0 and 99
    - `scala.util.Random.between(3,10)` - generate random # b/w 3 and 10
    - `scala.util.Random.nextFloat()` - generate a random float b/w 0.0 and 1.0

## I/O
### FILES
```scala
// run command and redirect to file
import sys.process._
import java.io.File
("ls -al" #> new File("files.txt")).!

import scala.io.Source; 
Source.fromFile("/tmp/httpie_tmp_output2").getLines.toList   // list of lines

Source.fromFile("/tmp/httpie_tmp_output2").getLines.mkString // file as one big string

// should close file too: 
val a = Source.fromFile("example.txt")
a.close

// FileWriter - important to close, closing ensures any remaining buffer is written to file
val fileWriter = new FileWriter(new File("/tmp/hello.txt"))
fileWriter.write("hello there")
fileWriter.close()

// PrintWriterm
val writer = new PrintWriter(new File("data.txt"))
val s = "big"
val numberOfLines = 3000000
writer.printf("This is a %s program with %d of code", s, new Integer(numberOfLines))
writer.close()
```
### ENVIRONMENT VARS
- `scala.sys.env` - returns immutable `Map[String,String]` of env vars
- `scala.util.Properties`
    - `scala.util.Properties.envOrElse("PWD", "undefined")` -> get value of var `PWD` or default to value `undefined`
    - `scala.util.Properties.envOrNone("PWD")` -> return `Option` instead, `None` if env var doesnt exist
- java `System`: 
    - `System.getenv()` -> return `Map[String,String]` of env-var/value
    - `System.getenv("SHELL")` -> get value of a var, will be `null` if var doesnt exist

## ENUMERATION
- play 2.5 json doesnt supports scala enumerators
- can use enumeratum

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

## CATS EFFECTS
- 2021 reddit, good comment of `IO` runtime - https://www.reddit.com/r/scala/comments/s23dve/cats_effect_how_it_works_technically/
```scala
import cats.effect._

IO.println("Hello") flatMap { _ => IO.println("World") }
// since it's flatMap we can use for comps with IO
for {
  _ <- IO.println("Hello")
  _ <- IO.println("World")
} yield ()
// can use `>>` when throwing away result of pref effect
IO.println("Hello") >> IO.println("World")

// macros that support async/await style programming
import cats.effect.cps._
async[IO] {
  IO.println("Hello").await
  IO.println("World").await
}
```

## SCALA CLI
- https://scala-cli.virtuslab.org/
- more for scripting and rapid prototyping
- not really a build tool, can easily specify scala version and jvm version

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
### ISSUES
- ammonite bug with loading same file in next session
    - https://github.com/com-lihaoyi/Ammonite/issues/959


## MAJOR LIBS/FRAMEWORKS
### PLAY FRAMEWORK
- docs: https://www.playframework.com/documentation
- has backend that uses Akka-HTTP to process requests, it converts to/from Akka `HttpRequest`/`HttpResponse` into plays models
    - AkkaHTTP handles nitty gritty of processing http requests, play add routing and application logic on top
    - can use Netty backend as well(play 2.9), play 3 uses Pekko
- generally async
    - Play WS(webservice) - client HTTP lib, a wrapper that uses diff backend like Netty and AsyncHttpClient
    - AkkaHTTP is non-blocking
- precompile routes file is converted to scala code, then it's compiled and macwire can dep inj there
- `Thread.sleep(1000)` will block thread, to delay in play we can invoke scheduler to delay scheduling future
    - play3 can schedule later: https://www.playframework.com/documentation/3.0.x/ScheduledTasks
    - see https://stackoverflow.com/questions/60425094/play-framework-how-to-purposely-delay-a-response
        - can use java's [ScheduledFuture](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ScheduledExecutorService.html)
- MAJOR VERSIONS
    - 2.8 - supports java 11
    - 2.9 -
    - 3.0 - released 2023, replaced Akka/Akka-HTTP with Pekko/Pekko-HTTP
        - 2.9 and 3.0 offer same features and get parralel maintinence, 3.0 just switches to Pekko
### CATS
- https://typelevel.org/cats/datatypes/ior.html
- lots of useful FP types
### CATS EFFECT
- https://typelevel.org/cats-effect/docs/2.x/datatypes/io
- built on top fo Cats library, provides async and other concurrency stuff
- `IO` type and "non-effecting" types
- fibers are fundamental concurrent abstraction, `IO` runtime has 150bytes/fiber
- supports async cancellations, fiber-aware work stealing, async tracing
### FS2 
- [FS2](https://fs2.io/#/) - streaming library, similar to Akka Streams
- doesn't conform to reactive streams philosophy, devs think it's complicated/unsafe/mutable
- streaming and concurrency, build on cats-effects
- basis for: http4s, skunk(postgres lib), doobie(JDBC replacement)
- a decent baeldung intro: https://www.baeldung.com/scala/fs2-functional-streams
### ZIO
- good vid(yr2020): https://www.youtube.com/watch?v=mGxcaQs3JWI&ab_channel=HimanshuYadav
- ZIO Effect - define computation, purely functional
    - vs Future: 100x faster, can cancel/timeout, has effect combinators
    - core type is `ZIO[R, E, A]` - R(env/resources needed) E(error) A(success)
        - common type aliases using this `Task` `UIO`(cant fail) `TaskR`(needs env) `IO`(returns E)
### AKKA
- one of akka streams main goals is to implement backpressure
- AKKA STREAMS - built on top of akka, adheres to [reactive streams](https://www.reactive-streams.org/) concept
- AKKA HTTP - uses AKKA STREAMS, http requests and responses modeled as streams
### PEKKO
- spawned by apache project from akka 2.6, written mostly in scala and some java
### SLICK
- print sql statement: https://stackoverflow.com/questions/23434286/view-sql-query-in-slick
### OTHER
- [sttp](https://github.com/softwaremill/sttp) - great HTTP client lib, really just an API layer for supporting many backends
- [scalameta](https://scalameta.org/) - used by scala metals, scalafix metadoc
- [http4s](https://http4s.org/) - minimal highly FP web framework
    - compiles to Scala.js and Scala Native, uses fs2
- [requests-scala](https://github.com/com-lihaoyi/requests-scala)
    - great http lib (inspired by python requests) 
- [upickle](https://com-lihaoyi.github.io/upickle)
     - parse json text - `val s:String = """{"a":1}"""; ujson.read(s)`
