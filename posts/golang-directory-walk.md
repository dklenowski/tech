Categories: golang
Tags: go
      golang
      directory
      dir
      walk

    func cleanup(basedir) {
      dir := fmt.Sprintf("%s/%s", basedir, time.Now().AddDate(0, 0, -2).Format("2006/01/02"))
      glog.Infof("cleaning up old work directory %s", dir)
      
      if _, err := os.Stat(dir); !os.IsNotExist(err) {
        files, _ := filepath.Glob(dir + "/*")
        for _, file := range files {
          if regexp.MustCompile(".*.gz$").MatchString(file) {
            os.Remove(file)
          }
        }
      }
    }