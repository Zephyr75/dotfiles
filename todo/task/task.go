package task

import (
	"time"
)

type Task struct {
	Description string
	Done  bool
	Importance int
	Project string
	Date time.Time
	IgnoreHour bool
	IgnoreDate bool
}


