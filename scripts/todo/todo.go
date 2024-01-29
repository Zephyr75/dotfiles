package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"path/filepath"

	// "path/filepath"
	"time"

	"todo/menu"
	"todo/task"

	"github.com/rivo/tview"
)

// TODO test

// TODO add a way to delete tasks

func main() {

	tasks := make([]task.Task, 0)
	tasks = loadTasks()

	app := tview.NewApplication()
	list := tview.NewList()
	list.AddItem("Add", "Add a new task", 'a', func() {
		app.SetRoot(menu.AddMenu(app, list, &tasks), true)
	}).
		AddItem("List", "List all tasks", 'l', func() {
			app.SetRoot(menu.ListMenu(app, list, &tasks), true)
		}).
		AddItem("Edit", "Edit a task", 'e', func() {
			app.SetRoot(menu.EditMenu(app, list, &tasks), true)
		}).
		AddItem("Quit", "Exit program", 'q', func() {
			app.Stop()
		})
	if err := app.SetRoot(list, true).SetFocus(list).Run(); err != nil {
		panic(err)
	}

	// for _, t := range tasks {
	// 	fmt.Println(t)
	// }

	saveTasks(tasks)
}

func loadTasks() []task.Task {
	// absPath, _ := filepath.Abs("~/Documents/todos.txt")

	executablePath, err := os.Executable()
	absPath := filepath.Join(filepath.Dir(executablePath), "todos.txt")

	file, err := os.Open(absPath)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)

	tasks := make([]task.Task, 0)
	currentTask := task.Task{}
	i := 0
	for scanner.Scan() {
		switch i % 4 {
		case 0:
			currentTask.Description = scanner.Text()
		case 1:
			fmt.Sscanf(scanner.Text(), "%t %d %s", &currentTask.Done, &currentTask.Importance, &currentTask.Project)
		case 2:
			var dateStr, hourStr string
			fmt.Sscanf(scanner.Text(), "%t %s %t %s", &currentTask.IgnoreDate, &dateStr, &currentTask.IgnoreHour, &hourStr)
			currentTask.Date, _ = time.Parse("2006-01-02 15:04", dateStr+" "+hourStr)
		default:
			tasks = append(tasks, currentTask)
		}
		i++
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return tasks
}

func saveTasks(tasks []task.Task) {
	// absPath, _ := filepath.Abs("/Documents/todos.txt")

	executablePath, err := os.Executable()
	absPath := filepath.Join(filepath.Dir(executablePath), "todos.txt")

	file, err := os.Create(absPath)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	// write to file
	for _, t := range tasks {
		if t.Done {
			continue
		}
		fmt.Fprintf(file, "%s\n", t.Description)
		fmt.Fprintf(file, "%t %d %s\n", t.Done, t.Importance, t.Project)
		fmt.Fprintf(file, "%t %s %t %s\n\n", t.IgnoreDate, t.Date.Format("2006-01-02"), t.IgnoreHour, t.Date.Format("15:04"))
	}
}
