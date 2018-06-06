Categories: golang
Tags: go
      golang
      date


## Get the previous day

    oldwork := fmt.Sprintf("%s/%s", baseWork, time.Now().AddDate(0, 0, -2).Format("2006/01/02"))