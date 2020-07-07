package main

import "time"
import "fmt"
import "flag"
import color "github.com/logrusorgru/aurora"

type Date struct { year, month, day int; dtime time.Time }

type DateFreq int

const (
    Monthly DateFreq = iota
    BiWeekly
    TwiceMonthly
)

var debug = flag.Bool("debug", false, "output debug info about schedule")

func init() {
    flag.Parse()
}

// 186,706 principle, 2551.92 pmt monthly
// 27621 - 4 percent
// 21238 - 3.2 percent
// 19719 - 3 percent
// 18231 - 2.8 percent
func main() {

    dates := generate_dates(Date{2020,5,1,time.Now()}, 365 * 15, Monthly)
    Amortize(0.04, 186706.0, 2551.92, dates)
    // dates := generate_dates(Date{2018,6,1,time.Now()}, 365 * 15, Monthly)
    // Amortize(0.04, 345000.0, 2551.92, dates)
}

func Amortize(apr float64, loan float64, pmt float64, dates []Date) {
    daily_apr := apr / 365
    principle := loan
    var interest, interest_accrued, total_interest float64
    var days_elapsed int
    last_date := dates[0]
    paydates := dates[1:len(dates)]
    for i, date := range paydates {
        if *debug { fmt.Printf("Date: %v, payment #%v, balance: %v\n", date.dtime, i, principle + interest) }
        days_elapsed = days_between(last_date, date)
        interest_accrued = float64(days_elapsed) * daily_apr * principle
        if *debug { fmt.Printf("days_elapsed: %v, interest_accrual: %v\n", days_elapsed, interest_accrued) }
        interest += interest_accrued
        total_interest+= interest_accrued
        principle, interest = waterfall(principle, interest, pmt)
        last_date = date
    }
    fmt.Println(color.Bold("testing"))
    fmt.Printf("total_interest_paid: %v\n", total_interest)
}

func generate_dates(start_date Date, length_days int, freq DateFreq) []Date {
    var dates []Date
    if freq == Monthly {
        num_months := length_days / 30
        dates = make([]Date, num_months)
    } else {
        num_biweeks := length_days / 14
        dates = make([]Date, num_biweeks)
    }
    dates[0] = start_date
    dates[0].dtime = convtotime(start_date.year,start_date.month,start_date.day)
    for i:=1; i < len(dates); i++ {
        dates[i] = dates[i-1]
        if freq == Monthly {
            dates[i].dtime = dates[i-1].dtime.AddDate(0, 1, 0)
        } else {
            dates[i].dtime = dates[i-1].dtime.AddDate(0, 0, 14)
        }
    }
    //fmt.Println(dates)
    //for _, dat := range dates {
    //    fmt.Println(dat.dtime.Day(), dat.dtime.Month(), dat.dtime.Year())
    //}
    return dates
}

func days_between(startdate, enddate Date) int {
    //fmt.Println(enddate.dtime.Sub(startdate.dtime))
    return int(enddate.dtime.Sub(startdate.dtime).Hours() / 24)
}

func convtotime(year, month, day int) time.Time {
    loc, _ := time.LoadLocation("Local")
    return time.Date(year, time.Month(month), day, 0, 0, 0, 0, loc)
}

func waterfall(principle, interest, pmt float64) (prin, intr float64) {
    if interest > pmt {
        return principle, interest - pmt
    } else {
        if pmt > interest + principle {
            return 0,0
        } else {
            return principle - (pmt - interest), 0.0
        }
    }
}
