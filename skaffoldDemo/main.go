package main

import (
	"fmt"
	"os"
	"time"
)

func main() {
	for {
		fmt.Println("RUN_TIME:", os.Getenv("RUN_TIME"))
		fmt.Println("Hello world!")

		time.Sleep(time.Second * 1)
	}
}
