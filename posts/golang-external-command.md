Categories: golang
Tags: go
      golang
      command

    func lftpUpload(usnername string, password string, workingDir string) {
      lftpArguments := fmt.Sprintf(lftp, username, password, workingDir)
      glog.Infof("beginning ftp upload with:\n%s", lftp)
      out, err := exec.Command(lftpCmd, "-c", lftpArguments).CombinedOutput()

      if err != nil {
        glog.Fatalf("ERROR during upload :%s\n%s", err, out)
      } else {
        glog.Infof("uploaded successfully")
      }
    }


