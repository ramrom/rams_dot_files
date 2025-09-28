# KOTLIN
- official home - https://kotlinlang.org/
- https://learnxinyminutes.com/kotlin/

## FEATURES
- `sealed` keyword - inheritance of sealed classes and interfaces must be known at compile time, so in same package/module
- `interface` keyword - similar to java interface
    - cannot be instaniated directly, cannot contain state, can write default method implementations
- `?` after a type means variable can contain a null
- `data class` - primarily to hold data, very similar to scala `case class`

## SYNTAX
- `it` - syntax sugar special variable for lambda expressions with a single parameter
    ```kotlin
    val list = listOf("a", "b", "c")
    list.forEach { println(it) } // prints a, b, c
    list.forEach { item -> println(item) } // same as above
    ```

## COLLECTIONS
```kotlin
///////// MAPS
val m = mapOf("a" to 1, "b" to 2) // immutable map
val m2 = mutableMapOf("a" to 1, "b" to 2) // mutable map

m.keys // returns [a, b]
m.values // returns [1, 2]
m.forEach { k, v -> println("$k -> $v") } // prints a -> 1, b -> 2
m.map { (k, v) -> "$k -> $v" } // returns [a -> 1, b -> 2]
m.mapValues { (k, v) -> v * 2 } // returns {a=2, b=4}
m.filter { (k, v) -> v % 2 == 0 } // returns {b=2}
m.filterNot { (k, v) -> v % 2 == 0 } //
m.filterKeys { k -> k == "a" } // returns {a=1}
m.filterValues { v -> v % 2 == 0 } // returns {b=
m.flatMap { (k, v) -> listOf(k, v) } // returns [a, 1, b, 2]
m.flatMapValues { (k, v) -> listOf(v, v * 2) } // returns {a=[1, 2], b=[2, 4]}
m.entries // returns [a=1, b=2]

///////// LISTS
val l = listOf(1, 2, 3) // immutable list
val l2 = mutableListOf(1, 2, 3) // mutable list

l.forEach { println(it) } // prints 1, 2, 3
l.map { it * 2 } // returns [2, 4, 6]
l.filter { it % 2 == 0 } // returns [2]
l.filterNot { it % 2 == 0 } // returns [1, 3]
j.filterIndexed { index, value -> index % 2 == 0 } // returns [1, 3]
l.reduce { acc, i -> acc + i } // returns 6
l.sortedBy { -it } // returns [3, 2, 1]
l.groupBy { it % 2 } // returns {0=[2], 1=[
l.groupingBy { it % 2 }.eachCount() // returns {0=1, 1=2}
l.flatMap { listOf(it, it * 2) } // returns [1, 2, 2, 4, 3, 6]
// test predicates
l.any { it % 2 == 0 } // returns true
l.all { it > 0 } // returns true
l.none { it < 0 } // returns true

/////// SETS
val s = setOf(1, 2, 3) // immutable set
val s2 = mutableSetOf(1, 2, 3) // mutable set
s.forEach { println(it) } // prints 1, 2, 3

///// ARRAY DEQUE
val a = ArrayDeque(listOf(1, 2, 3)) // mutable array deque
a.addFirst(0) // adds 0 to the front
a.addLast(4) // adds 4 to the end
a.removeFirst() // removes and returns 0
a.removeLast() // removes and returns 4
```

## RUNNING
```sh
# create a kotlin file with main function
fun main() { println("Hello, World!") }

# compile and include runtime in jar
kotlinc hello.kt -include-runtime -d hello.jar

#run jar
java -jar hello.jar
```

## LIBRARIES
- [ktor](https://ktor.io/) - asynchronous framework for creating microservices, web applications, and more
    - built by jetbrains, fully kotlin, built on kotlin coroutines
