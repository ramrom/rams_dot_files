# JAVA
- https://learnxinyminutes.com/docs/java/
- `jshell` start REPL env in terminal
- java is by comp sci def pass-by-value: https://stackoverflow.com/questions/40480/is-java-pass-by-reference-or-pass-by-value
    - for objects, variables store values that are references to objects
        - so reassigned a variable passed into a function with new value, will not change the variable assignment in caller

## JAVA RUNTIME
`/usr/libexec/java_home -V`
    - see all jvm version installed
- set JAVA_HOME env var to a specific jvm
    ```sh
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.6.0_65-b14-462)
    ```
- identical paths and names in two jars, e.g. com.bar.Foo class defined in jar1 and jar2
    - class finding is generally done by `java.lang.ClassLoader.findClass`
        - generally every frameworks implementes their own strategy
        - default jvm loader is: `sun.misc.URLClassPath#getLookupCacheForClassLoader`
    - most peeps say the first jar in the classpath will get loaded
    - https://stackoverflow.com/questions/19339670/java-two-jars-in-project-with-same-class/19340327
    - https://www.geeksforgeeks.org/classloader-in-java/
### JVM FLAGS
- `XMX` - max memory heap size program can occupy
- `XMS` - size of initial heap memory when program starts
- `XSS` - stack size of each thread

## BUILD TOOLS
- uses ant, maven, gradle
- see [build systems](build_dependency_tools_cheatsheet.md)

## EXAMPLES
### DATA STRUCTURES
```java
int[] intArray = new int[10];
String[] stringArray = new String[1];

int[] y = {9000, 1000, 1337};
String names[] = {"Bob", "John", "Fred", "Juan Pedro"};
names[2] // returns 1337
names[1] = "newval"
names.length // => 4, the num items in the array

ArrayList<String> mylist = new ArrayList<String>();
mylist.add("hi");
mylist.add(0, "new");  // add "new" string at index 0, so mylist ==> { "new", "hi" }
mylist.get(1)  // ==> "hi", get value at index 1
mylist.remove(1);  // mylist ==> { "new" }
mylist.set(0, "dude");  // mylist ==> { "dude" }

// variables can be of interface types, and thus contain any value that implements that type
List<String> mylist = new ArrayList<String>();

// caveat: since List is backed by array, we can't change the size, cant add elements to it
List<String> mylist = Arrays.asList("a", "b", "c"); // a short way to declare a new List

LinkedList<String> ll = new LinkedList<String>();  // linked lists

// Set interface
HashSet<String> hs = new HashSet<String>();  // set, elements must be unique
hs.add("a"); hs.add("b");  // will return true
hs.add("a")  // returns false, "a" already in set

// implementation of Map interface
HashMap<String, Integer> m = new HashMap<String, Integer>(); // impl of Map, hashtable at core, constant time lookup and insert
TreeMap<String, Integer> m = new TreeMap<String, Integer>(); // keys in tree struct, sorted
```
### STRINGS
```java
    "  trim a str  ".trim()   // returns "trim a str"
    "uPPer Case".toUpperCase()   // returns "UPPER CASE"
    "uPPer Case".toLowerCase()   // returns "upper case"

    "hello world".split(" ")   // return type String[], { "hello", "world" }

    "hello world".charAt(2)    // index string, reuturns "l"
    "get a substring".substring(2,7)  // returns "t a s", from begIndex to (endIndex - 1)

    "hi there".contains("hi") // returns true
    "hi there".isBlank() // returns false

    " ".isBlank() // returns true, Blank tests for non-whitespace
    " ".isEmpty() // returns false
    "".isEmpty() // returns true, Empty tests for zero length string
```
### CONVERSIONS
```java
   int a = Integer.parseInt("3");    // String -> int
   int a = Integer.parseInt("foo");  // will raise NumberFormatException 

   float f = Float.parseFloat("25.1");    // String -> Float
   String s = Float.toString(25.0f);      // Float -> String

   int a = Integer.toString(3);     // int -> String

   int a = (int)1.6         // cast float to int, a rounded down to 1
   int b = (Double)1.6f     // FAILS, doubles and floats cant be converted b/w each other
```
### MATH
```java
    Math.max(1,2)   // returns 2
    Math.min(1,2)   // returns 1
    Math.abs(-1)   // returns 1
    Math.abs(-1.1)   // returns 1.1
    Math.max(1.1f, 2)   // can mix floats with ints, returns 2

    Math.random()   // return num between 0.0(inclusive) to 1.0(exclusive)
    int randomNum = (int)(Math.random() * 101);  // 0 to 100
```

## GC/ALLOCATION
- generally all variables store on the heap
    - primitives (ints, bools, etc) will go on the stack
    - fixed sized plain arrays also go on the heap
    - basically all objects go on the heap

## TYPE SYSTEM
- `final` keyword means it can't be changed (synonymous to `val` in scala)
### CLASSES
- static and member variables not initialized have a `null` value
- `Object` is root of the class heirarchy, all objects are a decendent of `Object`
### INTERFACE
- cannot implement any methods
- a class can implement many interfaces, multiple inheritence
- can not have non-final and non-static variables
### ABSTRACT CLASS
- can implement methods
- no multiple inheritence
- can have final and non-final variables, static and non-static variables
### RECORD
- immutable
- data struct that has a setter/getter, constructor, `equals` method, `hashCode` method, `toString` method

## INTROSPECTION
- `(object) instanceof (type)` - test if object is instance of type, or subtype of type, or implements an interface
    - e.g. if `Dog` is subclass of `Animal`; `Dog foo = new Dog(); assertTrue(foo instanceof Animal)`
```java
    Class c = Class.forName("java.lang.String")
    boolean b = c.isInstance("hi")  // true
    boolean b = c.isInstance(3)     // false
```

### IO
```java
Scanner scanner = new Scanner(System.in);
String name = scanner.next();  // read string input
byte numByte = scanner.nextByte();


System.out.println("hi")
```

### OPERATORS
```java
System.out.println("11%3 = "+(11 % 3)); // => 2 , modulo

System.out.println("3 > 2 || 2 > 3? " + ((3 > 2) || (2 > 3))); // => true
```

### CONTROL STRUCTURES
```java
for (int i = 0; i < 10; i++) {
    System.out.println(i);
}

int a = 3
switch (a) {
            case 1: System.out.println("it's 1")
                    break;
            case 3: System.out.println("it's 3")
                    break;
            default: System.out.println("something else")
                     break;
        }

//trinary
String bar = (3 < 10) ? "A" : "B";
```
- java 14 has switch expressions (vs the switch statement above)
    - no break statement, can have a default case, can combine constants, has blocked scope(using curly braces)
    - dont have to be exhaustive

## MAJOR LIBS/FRAMEWORKS
### NETTY
- async non-blocking event-driven network-centric framework, does HTTP and other protocols
    - uses the reactor pattern
    - uses java NIO channels - non-blocking IO
### NIO
- new input/output - collection of java APIs for heavy IO ops
### REACTIVE STREAMS
- really a standard for async stream processing, also supports non-blocking backpressure
- akka streams, spring framework v5, play framework, kafka, cassandra, elasticsearch all use it

## HISTORY
- java5(1.5), sept2004 - generics, annotations, enumerations(`enum`),
- java8, mar2014, LTS(till 2025) - lamba functions
- java11, sept2018, LTS - TLS, http client, epsilon garbage collector
- java14
    - introduced `record`, aka scala case class
- java16, mar2021 - remove ahead-of-time compilation, Graal JIT, source moved to github from mercurial
- java17, sept2021, LTS - better pattern matching
