Categories: golang
Tags: go
      golang
      file
      io


    fh, err := os.OpenFile("/tmp/out.txt", os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0660)
    if err != nil {
      fmt.Printf("error opening file for writing : %s", err)
      os.Exit(1)
    }

    fw := bufio.NewWriter(fh)
    fw.WriteString(fmt.Sprintf("%s\n", var))
