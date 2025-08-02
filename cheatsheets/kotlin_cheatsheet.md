# KOTLIN
https://kotlinlang.org/

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
