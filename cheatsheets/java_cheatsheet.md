# JAVA
- https://learnxinyminutes.com/docs/java/
- `jshell` start REPL env in terminal
- java is by comp sci def pass-by-value: https://stackoverflow.com/questions/40480/is-java-pass-by-reference-or-pass-by-value
    - for objects, variables store values that are references to objects
        - so reassigned a variable passed into a function with new value, will not change the variable assignment in caller
    - so every variable holds "references" that essentially those references are copied in a function call
        - the exception is some primitive types like integer, which are just direct values

## FEATURES
- varargs(variadic arguments) for functions, e.g. `void foo(String... vals) {..}; foo("one"); foo("one","two");`
    - they have an array-like API
    - method can only have one varargs param
    - it must be the last param

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
### ARRAY
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

var clone = y.clone();  // make a copy of the array

//2D ARRAY
// allocating array initializes depending on type, String,Dobule -> null, boolean -> false, int -> 0
boolean[][] boolarr = new boolean[1][1];  
int[][] tdarray = new int[10][20];
int[][] tdarray = { {1, 3}, {4, 5} };
Arrays.sort(tdarray, (x,y) -> (x[0] - y[0]))       // sort in ascending order of first element in each sub array
Arrays.sort(tdarray, (x,y) -> (y[1] - x[1]))       // sort in descending order of second element in each sub array
System.out.println(Arrays.deepToString(tdarray))  // deepToString great for printing nested arrays
```
### COLLECTION
- the Collection is a superinterface of List and Set
- List adds order and can be indexed
- Set is a Collection that guarantees unique values
### LIST
```java
// ArrayList and LinkedList are main implementation of List interface
// ArrayList can dynamically change size
ArrayList<String> mylist = new ArrayList<String>();
mylist.add("hi");
mylist.add(0, "new");  // add "new" string at index 0, so mylist ==> { "new", "hi" }
mylist.size()   // returns 2, size returns length, not capacity of ArrayList
mylist.get(1)  // ==> "hi", get value at index 1
mylist.remove(1);  // mylist ==> { "new" }
mylist.set(0, "dude");  // mylist ==> { "dude" }

// BINARY SEARCH
class Foo { int i; Foo(int i) { this.i = i;} // #implement Comparable interface } 
var arr = new Foo[] { new Foo(1), new Foo(2); }; var key = new Foo(2); int startidx = 0; int endidx = 1;
Arrays.binarySearch(arr, startidx, endidx, key);


// SORTING
mylist.sort(Comparator.naturalOrder()); // sort in ascending order, modifies existing list
Arrays.parallelSort(mylist);    // multithreaded sort, uses merge sort (breaks array into subarrays, forkjoin pool for parralelism)
mylist.equals(anotherlist); // compare 2 arraylists, values and order

Arrays.sort(mylist);        // another way to sort, works for all primitive types like int/float/string
// if mylist type doesnt implement Comparable interface can pass in anon class of Comparator interface
class Foo { int x; Foo(int x) { this.x = x; } }
Comparator<Foo> FooComparator = new Comparator<Foo>() { public int compare(Foo first, Foo second) { return first.x - second.x; } };
var foos = new Foo[] { new Foo(3), new Foo(1), new Foo(-1) };
Arrays.sort(foos, FooComparator);  // foos will be { Foo(-1), Foo(1), Foo(3) }

// using lambda expression
var myList = new String[] { "b", "a" }
Arrays.sort(myList, (a,b) -> a.compareTo(b));  // returns String[2] { "a" , "b" }


// variables can be of interface types, and thus contain any value that implements that type
List<String> mylist = new ArrayList<String>();

// LinkedList is a doubly linked list
LinkedList<String> ll = new LinkedList<String>();  // linked lists

// Vector is near identical to ArrayList, excecpt it's thread-safe b/c it's synchronized
List<String> v = new Vector<String>();

// caveat: these are immutable structures, underlying type List contains is basic array
List<Integer> l = List.of(1,2,3);  // java9 has List#of, it's immutable, fixed-size, null values not allowed
List<Integer> l = Arrays.asList(1,2,3)  // unlike List#of, can update elements, backed by array, still fixed-size, allows null items
List<String> mylist = Arrays.asList("a", "b", "c"); // e.g. for strings

ArrayList<String> mylist = new ArrayList<>(Arrays.asList("hi","there"));  // can create dynamic Arraylist this way
var mylist = new ArrayList<String>(Arrays.asList("hi","there"));  // can use var, and inferred this way

// from String[] to ArrayList<String>
var strs = new String[]{"hi","there"};
var alstrs = new ArrayList<String>(Arrays.asList(strs)); // Arrays#asList converts to List<String>, need ArrayList<String>

// create streams
mylist.stream().forEach(i -> System.out.println(i));

// NESTED LIST
List<List<Foo>> ll = new List<ArrayList<Foo>>();        // obviously fails, outer List is abstract here
List<List<Foo>> ll = new ArrayList<List<Foo>>();                  // OK
ArrayList<ArrayList<Foo>> ll = new ArrayList<ArrayList<Foo>>();   // OK
List<ArrayList<Foo>> ll = new ArrayList<ArrayList<Foo>>();        // OK
// following are throw "incompatible types cant convert" errors
ArrayList<ArrayList<Foo>> ll = new ArrayList<List<Foo>>();   // value inner list can be say LinkedList but variable guarantees ArrayList
ArrayList<List<Foo>> ll = new ArrayList<ArrayList<Foo>>();   // var inner list implies a LinkedList can be set, but value doesnt
List<List<Foo>> ll = new ArrayList<ArrayList<Foo>>();        // same as above
```
### SET
```java
// HashSet and TreeSet and main implementations of interface Set
HashSet<String> hs = new HashSet<String>();  // set, elements must be unique
hs.add("a"); hs.add("b");  // will return true
hs.add("a")  // returns false, "a" already in set
hs.size()  // returns # of items in set
hs.contains("c") // false
hs.remove("a") // returns true if a existed b4 removal, false if it didn't exist
HashSet<String> hsnew = new HashSet<>(hs)  //  create a new set initialized with another set

String[] s = new String[hs.size()];
hs.toArray(s); // convert set to Array of strings, NOTE: toArray returns type Object[]
int i=0;
for (String s: hs) { s[i] = s; i++; }  // prolly easiest way to convert to String[]

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
```
### MAP
```java
// HashMap and TreeMap are main implementations of AbstractMap class
    // HashMap, implements Map interface, uses array("buckets"), #hashCode method on key called to find bucket
        // in collisions a list for that bucket is created
    // TreeMap, implements NavigableMap interface, uses red-black tree
    // order guaranteed in TreeMap, not HashMap
Map<String, Integer> m = new HashMap<String, Integer>(); // impl of Map, hashtable at core, constant time lookup and insert
m.put("foo", 3);
m.get("boo");       // returns null if it doesnt exist
m.remove("foo");    // returns null if it doesnt exit, the value of the key if key does exist
m.size();           // return number of items
m.getOrDefault(4, 1)   // if get value doesnt exist return the default value in 2nd arg
TreeMap<String, Integer> m = new TreeMap<String, Integer>(); // keys in tree struct, sorted

// can specify initial capacity, default is 16, use if size of dataset is know prehand
// load factor is metric for rehashing(increasing capacity and recalculating hashes of keys), rehashing occurs with threshold crossed
HashMap<String, Integer> m = new HashMap<String, Integer>(100); // can pass in initial capacity argument
var m = new LinkedHashMap<Integer, Integer>();  // hashmap that maintains insertion order

// getting keys and values
Set<String> key = m.keySet()                             // return a Set containing all the keys
Set<Map.Entry<Integer, Integer>> pairs = m.entrySet();  // entrySet returns a set of key-val mappings
Collection<Integer> vals = m.values()                      // return a Collection of values
for (v: vals) { System.out.println(v); }                // can iterate over a Collection


// iterating over a map
Map<String, String> map = ...
for (Map.Entry<String, String> entry : map.entrySet()) {
    System.out.println(entry.getKey() + "/" + entry.getValue());
}
// java10+
for (var entry : map.entrySet()) {
    System.out.println(entry.getKey() + "/" + entry.getValue());
}

//equality
map1.equals(map2)  // works if key and value type both support equals method 

// the values of hashmap are a doubly linked list
// it maintains insertion order, one application is LRU cache
var lhm = new LinkedHashMap<String, String>();
```
### STACKS
```java
// Many implementations, has a default, but types like LinkedList support interface
Stack<Integer> s = new Stack<Integer>();
s.push(1);  // [ 1 ]
s.push(3);  // [1, 3]
s.size() // returns 2
s.pop();  // returns 3, s -> [1]
s.peek(); // see next stack item without removing, returns 1 here
s.empty();  // returns false
s.pop(); // return 1
s.pop(); // raises EmptyStackException sinc it's empty
```
### QUEUE
```java
// java.util.Queue is main interface. main implementation: LinkedList, ArrayDequeue, PriorityQueue
// ArrayDequeue uses a array backing, and arrays are generally always better than linked lists
Queue<String> queue = new LinkedList<>();
queue.add("a");     // add to queue, returns `true` if successful, throws `IllegalStateException` if it's full
queue.add("b");
queue.offer("b");  // same as add but returns false if adding fails
queue.peek():    // retrieves, but does not remove next item in queue, returns null if queue empty
queue.element():    // like peek, but throws exception if queue is empty
queue.poll();     // retreives and removes next item in queue, returns null if empty
queue.remove();     // like poll but throws exception if queue is empty
queue.clear();  // clear queue
```
#### PRIORITY QUEUE
- PriorityQueue uses a binary balanced heap data struct, efficiently get lowest(or highest) priority item (O(logN) time)
- the type the queue contains must implement `Comparable` interface or pass in a `Comparator` instance when initializing queue
```java
PriorityQueue<Integer> intQ = new PriorityQueue<>();  // uses natural ordering (null comparator)
PriorityQueue<Integer> intQcomparator = new PriorityQueue<>((Integer c1, Integer c2) -> Integer.compare(c1, c2)); // specify comparator

integerQueueWithComparator.add(3);  // add inserts a item, and heap internall will restructure so root is min(or max)
integerQueue.add(3);                // add returns true normally, but for capacity-limited queue, it throws if full
integerQueueWithComparator.add(2);
integerQueue.offer(2);              // offer is same as add but returns false if capacity is reached
integerQueue.peek();                // peek will look at root without removing it, this returns 2, null if empty

// poll will remove and return root, returns null if empty
assertThat(integerQueue.poll()).isEqualTo(2).isEqualTo(integerQueueWithComparator.poll());  // nautral ordering is lowest to highest
assertThat(integerQueue.poll()).isEqualTo(3).isEqualTo(integerQueueWithComparator.poll());
integerQueue.remove();   // remove is same as poll, except it throws exception if empty

PriorityQueue<Integer> reversedQueue = new PriorityQueue<>(Collections.reverseOrder());  // inverse ordering of Integer

reversedQueue.add(1); reversedQueue.add(2);

assertThat(reversedQueue.poll()).isEqualTo(2);  // inverse gives higher number first
assertThat(reversedQueue.poll()).isEqualTo(1);
```
### COMPOUND TYPES
```java
HashMap<String, ArrayList<Integer>> ha = new HashMap<String, ArrayList<Integer>>();
HashMap<String, ArrayList<Integer>> ha = new HashMap<>();   // works too
ArrayList<Integer> a = new ArrayList<>();
a.add(3);
ha.put("foo", a);
```

## STREAMS
- introduced in java8, improved in java9
- also supports `sort`, `min`, `max`, `distinct`(remove dups), `allMatch`, `anyMatch`, `noneMatch`
- parllelism (concurrent) via `parralel` e.g. `Stream.of(1,2).parallel().map(i->i+1)`
- has infinite streams via `generate` and `iterate`
```java
Stream.of(1,2,3).map(i -> i + 1).collect(Collectors.toList()) // returns List(2,3,4)
Stream.of(1,2,3).forEach(System.out::println);          // will print 1 2 3 on seperate lines

Stream.of("a","b").forEach(i -> System.out.println(i));

var a = new ArrayList<Integer>(); a.add(1); a.add(2);
// Collector interface also has toMap, toSet
a.stream().map(i -> i + 2).filter(i -> i > 3).collect(Collectors.toList()) // returns List(4)
a.stream().collect(Collectors.toSet()) // returns a set

// create collection of objects from array data
var s = Arrays.stream(new int[] { 1,2,3};
class Foo { int data; Foo(int i) { this.data = i;} };
var obj_collection = s.map(item -> { return new Foo(item); }).collect(Collectors.toList());

System.out.println(obj_collection.get(0).data1)     // should print 1
```

## CONCURRENCY
- `synchronized` keyword 
    - on instance method - ensures method can only by run by one thread per object instance
        - e.g. `public synchronized void foo(int x) { // do stuff }`
    - on static method - ensures only thread can execute the method at any time (since only one Class object)
        - e.g. `public static synchronized void foo(int x) { // do stuff }`
    - code block - basically mutex on some code, takes an argument for the object to lock on
        - `synchronized (this) { //do stuff }`
    - thread can obtain lock over and over
    ```java
    Object lock = new Object();
    synchronized (lock) {
        System.out.println("First time acquiring it");
        synchronized (lock) {
            System.out.println("Entering again"); 
    } }
    ```
- create a thread - extend `Thread` class and define `run`
    ```java
    public class NewThread extends Thread {
    public void run() {
        System.out.println(this.getName() + ": New Thread is running...");
        Thread.sleep(1000);
    } }
    ```
- thread pools `ExecutorService executor = Executors.newFixedThreadPool(10);`
    - run task in pool - `executor.submit(() -> { new Task(); });`

## STRINGS
```java
// type String is immutable
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

// COMPARISON
new String("a") == new String("a")  // false, == operator compares identity, not value
"a" == "a"          // returns true, these are primitive string types, so "content" is compared
new String("a").equals(new String("a"))   // returns true, use #equals method on String to compare content
new String("b").compareTo(new String("b"))  // returns an int comparing the two

List<Character> c = new ArrayList<>()
char[] c = "hi there".toCharArray()  // returns char[8] type `char[8] { 'h', 'i', ' ', 't', 'h', 'e', 'r', 'e' }`

String first = "hi"; Float second = 1.1f; Integer third = 342;
String result = String.format("String %s in %s with some %s examples.", first, second, third);
System.out.println("the formatted string: " + result)

// StringBuilder not thread-safe, similar class StringBuffer is thread-safe
StringBuilder sb = new StringBuilder();     // fast builder for appending
StringBuilder sb2 = new StringBuilder("foo");     // initialize with string
sb.append("foo");       // efficiently append
sb.length();            // get length
sb.reverse();           // reverse order of chars
sb.setCharAt(1, "a");   // change character at index
sb.deleteCharAt(3);     // delete character at index
sb.toString();          // covert to a string when done

Arrays.toString(new int[] { 1,2,3})  // will create string "[1,2,3]"
System.out.println(Arrays.toString(new int[] { 1,2,3}))  // will print above to STDOUT, good for debug printing
Arrays.deepToString(new int[] {{1,2},{3,4}})  // deepToString for nested arrays

class Foo { int i; Foo(int i) { this.i = i; }; public String toString() { return "{ i: " + i + "}"; } }
var foos = new Foo[] { new Foo(1), new Foo(2) }
System.out.println(Arrays.toString(foos))   // will print [ { i: 1 }, { i: 2 } ]
```

## PRIMITIVE TYPES
- 8 primitive types: Java-byte, short, char, int, long, double, float, boolean
- `int` - 4 bytes, `short` - 2 bytes, `long` 8 bytes, `byte` - 1 byte
    - all are signed 2's complement
    - `char` is 16bit unsigned
### CHARACTER
- `Character` is wrapper for `char`
- `Character.isDigit('3')`   - returns true
- 
    ```java
    char c = 'a'    // literal chars use single quotes
    Character c = 'a'    // char is primitve type(unicode), Character type wraps char type, making it object-like
    Character.isDigit('a')  //false
    Character.isDigit('1')  //true
    'c' - 'a'       // returns 2, minus/plus operators do addition/subtraction of their ascii codes
    '1' == 49       // return true, 49 is ASCII val for char `1`
    ```
### NUMBERS
- a literal `3` is inferred as `int`, a literal `1.0` is inferred as `double`
    - use `1L`(long), `1.0F`(float)
- hex notation - `long hex = 0xF1FZ`
- binary notation - `long b = 0b110101011`
- `var v = 1L`  - `L` means literal type `long`, `1D` - `D` for double, `F` for float
- `int` vs `Integer` -> `Integer` is class with underlying `int` and adds properties and methods
    - same for `long`/`Long`, `double`/`Double`, `float`/`Float`
- get max/min of `Integer`/`Long`/`Short`/`Byte` -> e.g. `Long.MAX_VALUE` , `Integer.MIN_VALUE`
### BOOLEANS
```java
// can store expressions 
boolean b = ("a" == "a");       // b stores true
boolean b2 = (3 == 4);         // b2 stores false
```

## OPERATORS
### BITWISE OPERATORS
- `^` bitwise XOR, `|` bitwise OR, `&` bitwise AND
- `int` `short` `long` `char` `byte` support it
- `'a' ^ 0b000100000` - can do bitwise ops on characters, here we toggle(XOR with 1) 5th bit 
    - by toggling 5th bit we add or sub 32, in ASCII this is cool way to toggles upper to lower case, we get integer for `A` here
    - bitwise op will give `int`, so convert back to char by `(char)('a' ^ 0b000100000)`


## CONVERSIONS
```java
int a = Integer.parseInt("3");    // String -> int
int a = Integer.parseInt("foo");  // will raise NumberFormatException, also for int too big
Integer.valueOf("1");        // String -> Integer, and allows null inputs unlike parseInt
Integer.toString(3)     // converts to String "3"

float f = Float.parseFloat("25.1");    // String -> Float
double d = Double.parseDouble("25.1");    // String -> Double
String s = Float.toString(25.0f);      // Float -> String
String s = Character.toString('a')   //  char -> String, 'a' to "a"

Double d = new Double(3);  // create double from int, will be 3.0D
Double d = new Double(3.43F);  // double from float
Double d = new Double("3.44");  // double from string
Float f = new Float(4);  // create float from int, will be 4.0F

char[] c = "hi there".toCharArray();
String s = new String(c);   // create String from char array

int a = Integer.toString(3);     // int -> String

int a = (int)1.6         // cast float to int, a rounded down to 1
int a = (long)11         // cast int to long, long is 64bit
Float f = (float)4      // cast int to float
Double d = (double)4    // cast int to double
int b = (Double)1.6f     // FAILS, doubles and floats cant be converted b/w each other

(char) 49   // returns char '1'
(int) '1'   // returns int 49

// introspection and conversion with casting
class Foo() {};
Foo convert(Object o) {
    if (o instanceof Foo) { return (Foo)o; }
    return null;
}
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
Math.pow(3,4)   // power/exponent, this returns Double 81.0

Math.random()   // return num between 0.0(inclusive) to 1.0(exclusive)
int randomNum = (int)(Math.random() * 101);  // 0 to 100
int randomNum = (int)(Math.random() * (200-100) + 100);  // 100 to 200
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
    - a `final` member cannot be overridden by child class
- `static` keyword - belongs to type itself, and not instance of the type, all instances share the static member (aka class global)
- scope/visibility: member of can be: default, public, private, protected
    - member is default if one of 3 not specified, default accessible in class and package (not world or subclass)
- `java.lang.Object` is root class of Java class hierarchy, every class is descendant of this class
    - defines `toString()`, `equals(Object o)`, `hashCode()`, `getClass()`, `notify()`
    - a class defined with no superclass automatically extends `Object`
    - `Object#equals` compares identity, not content so:
        ```java
        class Foo { int data; Foo(int i) { this.data = i; } }
        var f = new Foo(3);
        var f2 = new Foo(3);
        f.equals(f2) // return false, data is identical but #equals compares identity, and these are 2 diff objects
        ```
    - `hashCode` - return integer values generated by hash function
        - objects that are equal (via `equals()`) must return same hashcode
        - inverse not true true, two non-equal objects can have the same hashcode
    - `toString` 
        - the default `Object#toString` will return a string of the class name and hashCode seperated by `@`
            - *NOTE* the hashcode is represented as hexadecimal, not decimal
        - `System.out.print` calls this method
### CLASSES
- regular inheritence: `class Foo {}; class SubFoo extends Foo {};`
- multiple inheritence: `class Foo {}; class Bar {}; class FooBar extends Foo, Bar {};`
- can call `super` to invoke the parent classes implementation of a overridden method
```java
class Foo {
    int data;
    static int staticdata;  // member belongs to class itself, has kind of class-global scope

    static void hello(); // static method member

    int getter() { return data; } // b/c not specified has "default" scope, can be access by anything in package
    public int pubgetter() { return data; } // public can be accessed by anyone
    private int privgetter() { return data; } // private can only be accessed within class
    protected int protgetter() { return data; } // protected can be seen within class and subclass

    public Foo(int i) { this.data = i; }  // constructor 1
    public Foo(int i, int y) { this.data = i + y; } // constuctor 2
}

Foo f = new Foo(3); 
Foo f2 = new Foo(1,2);
```
- static and member variables not initialized have a `null` value
- `Object` is root of the class heirarchy, all objects are a decendent of `Object`
#### GENERIC CLASSES
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
### ANONYMOUS CLASSES
```java
// can create anonymous child class from a parent class, Book in this case
new Book("foo book") {
    @Override
    public String description() { return "a book"; }
}

// can instaniate an anonymous class that implements an interface
interface Iface { void afunc(); }
// interfaces have no constructors so parens remain empty
Iface i = new IFace() { public void afunc() { System.out.println("hi"); } }   // anonymous class that implmeents I

// anonymous class from generic interface
interface GenericIface<T> { void afunc(T t); }
new GenericIface<String>() { void afunc(String s) {} }
```
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
// FOR LOOP
for (int i = 0; i < 10; i++) {
    System.out.println(i);
    if (true) { continue; }     // continue will skip iteration
    if (true) { break; }     // break will terminate the loop in scope
}

// more complicated statements
for (int i = 3; i * 2 < 10; i = (i * 10) + 30) { 
    System.out.println(i); 
} 

// say we have HashSet s, we can iterate over it's elements
for (int i: s) {
    System.out.println(i);
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

//ternary operator
String bar = (3 < 10) ? "A" : "B";
```
### EXCEPTIONS
- to throw method must declare it, e.g. `public int foo(int a) throws Exception { throw new Exception("foo"); }`
    - the calling function must either try/catch or declare it can throw if unhandled
- `throw new Exception("foobar")`
```java
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
- added in java 1.4
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
- java21, sept2023, end at sept2031
