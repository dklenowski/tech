Categories: mac
Tags: mac
      tokyocabinet

- Installing `tokyocabinet` on mac:

        $ tar -xzvf tokyocabinet-java-1.23.tar.gz
        $ cd tokyocabinet-java-1.23
        $ export MYJAVAHOME=/System/Library/Frameworks/JavaVM.framework/home
        $ make
        ...
        $ sudo make install

- Note, depending on the jdk, you may need to set the `CPPFLAGS` when compiling the java extensions:

        ./configure CPPFLAGS="-I/Library/Java/JavaVirtualMachines/jdk1.7.0_21.jdk/Contents/Home/include"

