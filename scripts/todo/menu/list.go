package menu

import (
	// "fmt"
	"todo/task"

	"github.com/rivo/tview"

	"sort"

	"github.com/gdamore/tcell/v2"
)

func ListMenu(app *tview.Application, list *tview.List, tasks *[]task.Task) *tview.Form {
	form := tview.NewForm()
	if len(*tasks) == 0 {
		form.AddTextView("No tasks yet", "", 40, 1, true, false)
	}

	sort.Slice(*tasks, func(i, j int) bool {
		return (*tasks)[i].Date.Before((*tasks)[j].Date)
	})

	sort.Slice(*tasks, func(i, j int) bool {
		return (*tasks)[i].Project < (*tasks)[j].Project
	})

	currentProject := ""
	for i := range *tasks {
		newProject := (*tasks)[i].Project
		if newProject != currentProject {
			title := "[white]" + newProject + " "
			for i := 0; i < 40 - len(newProject); i++ {
				title += "-"
			}
			form.AddTextView(title, "", 40, 1, true, false)
			currentProject = newProject
		}
		taskTitle := (*tasks)[i].Description
		title := "    " + taskTitle

		date := (*tasks)[i].Date.Format("2006-01-02")
		hour := (*tasks)[i].Date.Format("15:04")

		if date != "0001-01-01" {
			title = title + " - " + (*tasks)[i].Date.Format("2006-01-02")
		}
		if hour != "00:00" {
			title = title + " - " + (*tasks)[i].Date.Format("15:04")
		}

		switch (*tasks)[i].Importance {
		case 0:
			title = "[green]" + title
		case 1:
			title = "[yellow]" + title
		case 2:
			title = "[red]" + title
		}

		form.AddCheckbox(title, (*tasks)[i].Done, func(checked bool) {
			for i := range *tasks {
				if (*tasks)[i].Description == taskTitle {
					(*tasks)[i].Done = checked
				}
			}
		})
	}
	form.AddButton("Back", func() {
		app.SetRoot(list, true)
	})
	form.SetFieldBackgroundColor(tcell.ColorDarkSlateBlue)
	form.SetButtonBackgroundColor(tcell.ColorDarkSlateBlue)
	return form
}
