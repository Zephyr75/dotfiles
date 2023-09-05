package menu

import (
	"github.com/rivo/tview"
	"time"
	"todo/task"

	"github.com/gdamore/tcell/v2"
)

func AddMenu(app *tview.Application, list *tview.List, tasks *[]task.Task) *tview.Form {

	projects := make([]string, 0)
	var projectsStr string
	for _, t := range *tasks {
		if !contains(projects, t.Project) && t.Project != "" {
			projects = append(projects, t.Project)
			projectsStr += t.Project + "-"
		}
	}
	if len(projectsStr) > 0 {
		projectsStr = projectsStr[:len(projectsStr)-1]
	} else {
		projectsStr = "No projects yet"
	}

	var description string
	var importance int
	var project string
	date, _ := time.Parse("2006-01-02", time.Now().Format("2006-01-02"))
	hour, _ := time.Parse("15:04", time.Now().Format("15:04"))
	ignoreHour := false
	ignoreDate := false

	dateInput := tview.NewInputField().SetLabel("    Due date").SetFieldWidth(40).SetText(time.Now().Format("2006-01-02")).SetChangedFunc(func(text string) {
		date, _ = time.Parse("2006-01-02", text)
	})
	hourInput := tview.NewInputField().SetLabel("    Due hour").SetFieldWidth(40).SetText(time.Now().Format("15:04")).SetChangedFunc(func(text string) {
		hour, _ = time.Parse("15:04", text)
	})

	return tview.NewForm().
		AddInputField("Description", "", 40, nil, func(text string) {
			description = text
		}).
		AddDropDown("Importance", []string{"Chill", "Mid", "Urgent"}, 0, func(option string, optionIndex int) {
			importance = optionIndex
		}).
		AddTextView("Existing projects", projectsStr, 40, 1, true, false).
		AddInputField("    Project", "", 40, nil, func(text string) {
			project = text
		}).
		AddCheckbox("No date", false, func(checked bool) {
			if checked {
				dateInput.SetText("No date assigned")
				dateInput.SetDisabled(true)
				ignoreDate = true
			} else {
				dateInput.SetText(time.Now().Format("2006-01-02"))
				dateInput.SetDisabled(false)
				ignoreDate = false
			}
		}).
		AddFormItem(dateInput).
		AddCheckbox("No hour", false, func(checked bool) {
			if checked {
				hourInput.SetText("No hour assigned")
				hourInput.SetDisabled(true)
				ignoreHour = true
			} else {
				hourInput.SetText(time.Now().Format("15:04"))
				hourInput.SetDisabled(false)
				ignoreHour = false
			}
		}).
		AddFormItem(hourInput).
		AddButton("Save", func() {
			var task task.Task
			task.Description = description
			task.Done = false
			task.Importance = importance
			task.Project = project
			task.Date = date.Add(time.Hour * time.Duration(hour.Hour())).Add(time.Minute * time.Duration(hour.Minute()))
			task.IgnoreHour = ignoreHour
			task.IgnoreDate = ignoreDate
			*tasks = append(*tasks, task)
			app.SetRoot(list, true)
		}).
		AddButton("Cancel", func() {
			app.SetRoot(list, true)
		}).
		SetFieldBackgroundColor(tcell.ColorDarkSlateBlue).
		SetButtonBackgroundColor(tcell.ColorDarkSlateBlue)
}

func contains(projects []string, project string) bool {
    for _, p := range projects {
        if p == project {
            return true
        }
    }
    return false
}
