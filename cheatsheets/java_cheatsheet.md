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
- jar types
    - skinny - only the app code you wrote
    - thin - app code you wrote plus app dependencies
    - hollow - inverse of thin, bits needed to run your app (i.e. the JRE)
    - fat - thin + hollow

## BUILD TOOLS
- uses ant, maven, gradle
- see [build systems](build_dependency_tools_cheatsheet.md)

## DATA STRUCTURES
```java
// regular arrays
int[] intArray = new int[10];
String[] stringArray = new String[1];

int[] y = {9000, 1000, 1337};
return new int[] { 1,2};            // creating a literal array to return in function
String names[] = {"Bob", "John", "Fred", "Juan Pedro"};
names[2] // returns 1337
names[1] = "newval"
names[10000]    // raises java.lang.ArrayIndexOutOfBoundsException
names.length    // => 4, the num items in the array

//2d array
int[][] tdarray = new int[10][20];
int[][] tdarray = { {1, 3}, {4, 5} };

// ArrayList can dynamically change size
ArrayList<String> mylist = new ArrayList<String>();
mylist.add("hi");
mylist.add(0, "new");  // add "new" string at index 0, so mylist ==> { "new", "hi" }
mylist.get(1)  // ==> "hi", get value at index 1
mylist.remove(1);  // mylist ==> { "new" }
mylist.set(0, "dude");  // mylist ==> { "dude" }

mylist.sort(Comparator.naturalOrder()); // sort in ascending order, modifies existing list
mylist.equals(anotherlist); // compare 2 arraylists, values and order

// variables can be of interface types, and thus contain any value that implements that type
List<String> mylist = new ArrayList<String>();

// caveat: since List is backed by array, we can't change the size, cant add elements to it
List<String> mylist = Arrays.asList("a", "b", "c"); // a short way to declare a new List

LinkedList<String> ll = new LinkedList<String>();  // linked lists

List<Integer> l = List.of(1,2,3);  // java9 has List#of method to quickly create/initialize list
List<Integer> l = Arrays.asList(1,2,3)  // another fast way to create list

// SET
HashSet<String> hs = new HashSet<String>();  // set, elements must be unique
hs.add("a"); hs.add("b");  // will return true
hs.add("a")  // returns false, "a" already in set
hs.contains("c") // false
hs.remove("a") // returns true if a existed b4 removal, false if it didn't exist
HashSet<String> hsnew = new HashSet<>(hs)  //  create a new set initialized with another set

// iterate over items in set
var iter = hs.iterator();
while (iter.hasNext()) {
    System.out.println(iter.next());
}
iter.forEachRemaining(System.out::println); // java8 way to pass a func to apply on each element

hs.stream().map(System.out::println) // using streams

// pass in collection to initialize a new Set
Set<Integer> s = new HashSet<>(Arrays.asList(1,2,3))
Set<Integer> s2 = new HashSet<>(Arrays.asList(1,2,3))

List<Integer> l = new ArrayList<>(s)  // can also create a ArrayList from a set

// compare if two sets are identical
s.equals(s2)  // returns true; 

new ArrayList<String>(hs); // can create a ArrayList from the HashSet

// MAP
HashMap<String, Integer> m = new HashMap<String, Integer>(); // impl of Map, hashtable at core, constant time lookup and insert
m.put("foo", 3);
m.get("boo");       // returns null if it doesnt exist
m.remove("foo");    // returns null if it doesnt exit, the value of the key if key does exist
m.size();           // return number of items
TreeMap<String, Integer> m = new TreeMap<String, Integer>(); // keys in tree struct, sorted

// STACKS
Stack<Integer> s = new Stack<>();
s.push(1);  // [ 1 ]
s.push(3);  // [1, 3]
s.size() // returns 2
s.pop();  // returns 3, s -> [1]
s.peek(); // see next stack item without removing, returns 1 here
s.empty();  // returns false
s.pop(); // return 1
s.pop(); // raises EmptyStackException sinc it's empty


// COMPOUND TYPES
HashMap<String, ArrayList<Integer>> ha = new HashMap<String, ArrayList<Integer>>();
HashMap<String, ArrayList<Integer>> ha = new HashMap<>();   // works too
ArrayList<Integer> a = new ArrayList<>();
a.add(3);
ha.put("foo", a);
```
### STRINGS
```java
"hi there".length()     // length of string
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

"ab".repeat(3)  // String "ababab"

// CHARs
char c = 'a'    // literal chars use single quotes
Character c = 'a'    // char is primitve type(unicode), Character type wraps char type, making it object-like
Character.isDigit('a')  //false
Character.isDigit('1')  //true
'c' - 'a'       // returns 2, minus/plus operators do addition/subtraction of their ascii codes

List<Character> c = new ArrayList<>()
char[] c = "hi there".toCharArray()  // returns char[] type

String first = "hi"; Float second = 1.1f; Integer third = 342;
String result = String.format("String %s in %s with some %s examples.", first, second, third);
System.out.println("the formatted string: " + result)

// StringBuilder not thread-safe, similar class StringBuffer is thread-safe
StringBuilder sb = new StringBuilder();     // fast builder for appending
sb.append("foo");       // efficiently append
sb.reverse();           // reverse order of chars
sb.setCharAt(1, "a");   // change character at index
sb.toString();          // covert to a string when done
```

## CONVERSIONS
```java
int a = Integer.parseInt("3");    // String -> int
int a = Integer.parseInt("foo");  // will raise NumberFormatException, also for int too big

float f = Float.parseFloat("25.1");    // String -> Float
String s = Float.toString(25.0f);      // Float -> String
String s = Character.toString('a')   //  char -> String, 'a' to "a"

char[] c = "hi there".toCharArray();

int a = Integer.toString(3);     // int -> String

int a = (int)1.6         // cast float to int, a rounded down to 1
int a = (long)11         // cast int to long, long is 64bit
int b = (Double)1.6f     // FAILS, doubles and floats cant be converted b/w each other
```

## MATH
```java
var a = 1.1F; // F means Float
var a = 1.2D; // F means Double
var a = 1.1; // will infer to Double
int i = 3;
int j = i / 2;  // j = 1
Math.max(1,2)   // returns 2
Math.min(1,2)   // returns 1
Math.abs(-1)   // returns 1
Math.abs(-1.1)   // returns 1.1
Math.max(1.1f, 2)   // can mix floats with ints, returns 2

Math.random()   // return num between 0.0(inclusive) to 1.0(exclusive)
int randomNum = (int)(Math.random() * 101);  // 0 to 100
```

## FUNCTIONAL PROGRAMMING
- java17 has `Optional<T>`
- has lambda expressions

## GC/ALLOCATION
- generally all variables store on the heap
    - primitives (ints, bools, etc) will go on the stack
    - fixed sized plain arrays also go on the heap
    - basically all objects go on the heap

## TYPE SYSTEM
- `final` keyword means it can't be changed (synonymous to `val` in scala)
- `java.lang.Object` is root class of Java class hierarchy, every class is descendant of this class
    - defines `toString()`, `equals(Object o)`, `hashCode()`, `getClass()`, `notify()`
    - a class defined with no superclass automatically extends `Object`
### CLASSES
- static and member variables not initialized have a `null` value
- `Object` is root of the class heirarchy, all objects are a decendent of `Object`
- Generic classes
    ```java
    public class Box<T> {       // example generic class
        private T t;
        public void set(T t) { this.t = t; }
        public T get() { return t; }
    }
    ```
### INTERFACE
- cannot be instantiated
- cannot implement any methods
- a class can implement many interfaces, multiple inheritence
- can not have non-final and non-static variables
### ABSTRACT CLASS
- cannot be instantiated
- can implement methods
- no multiple inheritence
- can have final and non-final variables, static and non-static variables
### RECORD
- immutable
- data struct that has a setter/getter, constructor, `equals` method, `hashCode` method, `toString` method
### INFERENCE
- java10 introduces some local var inference: 
    - `var a = 3; var b = "hi"`, compiler will inference these `var`s
    - `var f = new HashMapString, Integer>();`
### VAR
- `var` keyword introduced in java10. can declare variable without type, type will be inferred from value
- `var x = 3`   - inferred `x` is of type `Integer`

## INTROSPECTION
- `(object) instanceof (type)` - test if object is instance of type, or subtype of type, or implements an interface
    - e.g. if `Dog` is subclass of `Animal`; `Dog foo = new Dog(); assertTrue(foo instanceof Animal)`
```java
    Class c = Class.forName("java.lang.String")
    Class c = java.lang.String.class  // 2nd method to get Class of class
    boolean b = c.isInstance("hi")  // true
    boolean b = c.isInstance(3)     // false
```

## IO
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

## CONTROL STRUCTURES
```java
for (int i = 0; i < 10; i++) {
    System.out.println(i);
    if (true) { continue; }     // continue will skip iteration
    if (true) { break; }     // break will terminate the loop in scope
}

while (i < 10 && x != 3) {
    i++;
}

if (true && true) { System.out.println("hi"); }
else if (false || false) { System.out.println("elseif"); }
else  System.out.println("else"); }

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

//try catch
try { ... } 
catch (SomeException e) { .. }
catch (AnotherException e) { .. }
finally { .. }  // finally is always exected
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
