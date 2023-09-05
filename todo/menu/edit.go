package menu

import (
	"time"
	"todo/task"

	"github.com/rivo/tview"

	"github.com/gdamore/tcell/v2"
)

func EditMenu(app *tview.Application, list *tview.List, tasks *[]task.Task) *tview.Form {

	projects := make([]string, 0)
	var projectsStr string
	for _, t := range *tasks {
		if !contains(projects, t.Project) {
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
	ignoreDate := false
	ignoreHour := false

	descriptionInput := tview.NewInputField().SetLabel("Description").SetFieldWidth(40).SetChangedFunc(func(text string) {
    description = text
	})
	dropdownInput := tview.NewDropDown().SetLabel("Importance").SetOptions([]string{"Chill", "Mid", "Urgent"}, func(option string, optionIndex int) {
    importance = optionIndex
	})
	projectInput := tview.NewInputField().SetLabel("    Project").SetFieldWidth(40).SetChangedFunc(func(text string) {
    project = text
	})
	dateInput := tview.NewInputField().SetLabel("    Due date").SetFieldWidth(40).SetText(time.Now().Format("2006-01-02")).SetChangedFunc(func(text string) {
		date, _ = time.Parse("2006-01-02", text)
	})
	dateCheckbox := tview.NewCheckbox().SetLabel("No date").SetChangedFunc(func (checked bool) {
    if checked {
			dateInput.SetText("No date assigned")
			dateInput.SetDisabled(true)
			ignoreDate = true
		} else {
			dateInput.SetText(time.Now().Format("2006-01-02"))
			dateInput.SetDisabled(false)
			ignoreDate = false
		}
  })

	hourInput := tview.NewInputField().SetLabel("    Due hour").SetFieldWidth(40).SetText(time.Now().Format("15:04")).SetChangedFunc(func(text string) {
		hour, _ = time.Parse("15:04", text)
	})
	hourCheckbox := tview.NewCheckbox().SetLabel("No hour").SetChangedFunc(func (checked bool) {
    if checked {
			hourInput.SetText("No hour assigned")
			hourInput.SetDisabled(true)
			ignoreHour = true
		} else {
	hourInput.SetText(time.Now().Format("15:04"))
			hourInput.SetDisabled(false)
			ignoreHour = false
		}
  })

	tasksNames := make([]string, 0)
	for _, t := range *tasks {
		tasksNames = append(tasksNames, t.Description)
	}

	var index int

	return tview.NewForm().
		AddDropDown("Task to edit", tasksNames, 0, func(option string, optionIndex int) {
			index = optionIndex
			t := (*tasks)[optionIndex]
			descriptionInput.SetText(t.Description)
			dropdownInput.SetCurrentOption(t.Importance)
			projectInput.SetText(t.Project)
			date, _ = time.Parse("2006-01-02", t.Date.Format("2006-01-02"))
			dateInput.SetText(date.Format("2006-01-02"))
			hour, _ = time.Parse("15:04", t.Date.Format("15:04"))
			hourInput.SetText(hour.Format("15:04"))
			dateCheckbox.SetChecked(t.IgnoreDate)
			hourCheckbox.SetChecked(t.IgnoreHour)
		}).
		AddFormItem(descriptionInput).
		AddFormItem(dropdownInput).
		AddTextView("Existing projects", projectsStr, 40, 1, true, false).
		AddFormItem(projectInput).
		AddFormItem(dateCheckbox).
		AddFormItem(dateInput).
		AddFormItem(hourCheckbox).
		AddFormItem(hourInput).
		AddButton("Save", func() {
			(*tasks)[index].Description = description
			(*tasks)[index].Done = false
			(*tasks)[index].Importance = importance
			(*tasks)[index].Project = project
			(*tasks)[index].Date = date.Add(time.Hour * time.Duration(hour.Hour())).Add(time.Minute * time.Duration(hour.Minute()))
			(*tasks)[index].IgnoreDate = ignoreDate
			(*tasks)[index].IgnoreHour = ignoreHour
			app.SetRoot(list, true)
		}).
		AddButton("Cancel", func() {
			app.SetRoot(list, true)
		}).
		SetFieldBackgroundColor(tcell.ColorDarkSlateBlue).
		SetButtonBackgroundColor(tcell.ColorDarkSlateBlue)
}
