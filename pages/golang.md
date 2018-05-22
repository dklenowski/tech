Categories: programming
Tags: go
      golang

## TODO

	make(chan struct{})
	message, _ := bufio.NewReader(conn).ReadString('\n')
	`_`  - i think that is used when you dont want to create a variable for something ..


## Cheatsheet

### Printing stuff

- Use `%v` format to print arrays.
- Use `%+v` to print structs (the `+` add's field names)

## Variables

### Global

	var DB string = "database"

###  Short 

- i.e. dont specify a type, can be resused for different types
- can only be used inside functions

	    i,j := 10
	    f := float32(10)

## Const

	const typedHello string = "Hello"		# typed, cant be reassigned to a untyped variable
	const hello = "Hello"

## Strings

	glog.Infof("result=%s", str)

## Arrays

	var a [4]int
	a[0] = 1
	i := a[0]
	// i == 1

## Slices

### Initialization

	len := 10
	var a []int = make([]int, len)
	for i := range a {
		a[i] = 1
	}

### Empty Slices

	// Use make to create an empty slice of integers.
	slice := make([]int, 0)
	// Use a slice literal to create an empty slice of integers.
	slice := []int{}

## Maps

### Check if a key exists

	_, ok := m["key"]
	if ok {
		// key exists
	}

## Structs

### Initialization

	type GraphMsg struct {
		number int
		y float32
	}
	..
	g := GraphMsg{number: num, y:val}
	
## Pointers

### Returning from a function

	var p = f()
	func f() *int {
		v := 1
	return &v
	}

## Functions

### Returning multiple values

    func vals() (int, int) {
        return 3, 7
    }
    
    a, b := vals()
 