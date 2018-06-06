Categories: golang
Tags: go
      golang
      gzip


    import(
        "compress/gzip"
    )
    ..
    func compressFile(localfile string) error {
      gfile := fmt.Sprintf("%s.gz", localfile)
      glog.Infof("gzip'ing %s as %s", localfile, gfile)
      
      in, err := os.Open(localfile)
      if err != nil {
        glog.Warningf("error opening %s for reading: %s", localfile, err)
        return err
      }
      defer in.Close()
      
      out, err := os.OpenFile(gfile, os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0660)
      if err != nil {
        glog.Warningf("error opening %s for writing: %s", gfile, err)
        return err
      }
      defer out.Close()
      
      gf := gzip.NewWriter(out)
      defer gf.Close()
      
      _, err = io.Copy(gf, in)
      if err != nil {
        glog.Warningf("error gzip'ing file %s: %s", gfile, err)
        return err
      }

      // optional
      // os.Remove(localfile)
      return nil
    }
