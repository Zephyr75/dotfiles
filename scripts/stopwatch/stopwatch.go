package main

import(
	"fmt"
	"time"
)

func format(d time.Duration) string {
	mil := d.Milliseconds() % 1000
	sec := int(d.Seconds()) % 60
	min := int(d.Minutes())
	return fmt.Sprintf("%v m %02v s %03v ms", min, sec, mil)
}

func main() {
	t := time.Now()
	for {
    time.Sleep(10 * time.Millisecond)	
		s := format(time.Since(t))
		fmt.Print("\r", s)
	}
}
