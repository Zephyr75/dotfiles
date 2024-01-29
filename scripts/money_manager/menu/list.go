
package menu

import (
	"fmt"
	"money/transfer"

	"github.com/rivo/tview"

	"sort"

	"github.com/gdamore/tcell/v2"
)


func ListMenu(app *tview.Application, list fn, transfers *[]transfer.Transfer) *tview.Form {
	form := tview.NewForm()
	if len(*transfers) == 0 {
		form.AddTextView("No transfers yet", "", 40, 1, true, false)
	}

	sort.Slice(*transfers, func(i, j int) bool {
		return !(*transfers)[i].Date.Before((*transfers)[j].Date)
	})

	for _, t := range *transfers {
		if t.Value > 0 {
			form.AddTextView(fmt.Sprintf("[green] %f", t.Value), t.Description, 40, 1, true, false)
		} else {
			form.AddTextView(fmt.Sprintf("[red] %f", t.Value), t.Description, 40, 1, true, false)
		}

	}
	form.AddButton("Back", func() {
		l := list(app, transfers)
		app.SetRoot(l, true)
	})
	form.SetFieldBackgroundColor(tcell.ColorDarkSlateBlue)
	form.SetButtonBackgroundColor(tcell.ColorDarkSlateBlue)
	return form
}
