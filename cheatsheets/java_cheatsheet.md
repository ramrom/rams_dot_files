# JAVA
- https://learnxinyminutes.com/docs/java/
- `jshell` start REPL env in terminal

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
### ARRAYS
```java
int[] intArray = new int[10];
String[] stringArray = new String[1];

int[] y = {9000, 1000, 1337};
String names[] = {"Bob", "John", "Fred", "Juan Pedro"};
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
