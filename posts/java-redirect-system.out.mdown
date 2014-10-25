Categories: java
Tags: system.out
      bufferedwriter

### Redirect the output for a BufferedWriter to System.out ###


      BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(System.out));
      // do something with BufferedWriter ..
      bw.flush();
      bw.close();
      System.out.flush();