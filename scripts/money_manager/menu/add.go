
package menu

import (
	"github.com/rivo/tview"
	"time"
	"money/transfer"

	"github.com/gdamore/tcell/v2"
	"strconv"
)

type fn func(app *tview.Application, transfers *[]transfer.Transfer) *tview.List

func AddMenu(app *tview.Application, list fn, transfers *[]transfer.Transfer) *tview.Form {
	var description string
	var value float64

	return tview.NewForm().
		AddInputField("Description", "", 40, nil, func(text string) {
			description = text
		}).
		AddInputField("Value", "", 40, nil, func(text string) {
			value, _ = strconv.ParseFloat(text, 64)
		}).
		AddButton("Save", func() {
			var transfer transfer.Transfer
			transfer.Description = description
			transfer.Value = value
			transfer.Date = time.Now()
			*transfers = append(*transfers, transfer)
			l := list(app, transfers)
			app.SetRoot(l, true)
		}).
		AddButton("Cancel", func() {
			l := list(app, transfers)
			app.SetRoot(l, true)
		}).
		SetFieldBackgroundColor(tcell.ColorDarkSlateBlue).
		SetButtonBackgroundColor(tcell.ColorDarkSlateBlue)
}
