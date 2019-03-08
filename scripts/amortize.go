package main

import "time"
import "fmt"

type Date struct { year, month, day int; dtime time.Time }

type DateFreq int

const (
    Monthly DateFreq = iota
    BiWeekly
    TwiceMonthly
)

func main() {
    dates := generate_dates(365 * 15, Monthly)
    Amortize(0.04, 345000.0, 2600.0, dates)
    //Amortize(0.04, 345000.0, 1213.0, dates) }
}

func Amortize(apr float64, loan float64, pmt float64, dates []Date) {
    daily_apr := apr / 365
    principle := loan
    var interest, interest_accrued float64
    var days_elapsed int
    last_date := dates[0]
    paydates := dates[1:len(dates)]
    for i, date := range paydates {
        fmt.Printf("Date: %v, payment #%v, balance: %v\n", date.dtime, i, principle + interest)
        days_elapsed = days_between(last_date, date)
        interest_accrued = float64(days_elapsed) * daily_apr * principle
        fmt.Printf("days_elapsed: %v, interest_accrual: %v\n", days_elapsed, interest_accrued)
        interest += interest_accrued
        principle, interest = waterfall(principle, interest, pmt)
        last_date = date
    }
}

func generate_dates(length_days int, freq DateFreq) []Date {
    var dates []Date
    if freq == Monthly {
        num_months := length_days / 30
        dates = make([]Date, num_months)
    } else {
        num_biweeks := length_days / 14
        dates = make([]Date, num_biweeks)
    }
    dates[0] = Date{2019,1,1,time.Now()}
    dates[0].dtime = convtotime(2019,1,1)
    for i:=1; i < len(dates); i++ {
        dates[i] = dates[i-1]
        if freq == 1 {
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
