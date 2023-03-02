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

## BUILD TOOLS
- Ant
- Maven
- Gradle - newest and honeslty best, written in groovey

## HSITORY
- java5(1.5), sept2004 - generics, annotations, enumerations(`enum`),
- java8, mar2014, LTS(till 2025) - lamba functions
- java11, sept2018, LTS - TLS, http client, epsilon garbage collector
- java16, mar2021 - remove ahead-of-time compilation, Graal JIT, source moved to github from mercurial
- java17, sept2021, LTS - better pattern matching
