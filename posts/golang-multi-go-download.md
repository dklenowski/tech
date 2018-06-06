Categories: golang
Tags: go
      golang
      thread
      goroutine

## A simple multi goroutine downloader


    var filesToDownloadCsv = ".."
    var downloadQueue = make(chan string)
    var downloadThreads = 105

    func process(ctx context.Context) error {
      g, ctx := errgroup.WithContext(ctx)

      // download
      for i := 0; i < downloadThreads; i++ {
        glog.Infof("starting downloader thread %d", i+1)
          g.Go(func() error {
            for {
              fileToDownload, more := <-downloadQueue
              if !more {
                return ctx.Err()
              }

              err := download(fileToDownload)
            }
            return nil
          })
      }

      // generation
      g.Go(func() error {
        defer close(downloadQueue)
  
        files := strings.Split(string(filesToDownloadCsv), "\n")
        for i, name := range files {
          if i == 0 {
            continue
          } else if regexp.MustCompile("^$").MatchString(name) {
            continue
          }
  
          select {
          case downloadQueue <- string(name):
          case <-ctx.Done():
            return ctx.Err()
          }
        }
        return nil
      })

      go func() {
        g.Wait()
      }()

      return g.Wait()
    }

    func main() {
      glog.Infof("running with maxprocs %d", runtime.GOMAXPROCS(0))

      ctx := context.Background()
      err := upload(ctx)
      process()

      if err != nil {
        glog.Fatal(err)
      }
