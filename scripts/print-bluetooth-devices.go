package main

import "os/exec"
import "fmt"
// import "os"

func main() {
    cmd := exec.Command("bluetoothctl", "paired-devices")
    // cmd.Stdout = os.Stdout
    // cmd.Stderr = os.Stderr
    // cmd.Run()
    out, err := cmd.CombinedOutput()
    if err != nil {
        fmt.Println(err)
    } else {
        fmt.Println(string(out))
    }
}
