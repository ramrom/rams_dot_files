package main

import "fmt"

// this ends up creating an infinite recursion function
func comp(fs ...func(int)int) func(int)int {
    var tf, final func(int)int
    for _,f := range fs {
        if final == nil {
            final = f
        } else {
            tf = func(i int) int {
                return f(final(i))
            }
            final = tf
        }
    }
    return final
}

func comp2(fs ...func(int)int) func(int)int {
    final := make([]func(int)int,len(fs))
    for i,f := range fs {
        if i == 0 {
            final[i] = f
        } else {
            final[i] = func(j int) int {
                return f(final[i-1](j))
            }
        }
    }
    return final[len(final)-1]
}
func main() {
    fm := comp2(func(i int)int { return i+3 }, func(i int)int { return i+2})
    //fmt.Println(fm)
    fmt.Println(fm(4))
    //ff := c2(func(i int)int { return i * 2 }, func(i int)int { return i * 4 })
    //fmt.Println(ff(4))
}

func c2(f1 func(int) int, f2 func(int) int) func(int)int {
    return func(i int)int {
        return f1(f2(i))
    }
}
