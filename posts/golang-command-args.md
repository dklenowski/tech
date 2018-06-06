Categories: golang
Tags: go
      golang
      args


    var username *string
    var password *string


    func main() {
        username = flag.String("username", "", "Botify FTP Username")
        password = flag.String("password", "", "Botify FTP Password")
        w
        if *username == "" || *password == "" {
            fmt.Print("missing username/password.")
            flag.Usage()
            os.Exit(1)
        }
    }
