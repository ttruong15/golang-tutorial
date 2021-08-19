package main

import (
    "fmt"

    "dichoidi.com/greetings"
    "dichoidi.com/hello"
)

func main() {
    // Get a greeting message and print it.
    message := greetings.Hello("Gladys")
    fmt.Println(message)

    hello.Hey("You")
}
