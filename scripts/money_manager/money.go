package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"path/filepath"

	"strconv"

	// "path/filepath"
	"time"

	"money/transfer"
	"money/menu"

	"github.com/rivo/tview"
)

func main() {
	transfers := make([]transfer.Transfer, 0)
	transfers = loadTransfers()

	app := tview.NewApplication()

	list := mainList(app, &transfers)
	
	if err := app.SetRoot(list, true).SetFocus(list).Run(); err != nil {
		panic(err)
	}
	saveTransfers(transfers)

}

func mainList(app *tview.Application, transfers *[]transfer.Transfer) *tview.List {
	list := tview.NewList()
	list.AddItem("Total", fmt.Sprintf("%.2f", computeTotal(transfers)), 't', nil).
		AddItem("Add", "Add a new transfer", 'a', func() {
			app.SetRoot(menu.AddMenu(app, mainList, transfers), true)
		}).
		AddItem("List", "List all transfers", 'l', func() {
			app.SetRoot(menu.ListMenu(app, mainList, transfers), true)
		}).
		AddItem("Quit", "Exit program", 'q', func() {
			app.Stop()
		})
	return list

}

func computeTotal(transfers *[]transfer.Transfer) float64 {
	total := 0.0
	for _, t := range *transfers {
		total += t.Value
	}
	// add 100 per month since march 2023
	total += 100 * float64(time.Now().Sub(time.Date(2023, time.April, 1, 0, 0, 0, 0, time.UTC)).Hours()/24/30)

	return total
}

func loadTransfers() []transfer.Transfer {

	executablePath, err := os.Executable()
	absPath := filepath.Join(filepath.Dir(executablePath), "transfers.txt")

	file, err := os.Open(absPath)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)

	transfers := make([]transfer.Transfer, 0)
	currentTransfer := transfer.Transfer{}
	i := 0
	for scanner.Scan() {
		switch i % 4 {
		case 0:
			currentTransfer.Description = scanner.Text()
		case 1:
			currentTransfer.Value, _ = strconv.ParseFloat(scanner.Text(), 64)
		case 2:
			currentTransfer.Date, _ = time.Parse("2006-01-02 15:04:05", scanner.Text())
		default:
			transfers = append(transfers, currentTransfer)
		}
		i++
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return transfers
}

func saveTransfers(tranfers []transfer.Transfer) {

	executablePath, err := os.Executable()
	absPath := filepath.Join(filepath.Dir(executablePath), "transfers.txt")

	file, err := os.Create(absPath)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	// write to file
	for _, t := range tranfers {
		fmt.Fprintf(file, "%s\n", t.Description)
		fmt.Fprintf(file, "%f\n", t.Value)
		fmt.Fprintf(file, "%s\n\n", t.Date.Format("2006-01-02 15:04:05"))
	}
}
