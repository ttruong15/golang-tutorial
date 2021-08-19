package main

import (
	"fmt"
	"os"
	"strconv"
	"dichoidi.com/hello"
)


type Animal interface {
	walk()
	eat()
}

type Dog struct {
	age int
}

func (d Dog) walk() {
	fmt.Println("Dog walk", d.age)
}

func (d Dog) eat() {
	fmt.Println("Dog eat", d.age)
}

type Cat struct {
	age int
}

func (c Cat) walk() {
	fmt.Println("Cat walk", c.age)
}

func (c Cat) eat() {
	fmt.Println("Cat eat", c.age)
}

func walkEat(a Animal) {
	a.walk()
	a.eat()
}
func main() {
	age,_ := strconv.Atoi(os.Args[1])

	dog := Dog{age}
	walkEat(dog)

	cat := Cat{age}
	walkEat(cat)

	hello.Hey("Tom")
}
